import Foundation

struct GoogleBooksAPI {
    static let baseURL = "https://www.googleapis.com/books/v1/volumes"

    static func fetchBookDetails(query: String, completion: @escaping (Result<Book, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                if let book = bookResponse.items.first?.volumeInfo {
                    completion(.success(book))
                } else {
                    completion(.failure(NSError(domain: "No book found", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

struct BookResponse: Codable {
    let items: [BookItem]
}

struct BookItem: Codable {
    let volumeInfo: Book
}

struct Book: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let thumbnail: String?
}
