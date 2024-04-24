import SwiftUI


struct BookDetailView: View {
    var book: Book
    var onAddToLibrary: (Book) -> Void
    var bookFetcher: BookFetcher
    
    @State private var description: String?
    @State private var rating: Int = 0
    @State private var genre: String = ""
    @State private var publishedDate: String = ""
    
    var isBookAdded: Bool {
        return bookFetcher.manuallyAddedBooks.contains(book)
    }
    
    var body: some View {
        VStack {
            Text(book.title)
                .font(.title)
                .padding()
            
            Text("By: \(book.authors.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
            
            Text("Genre: \(genre)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
            
            Text("Published Date: \(publishedDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
            
            if let description = description {
                Text(description)
                    .padding()
            } else {
                ProgressView()
            }
            
            if !isBookAdded {
                Button(action: {
                    onAddToLibrary(book)
                }) {
                    Text("Add to Library")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            
            RatingView(rating: $rating)
            
            Spacer()
        }
        .onAppear {
            fetchBookDetails()
            // Загружаем рейтинг из хранилища данных
            if let savedRating = UserDefaults.standard.value(forKey: "\(book.id)_rating") as? Int {
                self.rating = savedRating
            }
        }
        .onDisappear {
            // Сохраняем рейтинг в хранилище данных
            UserDefaults.standard.set(self.rating, forKey: "\(book.id)_rating")
        }
    }
    
    func fetchBookDetails() {
        let url = "https://www.googleapis.com/books/v1/volumes/\(book.id)"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching book details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            print(String(data: data, encoding: .utf8)) // Выводим полученные данные в консоль
            
            if let bookDetails = try? JSONDecoder().decode(BookDetails.self, from: data) {
                DispatchQueue.main.async {
                    self.description = bookDetails.volumeInfo.description
                    self.genre = bookDetails.volumeInfo.genre?.joined(separator: ", ") ?? ""
                    self.publishedDate = bookDetails.volumeInfo.publishedDate ?? ""
                }
            }
        }.resume()
    }
    
    func isRatingSaved() -> Bool {
        return bookFetcher.manuallyAddedBooks.contains(where: { $0.id == book.id && $0.rating != 0 })
    }
}
