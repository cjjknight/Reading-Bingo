import SwiftUI

struct EditSquareView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    var row: Int
    var col: Int
    @State private var category: String = ""

    var body: some View {
        VStack {
            Text("Edit Category")
                .font(.headline)
                .padding()

            TextField("Category", text: $category)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                viewModel.updateSquare(row: row, col: col, category: category)
            }
            .padding()
        }
        .onAppear {
            let square = viewModel.currentBoard.squares[row][col]
            category = square.category
        }
    }
}

struct EditSquareView_Previews: PreviewProvider {
    static var previews: some View {
        EditSquareView(row: 0, col: 0)
            .environmentObject(BingoViewModel())
    }
}
