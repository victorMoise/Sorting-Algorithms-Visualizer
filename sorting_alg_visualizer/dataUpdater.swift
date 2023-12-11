import Combine

class DataUpdater: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
}
