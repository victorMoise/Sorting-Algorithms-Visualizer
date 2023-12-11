import SwiftUI

struct ChartGenerator {
    static func generateChart(for numbers: [Int], observableObject: DataUpdater) -> some View {
        GeometryReader { geometry in
            let maxHeight = geometry.size.height - 20
            
            HStack(spacing: 2) {
                ForEach(numbers, id: \.self) { number in
                    let columnHeight = CGFloat(number) * maxHeight / CGFloat(numbers.max() ?? 1)
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: (geometry.size.width - CGFloat(numbers.count * 2)) / CGFloat(numbers.count),
                                   height: columnHeight)
                    }
                }
            }
        }
        .onReceive(observableObject.objectWillChange) { _ in
            // This closure will be called whenever the observable object changes
            // Example: Call any function or method to update the chart
        }
    }
}
