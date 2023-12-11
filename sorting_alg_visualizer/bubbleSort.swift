import SwiftUI
import Combine

class BubbleSort: SortAlgorithm {
    private var numberOfSwaps = 0
    private var numberOfComparisons = 0
    
    var swapCount: Int {
        return numberOfSwaps
    }
    
    var comparisonCount: Int {
        return numberOfComparisons
    }
    
    var dataUpdater: DataUpdater?
    private var timer: Timer?
    

    func sort(_ array: [Int], speedMultiplier: Double, onDataUpdate: @escaping ([Int]) -> Void) {
        self.numberOfSwaps = 0 // Reset the number of swaps
        self.numberOfComparisons = 0 // Reset the number of comparisons
        
        var mutableArray = array // Create a mutable copy
        let n = mutableArray.count

        var i = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1 / speedMultiplier, repeats: true) { timer in
            if i < n {
                var swapped = false
                for j in 0..<n-i-1 {
                    self.numberOfComparisons += 1 // Increase comparison count
                    if mutableArray[j] > mutableArray[j + 1] {
                        self.numberOfSwaps += 1 // Increase swap count
                        mutableArray.swapAt(j, j + 1)
                        onDataUpdate(mutableArray) // Send updated array to trigger UI update
                        swapped = true
                    }
                }
                if !swapped {
                    // If no swaps occurred in this pass, sorting is done
                    timer.invalidate()
                }
                i += 1
            } else {
                // Sorting completed, invalidate the timer
                timer.invalidate()
            }
        }
    }
}
