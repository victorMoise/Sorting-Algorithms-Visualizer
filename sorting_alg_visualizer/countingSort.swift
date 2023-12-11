import Foundation

class CountingSort: SortAlgorithm {
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
        
        var mutableArray = array // Create a mutable copy of the input array
        
        // Find maximum value to determine counting array size
        let maxVal = mutableArray.max() ?? 0
        
        // Create a counting array to store the count of each element
        var countArray = Array(repeating: 0, count: maxVal + 1)
        
        // Store the count of each element in the input array
        for num in mutableArray {
            countArray[num] += 1
        }
        
        var currentIndex = 0
        var i = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1 / speedMultiplier, repeats: true) { timer in
            if i < countArray.count {
                if countArray[i] > 0 {
                    mutableArray[currentIndex] = i
                    countArray[i] -= 1
                    onDataUpdate(mutableArray) // Update with intermediate state
                    currentIndex += 1
                } else {
                    i += 1
                }
            } else {
                onDataUpdate(mutableArray) // Update with final state
                timer.invalidate()
            }
        }
    }
}
