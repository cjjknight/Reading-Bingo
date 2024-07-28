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

            // Progress Indicator
            ProgressView(value: calculateProgress())
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding()

            // Footer Information or Buttons
            VStack {
                Text("Complete your reading goals!")
                    .font(.headline)
                    .padding(.bottom, 4)

                HStack {
                    Button(action: {
                        // Action for resetting the board
                    }) {
                        Text("Reset Board")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.trailing, 4)

                    Button(action: {
                        // Action for sharing the board
                    }) {
                        Text("Share Board")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .background(Color.gray.opacity(0.1))
        .sheet(item: $selectedSquare) { square in
            EditSquareView(row: square.row, col: square.col)
                .environmentObject(viewModel)
        }
    }

    private func calculateProgress() -> Double {
        let totalSquares = 25
        let markedSquares = viewModel.currentBoard.markers.flatMap { $0 }.filter { $0 }.count
        return Double(markedSquares) / Double(totalSquares)
    }
}
