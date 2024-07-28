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
                            if viewModel.isEditMode {
                                selectedSquare = SquareIdentifier(row: row, col: col)
                            } else {
                                viewModel.toggleMarker(row: row, col: col)
                            }
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(viewModel.currentBoard.markers[row][col] ? Color.green : Color.gray)
                                    .frame(height: 60)
                                Text(viewModel.currentBoard.squares[row][col].category)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
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
