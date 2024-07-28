import SwiftUI

struct BingoBoardView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<5) { row in
                    ForEach(0..<5) { col in
                        Button(action: {
                            viewModel.toggleMarker(row: row, col: col)
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(viewModel.markers[row][col] ? Color.green : Color.gray)
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
    }
}
