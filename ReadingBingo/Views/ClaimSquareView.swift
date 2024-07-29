import SwiftUI

struct ClaimSquareView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    var row: Int
    var col: Int
    @State private var bookName: String = ""
    @State private var bookAuthor: String = ""
    @State private var bookCoverURL: String?
    @State private var bookDetails: Book?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text(viewModel.currentBoard.squares[row][col].category)
                .font(.headline)
                .padding()

            if let bookDetails = bookDetails {
                if let thumbnail = bookDetails.imageLinks?.thumbnail, let url = URL(string: thumbnail.replacingOccurrences(of: "http://", with: "https://")) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 150)
                        case .failure:
                            Image(systemName: "book")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 150)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding()
                }

                Text(bookDetails.title)
                    .font(.headline)
                    .padding([.top, .bottom], 4)

                if let authors = bookDetails.authors {
                    Text("by \(authors.joined(separator: ", "))")
                        .font(.subheadline)
                        .padding([.bottom], 4)
                }

                Button("Reject") {
                    clearBookDetails()
                }
                .padding()

            } else {
                TextField("Book Name", text: $bookName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("GoogleBook Query") {
                    fetchBookDetails()
                }
                .padding()
            }

            if isLoading {
                ProgressView()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(viewModel.currentBoard.markers[row][col] ? "Unclaim" : "Claim") {
                if viewModel.currentBoard.markers[row][col] {
                    viewModel.unclaimSquare(row: row, col: col)
                } else {
                    viewModel.claimSquare(row: row, col: col, bookName: bookName, bookCoverURL: bookCoverURL)
                }
            }
            .padding()
        }
        .onAppear {
            let square = viewModel.currentBoard.squares[row][col]
            bookName = square.bookTitle ?? ""
            bookCoverURL = square.bookCoverURL
            if bookCoverURL != nil {
                fetchBookDetails(withoutQuery: true)
            }
        }
    }

    private func fetchBookDetails(withoutQuery: Bool = false) {
        isLoading = true
        errorMessage = nil
        let query = withoutQuery ? bookName : bookName

        GoogleBooksAPI.fetchBookDetails(query: query) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let book):
                    bookDetails = book
                    bookName = book.title
                    bookAuthor = book.authors?.joined(separator: ", ") ?? ""
                    bookCoverURL = book.imageLinks?.thumbnail
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func clearBookDetails() {
        bookDetails = nil
        bookName = ""
        bookAuthor = ""
        bookCoverURL = nil
    }
}

struct ClaimSquareView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimSquareView(row: 0, col: 0)
            .environmentObject(BingoViewModel())
    }
}
