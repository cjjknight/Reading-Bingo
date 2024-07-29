import Foundation

class BingoViewModel: ObservableObject {
    @Published var bingoBoards: [BingoBoard]
    @Published var currentBoard: BingoBoard
    @Published var isEditingBoardName = false
    @Published var isEditMode = false
    @Published var currentUserName: String = "User"

    init() {
        // Load boards from persistent storage
        if let loadedBoards = Self.loadBoards(), let loadedCurrentBoard = Self.loadCurrentBoard() {
            self.bingoBoards = loadedBoards
            self.currentBoard = loadedCurrentBoard
        } else {
            // Example board setup with owner and players
            let exampleCategories = [
                "Fantasy", "Science Fiction", "Mystery", "Biography", "Non-fiction",
                "Romance", "Thriller", "Historical", "Young Adult", "Classic",
                "Graphic Novel", "Horror", "Adventure", "Humor", "Self-help",
                "Poetry", "Drama", "Short Story", "Children's", "Dystopian",
                "Crime", "Memoir", "Paranormal", "Travel", "Cookbook"
            ]

            let exampleBoard = BingoViewModel.createBoard(name: "Example", categories: exampleCategories, owner: "Owner1", players: ["User1", "User2"])
            self.bingoBoards = [exampleBoard]
            self.currentBoard = exampleBoard
        }
    }

    static func createBoard(name: String, categories: [String], owner: String, players: [String]) -> BingoBoard {
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
        return BingoBoard(name: name, squares: squares, markers: markers, owner: owner, players: players)
    }

    func createNewBoard() {
        let newBoard = BingoBoard(
            name: "New Board",
            squares: Array(repeating: Array(repeating: BingoSquare(category: ""), count: 5), count: 5),
            markers: Array(repeating: Array(repeating: false, count: 5), count: 5),
            owner: currentUserName,
            players: [currentUserName]
        )
        bingoBoards.append(newBoard)
        switchBoard(to: newBoard.id, editMode: true) // Default to edit mode
    }

    func switchBoard(to boardId: UUID, editMode: Bool = false) {
        if let board = bingoBoards.first(where: { $0.id == boardId }) {
            self.currentBoard = board
            self.isEditMode = editMode && (board.owner == currentUserName || currentUserName == "Admin")
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

    func saveBoards() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(bingoBoards) {
            UserDefaults.standard.set(encoded, forKey: "bingoBoards")
        }
    }

    private static func loadBoards() -> [BingoBoard]? {
        if let savedData = UserDefaults.standard.data(forKey: "bingoBoards") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([BingoBoard].self, from: savedData) {
                return decoded
            }
        }
        return nil
    }

    private static func loadCurrentBoard() -> BingoBoard? {
        if let savedData = UserDefaults.standard.data(forKey: "currentBoard") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(BingoBoard.self, from: savedData) {
                return decoded
            }
        }
        return nil
    }
}
