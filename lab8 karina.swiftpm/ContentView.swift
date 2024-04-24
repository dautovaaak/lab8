import SwiftUI

struct ContentView: View {
    @ObservedObject var bookFetcher = BookFetcher(bookDatabase: BookDatabase())
    
    var body: some View {
        TabView {
            NavigationView {
                // Updated to pass the bookFetcher directly
                BookListView(books: $bookFetcher.books, bookFetcher: bookFetcher)
            }
            .tabItem {
                Image(systemName: "book")
                Text("My Library")
            }
            
            NavigationView {
                SearchBooksView(bookFetcher: bookFetcher)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search Books")
            }
            
            NavigationView {
                LoginView()
            }
            .tabItem {
                Image(systemName: "person")
                Text("Authentication")
            }
        }
    }
}
