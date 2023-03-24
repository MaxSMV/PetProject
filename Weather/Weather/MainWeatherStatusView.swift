//
//  MainWeatherStatusView.swift
//  Weather
//
//  Created by Max Stefankiv on 14.01.2023.
//

import SwiftUI

struct MainWeatherStatusView: View {
    var imageName: String
    var temperature: Int

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)

            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}

struct MainWeatherStatusView_Previews: PreviewProvider {
    static var previews: some View {
        MainWeatherStatusView(
            imageName: "moon.stars.fill",
            temperature: -5
        )
    }
}
