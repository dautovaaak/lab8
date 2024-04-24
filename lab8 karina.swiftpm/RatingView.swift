import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: index <= self.rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        self.rating = index
                    }
            }
        }
    }
}
