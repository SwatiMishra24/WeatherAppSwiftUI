//
//  ChangeLocationView.swift
//  WeatherAppSwiftUI
//
//  Created by Shobhit Gupta on 23/10/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct ChangeLocationView: View {
    @Binding var isPresented: Bool // Indicates whether to show the view
    @Binding var selectedLocation: CLLocationCoordinate2D
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    var onLocationChange: ((CLLocationCoordinate2D) -> Void)?
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for a location", text: $searchQuery, onCommit: searchForLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                List(searchResults, id: \.self) { mapItem in
                    Button(action: {
                        selectedLocation = mapItem.placemark.coordinate
                        onLocationChange?(mapItem.placemark.coordinate)
                        isPresented = false
                    }) {
                        VStack(alignment: .leading) {
                            Text(mapItem.name ?? "")
                            Text(mapItem.placemark.title ?? "")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationBarTitle("Change Location")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
    private func searchForLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            if let response = response {
                searchResults = response.mapItems
            }
        }
    }
}
