//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    // Access environment object workout manager
    @EnvironmentObject var workoutManager: WorkoutManager
    
    // Access workout data store
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    
    var mapView = MKMapView()
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        // Set coordinator
        mapView.delegate = context.coordinator
        
        // Show user location, map scale and compass
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Add all workout overlays
        mapView.addOverlay(polyline())
    }
    
    func polyline() -> MKMultiPolyline {
        var polylines: [MKPolyline] = []
        
        // Provide polyline overlay for each of the workout routes
        for route in workoutDataStore.allWorkoutRoutes {
            var formattedLocations: [CLLocationCoordinate2D] = []
            for location in route {
                let newLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                formattedLocations.append(newLocation)
            }
            polylines.append(MKPolyline(coordinates: formattedLocations, count: route.count))
        }
        
        return MKMultiPolyline(polylines)
    }
}
