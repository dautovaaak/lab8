import SwiftUI

struct SearchBooksView: View {
    @ObservedObject var bookFetcher: BookFetcher
    @State private var selectedBook: Book? = nil
    
    var body: some View {
        VStack {
            List(bookFetcher.books, id: \.self) { book in
                Button(action: {
                    selectedBook = book
                }) {
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        Text("By: \(book.authors.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .sheet(item: $selectedBook) { book in
                // Provide a closure to add the book to the library
                BookDetailView(book: book, onAddToLibrary: { book in
                    self.bookFetcher.addBookToLibrary(book)
                }, bookFetcher: self.bookFetcher)
            }
            .navigationBarTitle("Search Books")
            .searchable(text: $bookFetcher.query, prompt: "Search books...")
            .onChange(of: bookFetcher.query) { newValue in
                bookFetcher.fetchBooks(query: newValue)
            }
        }
    }
}
