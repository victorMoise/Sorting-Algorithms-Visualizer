import SwiftUI
import Combine

class InsertionSort: SortAlgorithm {
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
        guard n > 1 else { return }

        var i = 1
        timer = Timer.scheduledTimer(withTimeInterval: 0.1 / speedMultiplier, repeats: true) { timer in
            if i < n {
                var j = i
                while j > 0 {
                    self.numberOfComparisons += 1 // Increase comparison count
                    if mutableArray[j - 1] > mutableArray[j] {
                        self.numberOfSwaps += 1 // Increase swap count
                        mutableArray.swapAt(j - 1, j)
                        onDataUpdate(mutableArray) // Send updated array to trigger UI update
                        j -= 1
                    } else {
                        break // No need to continue inner loop if the condition is false
                    }
                }

                i += 1
            } else {
                // Sorting completed, invalidate the timer
                timer.invalidate()
            }
        }
    }
}
