import Foundation

class BucketSort: SortAlgorithm {
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
        
        let mutableArray = array // Create a mutable copy of the input array
        
        let maxVal = mutableArray.max() ?? 0
        var buckets: [[Int]] = Array(repeating: [], count: mutableArray.count)
        
        var i = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1 / speedMultiplier, repeats: true) { timer in
            if i < mutableArray.count {
                let bucketIndex = Int(Double(mutableArray[i]) / Double(maxVal + 1) * Double(mutableArray.count))
                buckets[bucketIndex].append(mutableArray[i])
                onDataUpdate(buckets.flatMap { $0 }) // Update with intermediate state
                i += 1
            } else {
                var sortedArray: [Int] = []
                for j in 0..<buckets.count {
                    buckets[j].sort()
                    sortedArray += buckets[j]
                    onDataUpdate(sortedArray) // Update with final state
                }
                timer.invalidate()
            }
        }
    }
}
