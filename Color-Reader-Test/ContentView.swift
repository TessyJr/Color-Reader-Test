import SwiftUI

struct ContentView: View {
    private var targetColor = Color.pink
    @State private var selectedColor = Color.red
    @State private var colorSimilarity = 0
    
    var body: some View {
        VStack {
            Image("apple")
                .resizable()
                .frame(width: 200, height: 200)
            
            ColorPicker("Set the circle color", selection: $selectedColor)
            
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(targetColor)
                
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(selectedColor)
            }
            
            Text("Color Similarity: \(colorSimilarity)%")
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            calculateColorSimilarity()
        }
        .onChange(of: selectedColor) {
            calculateColorSimilarity()
        }
    }
    
    private func calculateColorSimilarity() {
        guard let targetComponents = targetColor.components(),
              let selectedComponents = selectedColor.components() else {
            return
        }
        
        let redDiff = abs(targetComponents.red - selectedComponents.red)
        let greenDiff = abs(targetComponents.green - selectedComponents.green)
        let blueDiff = abs(targetComponents.blue - selectedComponents.blue)
        
        let totalDiff = redDiff + greenDiff + blueDiff
        let similarity = 100 - Int((Double(totalDiff) / 3.0) * 100)
        colorSimilarity = max(0, similarity)
    }
}

extension Color {
    func components() -> (red: Double, green: Double, blue: Double)? {
        if let components = UIColor(self).cgColor.components, components.count >= 3 {
            return (Double(components[0]), Double(components[1]), Double(components[2]))
        }
        return nil
    }
}

/*
 1. Extract RGB components: First, I extracted the RGB components of both the targetColor and selectedColor. This involves retrieving the red, green, and blue values of each color.
 
 2. Calculate differences: Next, I calculated the absolute differences between the corresponding RGB components of the two colors. This gives us the difference in intensity between each color channel.
 
 3. Total difference: I summed up the absolute differences in the red, green, and blue channels to get the total difference between the colors. This represents how much the colors differ overall.
 
 4. Convert to similarity percentage: To express the similarity in a more intuitive way, I converted the total difference to a similarity percentage. I did this by subtracting the total difference from the maximum possible difference (assuming each color channel ranges from 0 to 255), and then scaling it to a percentage.
 4. Convert to similarity percentage: To express the similarity in a more intuitive way, I converted the total difference to a similarity percentage. I did this by subtracting the total difference from the maximum possible difference (assuming each color channel ranges from 0 to 255), and then scaling it to a percentage.
 */

#Preview {
    ContentView()
}
