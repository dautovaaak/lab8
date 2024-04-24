import Foundation

class BookDatabase {
    private let defaults = UserDefaults.standard
    private let key = "savedBooks"
    
    func saveBooks(_ books: [Book]) {
        if let encoded = try? JSONEncoder().encode(books) {
            defaults.set(encoded, forKey: key)
        }
    }
    
    func loadBooks() -> [Book] {
        if let savedBooks = defaults.object(forKey: key) as? Data {
            if let loadedBooks = try? JSONDecoder().decode([Book].self, from: savedBooks) {
                return loadedBooks
            }
        }
        return []
    }
}
