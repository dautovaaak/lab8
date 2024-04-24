import SwiftUI

struct BookListView: View {
    @Binding var books: [Book]
    var bookFetcher: BookFetcher
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookFetcher.manuallyAddedBooks) { book in
                    NavigationLink(destination: BookDetailView(book: book, onAddToLibrary: { _ in }, bookFetcher: bookFetcher)) {
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                            Text("By: \(book.authors.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteBook)
            }
            .navigationBarTitle("My Books")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func deleteBook(at offsets: IndexSet) {
        bookFetcher.manuallyAddedBooks.remove(atOffsets: offsets)
        bookFetcher.saveManuallyAddedBooks() // Save the updated list of manually added books
    }
}
