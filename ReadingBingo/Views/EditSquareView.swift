import SwiftUI

struct EditSquareView: View {
    @EnvironmentObject var viewModel: BingoViewModel
    var row: Int
    var col: Int
    @State private var category: String = ""
    @State private var bookName: String = ""
    @State private var bookDetails: Book?
    @State private var isLoading = false
    @State private var errorMessage: String?

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

                Button("GoogleBook Query") {
                    fetchBookDetails()
                }
                .padding()

                if isLoading {
                    ProgressView()
                } else if let bookDetails = bookDetails {
                    VStack {
                        Text(bookDetails.title)
                            .font(.headline)
                        if let authors = bookDetails.authors {
                            Text("by \(authors.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        if let description = bookDetails.description {
                            Text(description)
                                .font(.body)
                                .padding()
                        }
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
                    }
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

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

    func fetchBookDetails() {
        isLoading = true
        errorMessage = nil
        GoogleBooksAPI.fetchBookDetails(query: bookName) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let book):
                    bookDetails = book
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
