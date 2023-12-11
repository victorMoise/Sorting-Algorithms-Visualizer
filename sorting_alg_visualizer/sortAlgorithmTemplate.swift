import Foundation

protocol SortAlgorithm {
    var swapCount: Int { get }
    var comparisonCount: Int { get }
    
    func sort(_ array: [Int], speedMultiplier: Double, onDataUpdate: @escaping ([Int]) -> Void)
}
