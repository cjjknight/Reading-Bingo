import Foundation

struct BingoSquare: Identifiable {
    var id = UUID()
    var category: String
    var marked: Bool = false
}

struct BingoBoard {
    var squares: [[BingoSquare]]
}
