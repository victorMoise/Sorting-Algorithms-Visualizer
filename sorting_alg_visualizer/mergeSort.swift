import Foundation

class MergeSort: SortAlgorithm {
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

        func mergeSort(_ low: Int, _ high: Int) {
            if low < high {
                let mid = (low + high) / 2
                mergeSort(low, mid)
                mergeSort(mid + 1, high)
                merge(low, mid, high)
                onDataUpdate(mutableArray) // Send updated array to trigger UI update
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1 / speedMultiplier)) // Introduce delay
            }
        }

        func merge(_ low: Int, _ mid: Int, _ high: Int) {
            let leftArray = Array(mutableArray[low...mid])
            let rightArray = Array(mutableArray[mid + 1...high])

            var i = low
            var j = 0
            var k = 0

            while j < leftArray.count, k < rightArray.count {
                numberOfComparisons += 1 // Increase comparison count
                if leftArray[j] <= rightArray[k] {
                    mutableArray[i] = leftArray[j]
                    j += 1
                } else {
                    mutableArray[i] = rightArray[k]
                    numberOfSwaps += mid - i + 1 // Increase swap count
                    k += 1
                }
                i += 1
            }

            while j < leftArray.count {
                mutableArray[i] = leftArray[j]
                j += 1
                i += 1
            }

            while k < rightArray.count {
                mutableArray[i] = rightArray[k]
                k += 1
                i += 1
            }
        }

        onDataUpdate(mutableArray) // Send initial state to trigger UI update
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
            // Start the mergesort algorithm
            mergeSort(0, n - 1)
            // Sorting completed, invalidate the timer
            timer.invalidate()
        }
    }
}
