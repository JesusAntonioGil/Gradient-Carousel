import Foundation


struct ImageModel: Identifiable {
    let id: String = UUID().uuidString
    let altText: String
    let image: String
}


let images: [ImageModel] = [
    .init(altText: "Mo Eid", image: "Pic 1"),
    .init(altText: "Codioful", image: "Pic 2"),
    .init(altText: "Cottonbro", image: "Pic 3"),
    .init(altText: "Anni", image: "Pic 4")
]