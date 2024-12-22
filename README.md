# DynamicBorder
Animater dynamic border for SwiftUI views


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

https://github.com/user-attachments/assets/95ae484e-c8b1-492b-8108-b58fded48f9b

