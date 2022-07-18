//
//  ContentView.swift
//  Panorama
//
//  Created by riddinuz on 7/15/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            PopularView(vm: MovieViewModel())
                .tabItem {
                    Label("Popular", systemImage: "list.dash")
                }
            TopRatedView(vm: MovieViewModel())
                .tabItem {
                    Label("Top Rated", systemImage: "flame")
                }
            UpcomingView(vm: MovieViewModel())
                .tabItem {
                    Label("Upcoming", systemImage: "square.and.pencil")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
