import Foundation

struct Book: Identifiable, Codable, Equatable, Hashable {
    var id: String
    var title: String
    var authors: [String]
    var rating: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case volumeInfo
        case title
        case authors
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let volumeInfo = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        title = try volumeInfo.decode(String.self, forKey: .title)
        authors = try volumeInfo.decodeIfPresent([String].self, forKey: .authors) ?? ["Unknown"]
        rating = 0
    }
    
    init(id: String, title: String, authors: [String], rating: Int) {
        self.id = id
        self.title = title
        self.authors = authors
        self.rating = rating
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        
        var volumeInfo = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        try volumeInfo.encode(title, forKey: .title)
        try volumeInfo.encode(authors, forKey: .authors)
        // Note: Since `rating` is not part of the standard Google Books API response,
        // it's not included in the encoded JSON. If you have a custom backend that supports
        // ratings, you might want to encode this value as well.
    }
}
