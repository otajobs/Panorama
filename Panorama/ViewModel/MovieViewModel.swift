//
//  MovieViewModel.swift
//  Panorama
//
//  Created by riddinuz on 7/15/22.
//

import Foundation
import SwiftUI
import Combine

class MovieViewModel: ObservableObject {
    
    private var subscriptions = Set<AnyCancellable>()
    @Published private(set) var state = State()
    private var task: Cancellable? = nil
    let apiKey: String = "68e95a0c8e8fb88ae8d950881847dd99"
    let baseURL = "https://api.themoviedb.org/3/movie/"

    func fetchPopular() -> AnyPublisher<[PopularMovie], Error> {
        let url = URL(string: "\(baseURL)popular?api_key=\(apiKey)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(PopularMovieList<PopularMovie>.self, from: $0.data).results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchTopRated() -> AnyPublisher<[TopRated], Error> {
        let url = URL(string: "\(baseURL)top_rated?api_key=\(apiKey)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(TopRatedMovieList<TopRated>.self, from: $0.data).results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchUpcoming() -> AnyPublisher<[UpcomingMovie], Error> {
        let url = URL(string: "\(baseURL)upcoming?api_key=\(apiKey)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(UpcomingMovieList<UpcomingMovie>.self, from: $0.data).results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchCast(movieID: Int) -> AnyPublisher<[Cast], Error> {
        let url = URL(string: "\(baseURL)movie/\(movieID)/credits?api_key=\(apiKey)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(CastModel<Cast>.self, from: $0.data).cast }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchMovieCast(movieID: Int) {
        fetchCast(movieID: movieID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onCastReceive)
            .store(in: &subscriptions)
    }
    
    func fetchPopularMovieBatch() {
        guard state.canLoadNextPage else { return }
        fetchPopular()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onPopularReceive)
            .store(in: &subscriptions)
    }

    func fetchTopRatedMovieBatch() {
        guard state.canLoadNextPage else { return }
        fetchTopRated()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onTopRatedReceive)
            .store(in: &subscriptions)
    }
    
    func fetchUpcomingMovieBatch() {
        guard state.canLoadNextPage else { return }
        fetchUpcoming()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onUpcomingReceive)
            .store(in: &subscriptions)
    }
    
    func updater() {
        DispatchQueue.main.async {
            self.state.popularMovies = []
            self.state.topRatedMovies = []
            self.state.upcomingMovies = []
            self.state.castDetails = []
            self.state.page = 1
            self.fetchPopularMovieBatch()
            self.fetchTopRatedMovieBatch()
            self.fetchUpcomingMovieBatch()
//            self.fetchMovieCast(movieID: Int)
        }
    }
    
    func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }
    
    func onPopularReceive(_ batch: [PopularMovie]) {
        state.popularMovies += batch
        state.page += 1
        state.canLoadNextPage = batch.count > 1
    }
    
    func onTopRatedReceive(_ batch: [TopRated]) {
        state.topRatedMovies += batch
        state.page += 1
        state.canLoadNextPage = batch.count > 1
        
    }
    
    func onUpcomingReceive(_ batch: [UpcomingMovie]) {
        state.upcomingMovies += batch
        state.page += 1
        state.canLoadNextPage = batch.count > 1
    }
    
    func onCastReceive(_ batch: [Cast]) {
        state.castDetails += batch
        state.page += 1
        state.canLoadNextPage = batch.count > 1
       
        
    }
    
    struct State {
        var popularMovies: [PopularMovie] = []
        var topRatedMovies: [TopRated] = []
        var upcomingMovies: [UpcomingMovie] = []
        var castDetails: [Cast] = []
        var page: Int = 1
        var canLoadNextPage = true
    }

}
