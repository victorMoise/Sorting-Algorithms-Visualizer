import SwiftUI


struct ContentView: View {
    @State private var numbers: [Int] = []
    @State private var userInput = "100"
    @State private var validSize = true
    @StateObject var dataUpdater = DataUpdater()
    @State private var swaps = 0
    @State private var comparisons = 0
    @FocusState private var isTextFieldFocused: Bool
    @State private var speedMultiplier = "1.0"
    @State private var validSpeed = true
    @State private var isArraySorted = false
    @State private var selectedSortIndex = -1
    
    let sortingAlgorithms: [(index: Int, label: String)] = [
        (1, "Bubble Sort"),
        (2, "Insertion Sort"),
        (3, "Selection Sort"),
        (4, "Quick Sort"),
        (5, "Merge Sort"),
        (6, "Heap Sort"),
        (7, "Radix Sort"),
        (8, "Bucket Sort"),
        (9, "Counting Sort")
    ]

    private func resetSwapsAndComparisons() {
        self.swaps = 0
        self.comparisons = 0
    }
    
    private func validUserSize() -> Bool {
        if let size = Int(userInput), size <= 500 {
            validSize = true
            return true
        } else {
            validSize = false
            return false
        }
    }
    
    private func validUserSpeed() -> Bool {
        if let speed = Double(speedMultiplier), speed <= 50.0 {
            validSpeed = true
            return true
        } else {
            validSpeed = false
            return false
        }
    }
    
    private func generateNumbers() {
        if let size = Int(userInput), validUserSize(), validUserSpeed() {
            numbers = generateAndShuffleNumbers(upTo: size)
        }
    }
    
    private func displayTextAfterTheSortButtons() -> some View {
        VStack {
            Text("DO NOT generate another set of numbers while a sorting algorithm is running!")
            
            // Display additional text about various sorting algorithms,
            // right now only radix sort needs extra info
            if isArraySorted && (selectedSortIndex == 7 || selectedSortIndex == 8 || selectedSortIndex == 9) {
                Text("Radix, Bucket and Counting sorts do not work like the normal sorting algorithms, thus there is no comparison and swap count")
            }
            
            if selectedSortIndex == 7 {
                Text("Radix sort operates quickly; consider reducing the simulation speed to observe its sorting process more closely.")
            }
        }
    }
    
    func sortingAlgorithmButton(index: Int, label: String) -> some View {
        return Button(action: {
            selectedSortIndex = index
            isArraySorted = true
            startSorting()
        }) {
            Text("\(label)")
        }
        .disabled(isArraySorted)
    }
    
    private func startSorting() {
        guard let speed = Double(speedMultiplier) else { return }
        
        var sortingAlgorithm: SortAlgorithm?

        switch selectedSortIndex {
        case 1:
            sortingAlgorithm = BubbleSort()
        case 2:
            sortingAlgorithm = InsertionSort()
        case 3:
            sortingAlgorithm = SelectionSort()
        case 4:
            sortingAlgorithm = QuickSort()
        case 5:
            sortingAlgorithm = MergeSort()
        case 6:
            sortingAlgorithm = HeapSort()
        case 7:
            sortingAlgorithm = RadixSort()
        case 8:
            sortingAlgorithm = BucketSort()
        case 9:
            sortingAlgorithm = CountingSort()
        default:
            break
        }

        sortingAlgorithm?.sort(numbers, speedMultiplier: speed) { sortedArray in
            self.numbers = sortedArray
            self.swaps = sortingAlgorithm?.swapCount ?? 0
            self.comparisons = sortingAlgorithm?.comparisonCount ?? 0
        }
    }

    
    var body: some View {
        VStack {
            Text("Sorting Algorithms Visualizer")
            
            HStack { // Contains the input field and the generate button
                Text("Simulation size (max 500):")
                    .foregroundColor(.secondary)
                
                TextField("Enter a number between 1 and 500", text: $userInput)
                    .focused($isTextFieldFocused)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .foregroundColor(validSize ? .primary : .red)
                
                Text("Simulation speed: ")
                    .foregroundColor(.secondary)
                
                TextField("Enter a number between 0.1 and 10:", text: $speedMultiplier)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .foregroundColor(validSpeed ? .primary : .red)
                
                Button(action: {
                    generateNumbers()
                    resetSwapsAndComparisons()
                    isTextFieldFocused = false
                    isArraySorted = false
                }) {
                    Text("Generate")
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 20)

            VStack { // Contains number of swaps and comparisons and all sort buttons
                Text("Number of swaps: \(swaps), Number of comparisons: \(comparisons)")
                
                HStack { // Contains all of the sort buttons
                    ForEach(sortingAlgorithms, id: \.index) { algorithm in
                        sortingAlgorithmButton(index: algorithm.index, label: algorithm.label)
                    }
                }
                
                displayTextAfterTheSortButtons()
            }
            
            
            if !numbers.isEmpty { // Generates the initial chart, before any sorting
                ChartGenerator.generateChart(for: numbers, observableObject: dataUpdater)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
}
