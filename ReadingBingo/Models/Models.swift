import Foundation

struct BingoSquare: Identifiable, Hashable, Codable {
    var id = UUID()
    var category: String
    var marked: Bool = false
    var bookTitle: String? // Store the book title if the spot is claimed
    var bookCoverURL: String? // Store the book cover URL if the spot is claimed

    init(category: String) {
        self.category = category
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(category)
        hasher.combine(marked)
        hasher.combine(bookTitle)
        hasher.combine(bookCoverURL)
    }

    static func == (lhs: BingoSquare, rhs: BingoSquare) -> Bool {
        return lhs.id == rhs.id &&
               lhs.category == rhs.category &&
               lhs.marked == rhs.marked &&
               lhs.bookTitle == rhs.bookTitle &&
               lhs.bookCoverURL == rhs.bookCoverURL
    }
}

struct BingoBoard: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var squares: [[BingoSquare]]
    var markers: [[Bool]]
    var owner: String
    var players: [String]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(owner)
    }

    static func == (lhs: BingoBoard, rhs: BingoBoard) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.owner == rhs.owner
    }
}

struct SquareIdentifier: Identifiable, Codable {
    var id: UUID
    var row: Int
    var col: Int

    init(row: Int, col: Int) {
        self.id = UUID()
        self.row = row
        self.col = col
    }
}
