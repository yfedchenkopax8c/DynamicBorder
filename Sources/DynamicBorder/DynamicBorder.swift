// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI

public struct DynamicBorderView<Content: View>: View {
    private let colors: [Color]
    private let lineLength: CGFloat
    private let lineThickness: CGFloat
    private let cornerRadius: CGFloat
    private let duration: Double
    private let content: () -> Content

    @State
    private var size: CGSize = .zero
    @State
    private var rotationDegree: CGFloat = 0

    private var adjustedSize: CGSize {
        if size.width > size.height {
            return CGSize(width: size.width * 2, height: lineLength)
        } else {
            return CGSize(width: lineLength, height: size.height * 2)
        }
    }

    private var startPoint: UnitPoint {
        if size.width > size.height {
            return .top
        } else {
            return .leading
        }
    }

    private var endPoint: UnitPoint {
        if size.width > size.height {
            return .bottom
        } else {
            return .trailing
        }
    }

    public init(
        color: Color = .red,
        lineLength: CGFloat = 140,
        lineThickness: CGFloat = 2,
        cornerRadius: CGFloat = 24,
        duration: Double = 4,
        content: @escaping () -> Content = { EmptyView() }
    ) {
        self.colors = [
            color.opacity(0.2),
            color.opacity(0.7),
            color, color, color, color,
            color.opacity(0.7),
            color.opacity(0.2)
        ]
        self.lineLength = lineLength
        self.lineThickness = lineThickness * 2
        self.cornerRadius = cornerRadius
        self.duration = duration
        self.content = content
    }

    public init(colors: [Color],
                lineLength: CGFloat = 140,
                lineThickness: CGFloat = 2,
                cornerRadius: CGFloat = 24,
                duration: Double = 4,
                content: @escaping () -> Content = { EmptyView() }
    ) {
        self.colors = colors
        self.lineLength = lineLength
        self.lineThickness = lineThickness * 2
        self.cornerRadius = cornerRadius
        self.duration = duration
        self.content = content
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.black)
            .readSize(to: $size)
            .overlay(content: {
                content()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            })
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(.linearGradient(.init(colors: colors), startPoint: startPoint, endPoint: endPoint))
                    .rotationEffect(.degrees(rotationDegree))
                    .mask {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(lineWidth: lineThickness)
                            .frame(width: size.width, height: size.height)
                    }
                    .mask {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .frame(width: size.width, height: size.height)
                    }
                    .frame(width: adjustedSize.width, height: adjustedSize.height)
            )
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    rotationDegree = 360
                }
            }
    }
}

#Preview("Small Height") {
    DynamicBorderView(lineLength: 140, lineThickness: 4, cornerRadius: 14, duration: 8, content: {
        ZStack {
            Color.gray
                .opacity(0.1)
            VStack {
                Text("Card")
                    .lineLimit(1)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
        }
    })
    .frame(width: 340, height: 80)
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .background(.black.opacity(0.85))
}

#Preview {
    DynamicBorderView(lineLength: 210, lineThickness: 4, cornerRadius: 40, content: {
        ZStack {
            Color.gray
                .opacity(0.1)
            VStack {
                Text("Card")
                    .lineLimit(1)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
        }
    })
    .frame(width: 340, height: 460)
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .background(.black.opacity(0.85))
}

#Preview("Liqued corners effect") {
    DynamicBorderView(lineLength: 440, lineThickness: 4, cornerRadius: 40, duration: 6)
        .frame(width: 340, height: 460)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(.black.opacity(0.85))
}

private extension View {
    func readSize(to size: Binding<CGSize>) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(
                key: SizePreferenceKey.self,
                value: proxy.size
            )
        })
        .onPreferenceChange(SizePreferenceKey.self) {
            size.wrappedValue = $0
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static let defaultValue: Value = .zero

    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}
