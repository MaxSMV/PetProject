//
//  WheatherDTO.swift
//  Weather
//
//  Created by Max Stefankiv on 14.01.2023.
//

import Foundation

// DTO - Data Transfer Object
struct WheatherDTO: Decodable {
    let cityName: String
    var data: [WheatherDataDTO]

    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case data
    }
}

struct WheatherDataDTO: Decodable {
    let temp: Double
    let validDate: String

    enum CodingKeys: String, CodingKey {
        case temp
        case validDate = "valid_date"
    }
}
