import Foundation

class SelectionSort: SortAlgorithm {
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

        var i = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1 / speedMultiplier, repeats: true) { timer in
            if i < n - 1 {
                var minIndex = i
                for j in i+1..<n {
                    self.numberOfComparisons += 1 // Increase comparison count
                    if mutableArray[j] < mutableArray[minIndex] {
                        minIndex = j
                    }
                }
                if minIndex != i {
                    self.numberOfSwaps += 1 // Increase swap count 
                    mutableArray.swapAt(i, minIndex)
                    onDataUpdate(mutableArray) // Send updated array to trigger UI update
                }
                i += 1
            } else {
                // Sorting completed, invalidate the timer
                timer.invalidate()
            }
        }
    }
}

