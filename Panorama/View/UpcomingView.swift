//
//  UpcomingMovieView.swift
//  Panorama
//
//  Created by riddinuz on 7/16/22.
//

import SwiftUI

struct UpcomingView: View {
    
    @ObservedObject var vm: MovieViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                UpcomingList(
                    upcomingMovies: vm.state.upcomingMovies,
                    isLoading: vm.state.canLoadNextPage,
                    onScrolledAtBottom: vm.fetchUpcomingMovieBatch)
                    .onAppear(perform: vm.fetchUpcomingMovieBatch )
            }
        }
    }
}

struct UpcomingList: View {
    
    let upcomingMovies: [UpcomingMovie]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        List {
            ForEach(upcomingMovies) { upcomingMovie in
                NavigationLink(destination: UpcomingMovieDetail(upcomingMovie: upcomingMovie)) {
                    
                    UpcomingMovieRow(upcomingMovie: upcomingMovie).onAppear {
                        if self.upcomingMovies.last == upcomingMovie {
                            self.onScrolledAtBottom()
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Upcoming Movies")).id(UUID())
        }
    }
}

struct UpcomingMovieRow: View {
    var upcomingMovie: UpcomingMovie
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(" \(upcomingMovie.title)")
                    .bold()
                    .underline()
                Text("\(upcomingMovie.overview)")
                Text("\(upcomingMovie.popularity)")
                
            }
        }
    }
}


struct UpcomingMovieDetail : View {
    
    var upcomingMovie: UpcomingMovie
    
    var body: some View {
            
        ScrollView {
            HStack {
                Text(upcomingMovie.title)
                    .padding()
                
                if upcomingMovie.adult {
                    Image(systemName: "18.circle")
                }
                
                
            }
            VStack(alignment: .center,spacing: 15) {
                Text(upcomingMovie.overview)
                    .foregroundColor(.primary)
                    .font(.body)
                    .lineSpacing(14)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            HStack {
                Text("Release Date:")
                Spacer()
                Text(convertDateString(date: upcomingMovie.releaseDate))
                    .padding()
            }
            .padding(.horizontal)
        }
        
        
    }
    
    func convertDateString(date: String) -> String {
        return date.convertDateFormat(inputDate: date)
    }
}



struct UpcomingView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingView(vm: MovieViewModel())
    }
}
