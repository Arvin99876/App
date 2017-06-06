//
//  RestaurantDetailViewController.swift
//  App
//
//  Created by 康錦豐 on 2017/6/2.
//  Copyright © 2017年 appcoda. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    var restaurant: RestaurantMo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //顯示視圖中標題名稱
        title = restaurant.name
        //載入視圖後，做其他的設定
        restaurantImageView.image = UIImage(data: restaurant.image as! Data)
        //更改試圖背景顏色
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        //更改分隔線顏色
        tableView.separatorColor = UIColor(red: 17.0/255.0, green: 139.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        //關掉滑動隱藏功能
        navigationController?.hidesBarsOnSwipe = false
        
        // 定義cell大小
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
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
                
                if let location = placemark.location {
                 
                    //顯示標註
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                     //設定縮放程度
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                    
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        //
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "Been there"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here before \(restaurant.rating)" : "NO"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
       @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    @IBAction func ratingButtonTapped(segue:UIStoryboardSegue) {
        
        if let rating = segue.identifier {
            restaurant.isVisited = true
            
            switch rating {
            case "great": restaurant.rating = "Absolutely love it! Must try."
            case "good": restaurant.rating = "Pretty good."
            case "dislike": restaurant.rating = "I don't like it"

            default: break
            }
        }
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.saveContext()
        }
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
            let destinationCotroller = segue.destination as! ReviewViewController
            destinationCotroller.restaurant = restaurant
            
        } else if segue.identifier == "showMap" {
            let destinationCotroller = segue.destination as! MapViewController
            destinationCotroller.restaurant = restaurant
        }
    }
}
