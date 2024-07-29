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
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(viewModel.currentBoard.markers[row][col] ? Color.green : Color.blue)
                                    .frame(height: 60)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white, lineWidth: 2)
                                    )

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
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding()

            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .sheet(item: $selectedSquare) { square in
            if viewModel.isEditMode {
                EditSquareView(row: square.row, col: square.col)
                    .environmentObject(viewModel)
            } else {
                ClaimSquareView(row: square.row, col: square.col)
                    .environmentObject(viewModel)
            }
        }
    }
}
