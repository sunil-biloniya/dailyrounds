//
//  BookmarkModel.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let empty = try? JSONDecoder().decode(Empty.self, from: jsonData)

import Foundation

// MARK: - BookmarkModel
struct BookmarkModel: Codable {
    let numFound, start: Int?
    let numFoundExact: Bool?
    let docs: [BookmarkDoc]?
    let purpleNumFound: Int?
    let q: String?
    let offset: Int?

    enum CodingKeys: String, CodingKey {
        case numFound, start, numFoundExact, docs
        case purpleNumFound = "num_found"
        case q, offset
    }
}

// MARK: - BookmarkDoc
struct BookmarkDoc: Codable {
    var authorName: [String]?
    var ratingsAverage: Double?
    var ratingsCount : Int?
    var title: String?
    var coverI: Int?
    var userId: String?
    var isSelect: Bool = false

    enum CodingKeys: String, CodingKey {

        case authorName = "author_name"
        case coverI = "cover_i"
        
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case title
        
    }
}
