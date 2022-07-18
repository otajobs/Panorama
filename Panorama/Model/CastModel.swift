//
//  MovieDetailModel.swift
//  Panorama
//
//  Created by riddinuz on 7/15/22.
//

import Foundation

// MARK: - Welcome
struct CastModel <T: Codable>: Codable  {
    let id: Int
    let cast: [Cast]
}

// MARK: - Cast
struct Cast: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
//    let originalName: String
//    let profilePath: String?
    let character: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
//        case originalName = "original_name"
//        case profilePath = "profile_path"
        case character
        case order
      
    }
}
