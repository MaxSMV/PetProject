//
//  WeatherDayView.swift
//  Weather
//
//  Created by Max Stefankiv on 14.01.2023.
//

import SwiftUI

struct WeatherDayView: View {
    var dayOFWeek : String
    var imageName: String
    var temperature: Int

    var body: some View {
        VStack {
            Text(dayOFWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)

            Text("\(temperature)°")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)

        }
    }
}

struct WeatherDayView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDayView(
            dayOFWeek: "TUE",
            imageName: "cloud.sleet.fill",
            temperature: -5
        )
    }
}
