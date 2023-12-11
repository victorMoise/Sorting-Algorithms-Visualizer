func generateAndShuffleNumbers(upTo n: Int) -> [Int] {
    var generatedArray = generateArray(upTo: n)
    shuffleArray(&generatedArray)
    return generatedArray
}

// create the numbers array
func generateArray(upTo n: Int) -> [Int] {
    guard n >= 0 else { return [] }
    return Array(1...n)
}

// shuffle the generated array of numbers
func shuffleArray<T>(_ array: inout [T]) {
    
    guard array.count > 1 else { return }

    for i in 0..<(array.count - 1) {
        let randomIndex = Int.random(in: i..<array.count)
        if i != randomIndex {
            array.swapAt(i, randomIndex)
        }
    }
}
