import SwiftUI

struct ContentView2: View {
    private var targetColor = Color.pink
    @State private var selectedColor = Color.red
    @State private var colorSimilarity = 0
    
    var body: some View {
        VStack {
            ImageView()
                .frame(width: 200, height: 200)
            
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(targetColor)
                
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(selectedColor)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct ImageView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "apple"))
        imageView.frame = CGRectMake(
                     imageView.frame.origin.x,
                     imageView.frame.origin.y, 200, 200)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator,
                                                              action: #selector(Coordinator.handleTap(_:))))
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ImageView
        
        init(_ parent: ImageView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let tappedLocation = gesture.location(in: gesture.view)
            if let color = getColorAtPosition(tappedLocation, in: gesture.view as! UIImageView) {
                print(color)
            }
        }
        
        private func getColorAtPosition(_ position: CGPoint, in imageView: UIImageView) -> UIColor? {
            guard let image = imageView.image else { return nil }
            
            let x = position.x * image.size.width / imageView.bounds.size.width
            let y = position.y * image.size.height / imageView.bounds.size.height
            
            guard let cgImage = image.cgImage else { return nil }
            let pixelData = cgImage.dataProvider?.data
            let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
            
            let bytesPerPixel = 4
            let bytesPerRow = bytesPerPixel * Int(image.size.width)
            let byteIndex = Int(y) * bytesPerRow + Int(x) * bytesPerPixel
            
            let red = CGFloat(data[byteIndex]) / 255.0
            let green = CGFloat(data[byteIndex + 1]) / 255.0
            let blue = CGFloat(data[byteIndex + 2]) / 255.0
            let alpha = CGFloat(data[byteIndex + 3]) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

#Preview {
    ContentView2()
}


// Add comment
