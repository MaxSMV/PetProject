//
//  Wheather.swift
//  Weather
//
//  Created by Max Stefankiv on 14.01.2023.
//

import Foundation

final class Wheather {
    private var wheatherDTO: WheatherDTO?
    private let currentDataDTO: WheatherDataDTO?
    init(wheatherDTO: WheatherDTO) {
        self.wheatherDTO = wheatherDTO
        self.currentDataDTO = self.wheatherDTO?.data.remove(at: 0)
    }

    init() {
        self.wheatherDTO = nil
        self.currentDataDTO = nil
    }

    lazy var cityName: String = {
        wheatherDTO?.cityName ?? ""
    }()

    lazy var currentData: WheatherData = {
        currentDataDTO.map { dto in
            WheatherData(wheatherDataDTO: dto)
        } ?? WheatherData()
    }()

    lazy var data: [WheatherData] = {
        wheatherDTO?.data
            .map { dto in
                WheatherData(wheatherDataDTO: dto)
            } ?? [WheatherData()]
    }()
}

final class WheatherData: Identifiable {
    var id: String { wheatherDataDTO?.validDate ?? "" }

    private let wheatherDataDTO: WheatherDataDTO?
    init(wheatherDataDTO: WheatherDataDTO) {
        self.wheatherDataDTO = wheatherDataDTO
    }

    init() {
        self.wheatherDataDTO = nil
    }

    lazy var day: String = {
        guard let wheatherDataDTO = wheatherDataDTO else {
            return ""
        }

        guard let date = getDate(from: wheatherDataDTO.validDate) else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"

        return dateFormatter.string(from: date)
    }()

    lazy var temperature: Int = {
        guard let wheatherDataDTO = wheatherDataDTO else {
            return 0
        }

        return Int(wheatherDataDTO.temp)
    }()

    private func getDate(from strDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from:strDate)
    }
}
