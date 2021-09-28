//
//  GoogleMapsView.swift
//  Audio Traveler
//
//  Created by Gafur on 18/9/21.
//

import SwiftUI
import GoogleMaps

struct GoogleMapsView : UIViewRepresentable {
    private let zoom: Float = 15.0
    @Binding var audioList:[AudioLocation]
    @ObservedObject var locationManager = LocationManager()
    var didTap:(Bool,CLLocationCoordinate2D,String?) -> Void
    @State private var mapShowFirstTime:Bool = false
    

    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        let mapview = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapview.settings.compassButton = true
        mapview.isMyLocationEnabled = true
        //mapview.settings.myLocationButton = true
        mapview.settings.scrollGestures = true
        mapview.settings.zoomGestures = true
        mapview.settings.rotateGestures = true
        mapview.settings.tiltGestures = true
        mapview.isIndoorEnabled = false
        mapview.delegate = context.coordinator
    
        return mapview
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
      
        if(locationManager.latitude > 0.0 && locationManager.isFirstTimeShow){
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude))
           
            locationManager.isFirstTimeShow = false
        
        }
        audioList.forEach {
            
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: $0.location.latitude, longitude: $0.location.longitude))
                marker.title = $0.title
           
            marker.userData = $0.id.uuidString
            marker.map = mapView
        }
        
       
    }
    
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self) { (isTap,location, markerId) in
            if isTap {
               didTap(isTap, location,markerId)
            }
        }
      }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: GoogleMapsView
        var tap:(Bool,CLLocationCoordinate2D,String?) -> Void
        
        init(_ mapView: GoogleMapsView, tap:@escaping (Bool,CLLocationCoordinate2D,String?) -> Void) {
            self.mapView = mapView
            self.tap = tap
        }
        

        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            let marker = GMSMarker(position: coordinate)
            print("You tapperered : \(marker.position.latitude),\(marker.position.longitude)")
            marker.map = mapView
            tap(true,marker.position,nil)
           
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
          //  self.mapView.onAnimationEnded()
        }
       
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            tap(true,marker.position,marker.userData as? String)
           return false

        }
    }
}




