//
//  HomeScreenView.swift
//  WeatherAppSwiftUI
//
//  Created by Shobhit Gupta on 23/10/23.
//

import SwiftUI
import CoreLocation

struct HomeScreenView: View {
    @State var weather: ResponseBody
    @State private var isChangeLocationViewPresented = false
    @Binding var selectedLocation: CLLocationCoordinate2D // Store the selected location
    var weatherManager = WeatherDataManager()
    let dummyImageUrl = "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png"
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold()
                        .font(.title)
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                    Button {
                        isChangeLocationViewPresented.toggle()
                    } label: {
                        Text("Change Location")
                    }
                                .sheet(isPresented: $isChangeLocationViewPresented) {
                                    ChangeLocationView(isPresented: $isChangeLocationViewPresented,
                                                       selectedLocation: $selectedLocation) { selected in
                                        self.selectedLocation = selected
                                        Task {
                                            do {
                                                weather = try await
                                                weatherManager.getCurrentWeather(latitude: selectedLocation.latitude,
                                                                                 longitude: selectedLocation.longitude)
                                            } catch {
                                                print("Error getting weather: \(error)")
                                            }
                                        }
                                    }
                                }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: "cloud")
                                .font(.system(size: 40))
                            Text("\(weather.weather[0].main)")
                        }
                        .frame(width: 150, alignment: .leading)
                        Spacer()
                        Text(weather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .padding()
                    }
                    Spacer()
                        .frame(height: 80)
                    AsyncImage(url: URL(string: dummyImageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                    } placeholder: {
                        ProgressView()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Weather now")
                        .bold()
                        .padding(.bottom)
                    HStack {
                        WeatherView(logo: "thermometer.sun",
                                    name: "Min temp",
                                    value: (weather.main.tempMin.roundDouble() + ("°")))
                        Spacer()
                        WeatherView(logo: "thermometer.sun.fill",
                                    name: "Max temp",
                                    value: (weather.main.tempMax.roundDouble() + "°"))
                    }
                    HStack {
                        WeatherView(logo: "wind",
                                    name: "Wind speed",
                                    value: (weather.wind.speed.roundDouble() + " m/s"))
                        Spacer()
                        WeatherView(logo: "humidity",
                                    name: "Humidity",
                                    value: "\(weather.main.humidity.roundDouble())%")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}
