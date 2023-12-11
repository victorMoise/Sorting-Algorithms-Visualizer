import SwiftUI
import Combine

class HeapSort: SortAlgorithm {
    private var numberOfSwaps = 0
    private var numberOfComparisons = 0
    private var heapArray: [Int] = []
    
    var swapCount: Int {
        return numberOfSwaps
    }
    
    var comparisonCount: Int {
        return numberOfComparisons
    }
    
    var dataUpdater: DataUpdater?
    private var timer: Timer?
    
    func sort(_ array: [Int], speedMultiplier: Double, onDataUpdate: @escaping ([Int]) -> Void) {
        self.numberOfSwaps = 0
        self.numberOfComparisons = 0
        
        self.heapArray = array
        var heapSize = heapArray.count
        
        buildMaxHeap(&heapSize, onDataUpdate)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1 / speedMultiplier, repeats: true) { timer in
            if heapSize > 1 {
                self.numberOfSwaps += 1
                self.heapArray.swapAt(0, heapSize - 1)
                onDataUpdate(self.heapArray)
                heapSize -= 1
                self.heapify(&heapSize, 0, onDataUpdate)
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func buildMaxHeap(_ heapSize: inout Int, _ onDataUpdate: @escaping ([Int]) -> Void) {
        for i in (0...(heapSize / 2 - 1)).reversed() {
            heapify(&heapSize, i, onDataUpdate)
        }
    }
    
    private func heapify(_ heapSize: inout Int, _ i: Int, _ onDataUpdate: @escaping ([Int]) -> Void) {
        var largest = i
        let left = 2 * i + 1
        let right = 2 * i + 2
        
        self.numberOfComparisons += 1
        
        if left < heapSize && heapArray[left] > heapArray[largest] {
            largest = left
        }
        
        if right < heapSize && heapArray[right] > heapArray[largest] {
            largest = right
        }
        
        if largest != i {
            self.numberOfSwaps += 1
            heapArray.swapAt(i, largest)
            onDataUpdate(heapArray)
            heapify(&heapSize, largest, onDataUpdate)
        }
    }
}
