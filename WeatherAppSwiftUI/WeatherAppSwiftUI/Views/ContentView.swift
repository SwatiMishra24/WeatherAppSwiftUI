//
//  ContentView.swift
//  WeatherAppSwiftUI
//
//  Created by Shobhit Gupta on 21/10/23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherDataManager()
    @State var weather: ResponseBody?
    @State private var localLocation = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)

    var body: some View {
        VStack {
                    if let location = locationManager.location {
                        if let weather = weather {
                            HomeScreenView(weather: weather, selectedLocation: $localLocation)
                        } else {
                            LoadingView()
                                .task {
                                    do {
                                        weather = try await
                                        weatherManager.getCurrentWeather(
                                            latitude: location.latitude,
                                            longitude: location.longitude)
                                    } catch {
                                        print("Error getting weather: \(error)")
                                    }
                                }
                        }
                    } else {
                        if locationManager.isLoading {
                            LoadingView()
                        } else {
                            CustomView()
                                .environmentObject(locationManager)
                        }
                    }
                }
                .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
