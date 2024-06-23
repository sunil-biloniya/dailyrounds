//
//  CountryModel.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 21/06/24.
//

import Foundation

struct CountryData: Codable {
    let country: String
    let region: String
}

struct ResponseData: Codable {
    
    let data: [String: CountryData]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
