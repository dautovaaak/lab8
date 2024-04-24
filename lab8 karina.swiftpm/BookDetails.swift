import SwiftUI
import Foundation
struct BookDetails: Decodable {
    let volumeInfo: VolumeInfo
    
    struct VolumeInfo: Decodable {
        let description: String?
        let genre: [String]?
        let publishedDate: String?
        
        enum CodingKeys: String, CodingKey {
            case description
            case genre = "categories"
            case publishedDate
        }
    }
}
