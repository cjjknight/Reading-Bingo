import Foundation

class BingoViewModel: ObservableObject {
    @Published var bingoBoards: [BingoBoard]
    @Published var currentBoard: BingoBoard
    @Published var isEditingBoardName = false
    @Published var isEditMode = false

    init() {
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

        let exampleBoard = BingoViewModel.createBoard(name: "Basic Book Bingo", categories: exampleCategories)
        let classicBoard = BingoViewModel.createBoard(name: "Classics", categories: classicCategories)
        let genreBoard = BingoViewModel.createBoard(name: "Genres", categories: genreCategories)

        self.bingoBoards = [exampleBoard, classicBoard, genreBoard]
        self.currentBoard = exampleBoard
    }

    static func createBoard(name: String, categories: [String]) -> BingoBoard {
        var squares = [[BingoSquare]]()
        var markers = [[Bool]]()
        for row in 0..<5 {
            var rowSquares = [BingoSquare]()
            var rowMarkers = [Bool]()
            for col in 0..<5 {
                let category = categories[row * 5 + col]
                rowSquares.append(BingoSquare(category: category))
                rowMarkers.append(false)
            }
            squares.append(rowSquares)
            markers.append(rowMarkers)
        }
        return BingoBoard(name: name, squares: squares, markers: markers)
    }

    func createNewBoard() {
        let newBoard = BingoBoard(name: "New Board", squares: Array(repeating: Array(repeating: BingoSquare(category: ""), count: 5), count: 5), markers: Array(repeating: Array(repeating: false, count: 5), count: 5))
        bingoBoards.append(newBoard)
        switchBoard(to: newBoard.id, editMode: true) // Default to edit mode
    }

    func switchBoard(to boardId: UUID, editMode: Bool = false) {
        if let board = bingoBoards.first(where: { $0.id == boardId }) {
            self.currentBoard = board
            self.isEditMode = editMode
        }
    }

    func updateSquare(row: Int, col: Int, category: String) {
        if let index = bingoBoards.firstIndex(where: { $0.id == currentBoard.id }) {
            bingoBoards[index].squares[row][col].category = category
            self.currentBoard = bingoBoards[index]
        }
    }

    func renameCurrentBoard(newName: String) {
        if let index = bingoBoards.firstIndex(where: { $0.id == currentBoard.id }) {
            bingoBoards[index].name = newName
            self.currentBoard = bingoBoards[index]
        }
    }

    func claimSquare(row: Int, col: Int, bookName: String, bookCoverURL: String?) {
        if let index = bingoBoards.firstIndex(where: { $0.id == currentBoard.id }) {
            bingoBoards[index].squares[row][col].bookTitle = bookName
            bingoBoards[index].squares[row][col].bookCoverURL = bookCoverURL
            bingoBoards[index].markers[row][col] = true
            self.currentBoard = bingoBoards[index]
        }
    }

    func unclaimSquare(row: Int, col: Int) {
        if let index = bingoBoards.firstIndex(where: { $0.id == currentBoard.id }) {
            bingoBoards[index].markers[row][col] = false
            bingoBoards[index].squares[row][col].bookTitle = nil
            bingoBoards[index].squares[row][col].bookCoverURL = nil
            self.currentBoard = bingoBoards[index]
        }
    }

    func deleteBoard(at indexSet: IndexSet) {
        bingoBoards.remove(atOffsets: indexSet)
        if bingoBoards.isEmpty {
            createNewBoard()
        } else {
            currentBoard = bingoBoards.first!
            self.isEditMode = false // Default to play mode
        }
    }
}
