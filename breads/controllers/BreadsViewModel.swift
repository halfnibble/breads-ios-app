import Foundation

class BreadsViewModel: ObservableObject {
    @Published var breads: [Bread] = []
    
    func fetchBreads() {
        API.shared.fetchBreads { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let breads):
                    self.breads = breads
                case .failure(let error):
                    print("Error fetching breads: \(error.localizedDescription)")
                }
            }
        }
    }
}
