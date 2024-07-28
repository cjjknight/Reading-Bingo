import Foundation

class BingoViewModel: ObservableObject {
    @Published var bingoBoard: BingoBoard
    @Published var markers: [[Bool]]

    init() {
        // Initialize a 5x5 bingo board with predefined categories
        let defaultCategories = [
            "Fantasy", "Science Fiction", "Mystery", "Biography", "Non-fiction",
            "Romance", "Thriller", "Historical", "Young Adult", "Classic",
            "Graphic Novel", "Horror", "Adventure", "Humor", "Self-help",
            "Poetry", "Drama", "Short Story", "Children's", "Dystopian",
            "Crime", "Memoir", "Paranormal", "Travel", "Cookbook"
        ]

        var squares = [[BingoSquare]]()
        for row in 0..<5 {
            var rowSquares = [BingoSquare]()
            for col in 0..<5 {
                let category = defaultCategories[row * 5 + col]
                rowSquares.append(BingoSquare(category: category))
            }
            squares.append(rowSquares)
        }
        
        self.bingoBoard = BingoBoard(squares: squares)
        self.markers = Array(repeating: Array(repeating: false, count: 5), count: 5)
    }

    func toggleMarker(row: Int, col: Int) {
        markers[row][col].toggle()
    }
}
