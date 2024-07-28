import SwiftUI

struct EditSquareView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    var row: Int
    var col: Int
    @State private var category: String = ""
    @State private var bookName: String = ""

    var body: some View {
        VStack {
            if viewModel.isEditMode {
                TextField("Category", text: $category)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Save") {
                    viewModel.updateSquare(row: row, col: col, category: category)
                }
                .padding()
            } else {
                TextField("Book Name", text: $bookName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack {
                    Button("Save") {
                        viewModel.claimSquare(row: row, col: col, bookName: bookName)
                    }
                    .padding()
                    Button("Unclaim") {
                        viewModel.unclaimSquare(row: row, col: col)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            if viewModel.isEditMode {
                category = viewModel.currentBoard.squares[row][col].category
            } else {
                bookName = viewModel.currentBoard.squares[row][col].bookTitle ?? ""
            }
        }
    }
}
