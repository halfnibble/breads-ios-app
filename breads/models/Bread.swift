import Foundation

struct Bread: Identifiable, Decodable {
    let id: String
    let name: String
    let hasGluten: Bool
    let image: String
    let baker: String
}

let Bakers = ["Rachel", "Monica", "Joey", "Chandler", "Ross", "Phoebe"]
