//
//  TopRatedView.swift
//  Panorama
//
//  Created by riddinuz on 7/16/22.
//

import SwiftUI

struct TopRatedView: View {
    
    @ObservedObject var vm: MovieViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                TopRatedList(
                    topRatedMovies: vm.state.topRatedMovies,
                    isLoading: vm.state.canLoadNextPage,
                    onScrolledAtBottom: vm.fetchTopRatedMovieBatch)
                    .onAppear(perform: vm.fetchTopRatedMovieBatch )
            }
        }
    }
}

struct TopRatedList: View {
    
    let topRatedMovies: [TopRated]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        List {
            ForEach(topRatedMovies) { topRatedMovie in
                NavigationLink(destination: TopRatedMovieDetail(topRatedMovie: topRatedMovie)) {
                    
                    TopRatedMovieRow(topRatedMovie: topRatedMovie).onAppear {
                        if self.topRatedMovies.last == topRatedMovie {
                            self.onScrolledAtBottom()
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Top Rated Movies")).id(UUID())
        }
    }
}

struct TopRatedMovieRow: View {
    var topRatedMovie: TopRated
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(" \(topRatedMovie.title)")
                    .bold()
                    .underline()
                Text("\(topRatedMovie.overview)")
                Text("\(topRatedMovie.popularity)")
                
            }
        }
    }
}


struct TopRatedMovieDetail : View {
    var topRatedMovie: TopRated
    var body: some View {
            
        ScrollView {
            HStack {
                Text(topRatedMovie.title)
                    .padding()
                
                Text("Vote: \(roundDecimal(vote: topRatedMovie.voteAverage))")
                    .padding()
                
                if topRatedMovie.adult {
                    Image(systemName: "18.circle")
                }
                
            }
            VStack(alignment: .center,spacing: 15) {
                Text(topRatedMovie.overview)
                    .foregroundColor(.primary)
                    .font(.body)
                    .lineSpacing(14)
                Spacer()
            }
            .padding()
        }
        
        
    }
    
    func roundDecimal(vote: Double) -> String {
        return String(vote.rounded(toPlaces: 1))
    }
}



struct TopRatedView_Previews: PreviewProvider {
    static var previews: some View {
        TopRatedView(vm: MovieViewModel())
    }
}
