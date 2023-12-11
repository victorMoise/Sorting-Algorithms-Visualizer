import Foundation

class RadixSort: SortAlgorithm {
    private var dataUpdater: DataUpdater?
    private var timer: Timer?
    private var passCount = 0 // Track the number of passes
    private var numberOfSwaps = 0
    private var numberOfComparisons = 0
    
    var passIteration: Int {
        return passCount
    }
    
    var swapCount: Int {
        return numberOfSwaps
    }
    
    var comparisonCount: Int {
        return numberOfComparisons
    }
    
    func sort(_ array: [Int], speedMultiplier: Double, onDataUpdate: @escaping ([Int]) -> Void) {
        var mutableArray = array // Create a mutable copy
        let maxValue = mutableArray.max() ?? 0 // Find the maximum value in the array
        
        var digitPlace = 1
        let n = mutableArray.count
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1 / speedMultiplier, repeats: true) { timer in
            var output = Array(repeating: 0, count: n)
            var count = Array(repeating: 0, count: 10)
            
            for i in 0..<n {
                let digit = (mutableArray[i] / digitPlace) % 10
                count[digit] += 1
            }
            
            for i in 1..<10 {
                count[i] += count[i - 1]
            }
            
            var i = n - 1
            while i >= 0 {
                let digit = (mutableArray[i] / digitPlace) % 10
                output[count[digit] - 1] = mutableArray[i]
                count[digit] -= 1
                i -= 1
            }
            
            for i in 0..<n {
                mutableArray[i] = output[i]
                onDataUpdate(mutableArray) // Send updated array to trigger UI update
            }
            
            digitPlace *= 10
            self.passCount += 1 // Increment the pass count
            
            if digitPlace > maxValue {
                // Sorting completed for all digits, invalidate the timer
                timer.invalidate()
            }
        }
    }
}

