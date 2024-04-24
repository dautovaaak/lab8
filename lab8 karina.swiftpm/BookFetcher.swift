import Combine
import Foundation

class BookFetcher: ObservableObject {
    @Published var query: String = ""
    @Published var manuallyAddedBooks: [Book] = []
    @Published var books: [Book] = []
    @Published var showAlert: Bool = false
    @Published var selectedBook: Book?
    private var bookDatabase = BookDatabase()
    
    init(bookDatabase: BookDatabase) {
        self.bookDatabase = bookDatabase
        self.manuallyAddedBooks = bookDatabase.loadBooks()
    }
    
    func addBookToLibrary(_ book: Book) {
        manuallyAddedBooks.append(book)
        bookDatabase.saveBooks(manuallyAddedBooks)
        showAlert = true // Set showAlert to true when a book is added
    }
    
    func fetchBooks(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let bookResponse = try? JSONDecoder().decode(BookResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.books = bookResponse.items.filter { !self.manuallyAddedBooks.contains($0) }
                }
            }
        }.resume()
    }
    
    func saveManuallyAddedBooks() {
        bookDatabase.saveBooks(manuallyAddedBooks)
    }
    
    func saveBookRating(_ book: Book, rating: Int) {
        if let index = manuallyAddedBooks.firstIndex(where: { $0.id == book.id }) {
            manuallyAddedBooks[index].rating = rating
            bookDatabase.saveBooks(manuallyAddedBooks)
        }
    }
}
