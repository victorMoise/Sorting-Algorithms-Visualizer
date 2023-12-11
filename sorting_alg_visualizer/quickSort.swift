import Foundation

class QuickSort: SortAlgorithm {
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
    private var mutableArray: [Int] = []

    func sort(_ array: [Int], speedMultiplier: Double, onDataUpdate: @escaping ([Int]) -> Void) {
        numberOfSwaps = 0 // Reset the number of swaps
        numberOfComparisons = 0 // Reset the number of comparisons
        
        mutableArray = array // Create a mutable copy
        let n = mutableArray.count
        guard n > 1 else { return }

        func quicksort(_ low: Int, _ high: Int) {
            if low < high {
                let pivot = partition(low, high)
                onDataUpdate(mutableArray) // Send updated array to trigger UI update
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1 / speedMultiplier)) // Introduce delay
                quicksort(low, pivot - 1)
                quicksort(pivot + 1, high)
            } else {
                onDataUpdate(mutableArray) // Send updated array to trigger UI update (final state of partition)
            }
        }

        func partition(_ low: Int, _ high: Int) -> Int {
            let pivot = mutableArray[high]
            var i = low
            for j in low..<high {
                numberOfComparisons += 1 // Increase comparison count
                if mutableArray[j] <= pivot {
                    mutableArray.swapAt(i, j)
                    i += 1
                    numberOfSwaps += 1 // Increase swap count
                }
            }
            numberOfSwaps += 1 // Increase swap count
            mutableArray.swapAt(i, high)
            return i
        }

        onDataUpdate(mutableArray) // Send initial state to trigger UI update
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
            // Start the quicksort algorithm
            quicksort(0, n - 1)
            // Sorting completed, invalidate the timer
            timer.invalidate()
        }
    }
}
