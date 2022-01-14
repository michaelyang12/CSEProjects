//
//  MovieInfo.swift
//  michaelyang-lab4
//
//  Created by Michael Yang on 10/25/21.
//

import Foundation
import UIKit

//collection of structs
struct APIResults: Codable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count: Int!
    let original_language: String?
}

struct fav {
    let id: Int
    let title: String
    let img_string: String
    let og_language: String
    let release_date: String
    let vote_avg: Double
    
    init (id: Int, title: String, img_string: String, og_language: String, release_date: String, vote_avg: Double) {
        self.id = id
        self.title = title
        self.img_string = img_string
        self.og_language = og_language
        self.release_date = release_date
        self.vote_avg = vote_avg
    }
}
