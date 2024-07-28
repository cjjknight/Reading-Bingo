import Foundation

struct BingoSquare: Identifiable, Hashable {
    var id = UUID()
    var category: String
    var marked: Bool = false
}

struct BingoBoard: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var squares: [[BingoSquare]]
    var markers: [[Bool]] // Add this line to store marker states

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    static func == (lhs: BingoBoard, rhs: BingoBoard) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
