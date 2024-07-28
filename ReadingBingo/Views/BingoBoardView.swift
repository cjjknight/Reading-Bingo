import SwiftUI

struct BingoBoardView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    @State private var selectedSquare: SquareIdentifier?
    let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<5) { row in
                    ForEach(0..<5) { col in
                        Button(action: {
                            selectedSquare = SquareIdentifier(row: row, col: col)
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(viewModel.currentBoard.markers[row][col] ? Color.green : Color.gray)
                                    .frame(height: 60)
                                Text(viewModel.currentBoard.markers[row][col] ? viewModel.currentBoard.squares[row][col].bookTitle ?? "" : viewModel.currentBoard.squares[row][col].category)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(2)
                                    .truncationMode(.middle)
                                    .padding(4)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .sheet(item: $selectedSquare) { square in
            EditSquareView(row: square.row, col: square.col)
                .environmentObject(viewModel)
        }
    }
}
