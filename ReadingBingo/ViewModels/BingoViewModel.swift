import Foundation

class BingoViewModel: ObservableObject {
    @Published var bingoBoards: [BingoBoard]
    @Published var currentBoard: BingoBoard
    @Published var markers: [[Bool]]

    init() {
        // Define default categories for three different boards
        let exampleCategories = [
            "Fantasy", "Science Fiction", "Mystery", "Biography", "Non-fiction",
            "Romance", "Thriller", "Historical", "Young Adult", "Classic",
            "Graphic Novel", "Horror", "Adventure", "Humor", "Self-help",
            "Poetry", "Drama", "Short Story", "Children's", "Dystopian",
            "Crime", "Memoir", "Paranormal", "Travel", "Cookbook"
        ]
        
        let classicCategories = [
            "To Kill a Mockingbird", "1984", "Pride and Prejudice", "The Great Gatsby", "Moby Dick",
            "War and Peace", "The Catcher in the Rye", "Crime and Punishment", "The Odyssey", "Les Misérables",
            "Jane Eyre", "The Brothers Karamazov", "Wuthering Heights", "Great Expectations", "Dracula",
            "A Tale of Two Cities", "Anna Karenina", "Madame Bovary", "The Iliad", "Heart of Darkness",
            "The Divine Comedy", "Frankenstein", "The Picture of Dorian Gray", "Don Quixote", "Brave New World"
        ]
        
        let genreCategories = [
            "Romantic Comedy", "Psychological Thriller", "Epic Fantasy", "Space Opera", "Hard Science Fiction",
            "Legal Thriller", "Historical Romance", "Military Science Fiction", "Steampunk", "Western",
            "Cyberpunk", "Urban Fantasy", "Paranormal Romance", "Time Travel", "Alternate History",
            "Detective Fiction", "Magical Realism", "Post-apocalyptic", "Superhero", "Gothic Fiction",
            "Spy Fiction", "Mythopoeia", "Sword and Sorcery", "Technothriller", "Weird Fiction"
        ]

        // Create the boards using a static method
        let exampleBoard = BingoViewModel.createBoard(name: "Example", categories: exampleCategories)
        let classicBoard = BingoViewModel.createBoard(name: "Classics", categories: classicCategories)
        let genreBoard = BingoViewModel.createBoard(name: "Genres", categories: genreCategories)

        self.bingoBoards = [exampleBoard, classicBoard, genreBoard]
        self.currentBoard = exampleBoard
        self.markers = Array(repeating: Array(repeating: false, count: 5), count: 5)
    }

    static func createBoard(name: String, categories: [String]) -> BingoBoard {
        var squares = [[BingoSquare]]()
        for row in 0..<5 {
            var rowSquares = [BingoSquare]()
            for col in 0..<5 {
                let category = categories[row * 5 + col]
                rowSquares.append(BingoSquare(category: category))
            }
            squares.append(rowSquares)
        }
        return BingoBoard(name: name, squares: squares)
    }

    func switchBoard(to boardId: UUID) {
        if let board = bingoBoards.first(where: { $0.id == boardId }) {
            self.currentBoard = board
            self.markers = Array(repeating: Array(repeating: false, count: 5), count: 5)
        }
    }

    func toggleMarker(row: Int, col: Int) {
        markers[row][col].toggle()
    }
}
