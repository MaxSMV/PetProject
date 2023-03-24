//
//  WheatherRepository.swift
//  Weather
//
//  Created by Max Stefankiv on 14.01.2023.
//

import Foundation
import Combine

struct WheatherRepository {
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)

    func fetchWheatherInfo() -> AnyPublisher<WheatherDTO, Error> {
        let url = URL(
            string: "https://api.weatherbit.io/v2.0/forecast/daily?lat=49.06607&lon=23.86435&days=6&key=48851d8053c44f538f60fbbaa8352f6a"
        )!
        
        return urlSession.dataTaskPublisher(for: url)
            .tryDecodeResponse(type: WheatherDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
