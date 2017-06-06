//
//  MapViewController.swift
//  App
//
//  Created by 康錦豐 on 2017/6/3.
//  Copyright © 2017年 appcoda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var restaurant: RestaurantMo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //地址轉換為座標，並標註在地圖上
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error)
                return
            }
            if let placemarks = placemarks {
                
                //取得地一個地標
                let placemark = placemarks[0]
                
                //加上標註
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    //顯示標註
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })

        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: restaurant.image as! Data)
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.pinTintColor = UIColor.orange
        
        annotationView?.pinTintColor = UIColor.black
        return annotationView
    }
}
