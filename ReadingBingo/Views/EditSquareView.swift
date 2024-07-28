import SwiftUI

struct EditSquareView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    var row: Int
    var col: Int
    @State private var category: String = ""

    var body: some View {
        VStack {
            TextField("Category", text: $category)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Save") {
                viewModel.updateSquare(row: row, col: col, category: category)
            }
            .padding()
        }
        .onAppear {
            category = viewModel.currentBoard.squares[row][col].category
        }
    }
}
