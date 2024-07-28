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
                                
                                if let bookCoverURL = viewModel.currentBoard.squares[row][col].bookCoverURL, let url = URL(string: bookCoverURL.replacingOccurrences(of: "http://", with: "https://")) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60, height: 60)
                                        case .failure:
                                            Image(systemName: "book")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60, height: 60)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
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
        }
        .padding()
        .sheet(item: $selectedSquare) { square in
            EditSquareView(row: square.row, col: square.col)
                .environmentObject(viewModel)
        }
    }
}
