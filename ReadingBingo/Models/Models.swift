import Foundation

struct BingoSquare: Identifiable, Hashable {
    var id = UUID()
    var category: String
    var marked: Bool = false
    var bookTitle: String? // Add this to store the book title if the spot is claimed

    init(category: String) {
        self.category = category
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(category)
        hasher.combine(marked)
        hasher.combine(bookTitle)
    }

    static func == (lhs: BingoSquare, rhs: BingoSquare) -> Bool {
        return lhs.id == rhs.id &&
               lhs.category == rhs.category &&
               lhs.marked == rhs.marked &&
               lhs.bookTitle == rhs.bookTitle
    }
}

struct BingoBoard: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var squares: [[BingoSquare]]
    var markers: [[Bool]]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    static func == (lhs: BingoBoard, rhs: BingoBoard) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

struct SquareIdentifier: Identifiable {
    var id: UUID
    var row: Int
    var col: Int

    init(row: Int, col: Int) {
        self.id = UUID()
        self.row = row
        self.col = col
    }
}
