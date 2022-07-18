//
//  MainView.swift
//  Panorama
//
//  Created by riddinuz on 7/15/22.
//

import SwiftUI

struct PopularView: View {
    
    @ObservedObject var vm: MovieViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                MovieListView(
                    vm: MovieViewModel(),
                    movies: vm.state.popularMovies,
                    isLoading: vm.state.canLoadNextPage,
                    onScrolledAtBottom: vm.fetchPopularMovieBatch
                )
                    .onAppear(perform: vm.fetchPopularMovieBatch )
            }
        }
    }
}

struct MovieListView: View {
    @ObservedObject var vm: MovieViewModel
    let movies: [PopularMovie]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        List {
            ForEach(movies) { movie in
                NavigationLink(destination: MovieDetailView(
                    vm: MovieViewModel(),
                    cast: vm.state.castDetails,
                    movie: movie)) {
                    
                    MovieRow(movie: movie)
                        .onAppear {
                            if self.movies.last == movie {
                                self.onScrolledAtBottom()
                            }
                        }
                }
            }
            .navigationBarTitle(Text("Popular Movies")).id(UUID())
        }
        
    }
}

struct MovieRow: View {
    var movie: PopularMovie
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text("\(movie.title)")
                    .bold()
                    .underline()
                Text("\(movie.overview)")
            }
        }
    }
}

