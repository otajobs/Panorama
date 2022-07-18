//
//  MovieDetailView.swift
//  Panorama
//
//  Created by riddinuz on 7/17/22.
//

import SwiftUI

struct MovieDetailView : View {
    
    @ObservedObject var vm: MovieViewModel
    
    var cast: [Cast]
    var movie: PopularMovie
    var body: some View {
        
        ScrollView {
            VStack {
                Text(movie.title)
                    .padding()
                
                if movie.adult {
                    Image(systemName: "18.circle")
                }
                
            }
            VStack(alignment: .center,spacing: 15) {
                Text(movie.overview)
                    .foregroundColor(.primary)
                    .font(.body)
                    .lineSpacing(14)
                Spacer()
                
                ForEach(cast) { cast in
                    Text("\(cast.name)")
                }
            }

            Text("Popularity: \(roundDecimal(popularity: movie.popularity))")
                .frame(maxWidth: .infinity, alignment: .leading)
                

        }
        .padding()
    }
    
    func roundDecimal(popularity: Double) -> String {
        return String(popularity.rounded(toPlaces: 1))
    }
}
