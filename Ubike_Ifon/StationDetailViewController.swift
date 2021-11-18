//
//  StationDetailViewController.swift
//  Ubike_Ifon
//
//  Created by Adam on 2021/10/7.
//

import UIKit
import MapKit

class StationDetailViewController: UIViewController{
    
    @IBOutlet var snaLabel:UILabel!
    @IBOutlet var arLabel:UILabel!
    @IBOutlet var sbiLabel:UILabel!
    @IBOutlet var bempLabel:UILabel!
    @IBOutlet weak var mapView: MKMapView!
        
    var sna = ""
    var ar = ""
    var sbi = 0
    var bemp = 0
    var lat = 0.0
    var lng = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        setupUserLocation()
        setupTargetLocaiton()
        setupData()
    }
    
    func setupData(){
        snaLabel?.text = sna.replacingOccurrences(of: "YouBike2.0_", with: "",options: NSString.CompareOptions.literal, range: nil)
        arLabel?.text = ar
        sbiLabel?.text = String(sbi)
        bempLabel?.text = String(bemp)
    }
}

extension StationDetailViewController: MKMapViewDelegate{
    
    func setupUserLocation(){
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func setupTargetLocaiton(){
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2D(latitude: lat, longitude:lng)
        ann.title = sna.replacingOccurrences(of: "YouBike2.0_", with: "",options: NSString.CompareOptions.literal, range: nil)
        mapView.addAnnotation(ann)
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), latitudinalMeters: 150, longitudinalMeters: 150)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: "station")
        if (annView == nil){
            annView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "station")
        }
        annView!.image = UIImage(named: "flag")
        if (annotation.title == sna.replacingOccurrences(of: "YouBike2.0_", with: "",options: NSString.CompareOptions.literal, range: nil)){
            let img = UIImageView(image: UIImage(named: "ubike"))
            img.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            img.layer.cornerRadius = 6
            img.clipsToBounds = true
            annView?.leftCalloutAccessoryView = img
            let label = UILabel()
            label.numberOfLines = 2
            label.text = "可借：\(sbi)\n可還：\(bemp)"
            annView?.detailCalloutAccessoryView = label
            let button = UIButton(type: .detailDisclosure)
            button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
            annView?.rightCalloutAccessoryView = button
        }
        annView?.canShowCallout = true
        return annView
    }
    
    @objc func buttonPress(_ sender: UIButton){
        print("test")
        let testLocation = CLLocationCoordinate2D(latitude: 25.02605, longitude: 121.5436)
        let testPlacemaker = MKPlacemark(coordinate: testLocation)
        let testItem = MKMapItem(placemark: testPlacemaker)
        testItem.name = "科技大樓站"
        let targetLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let targetPlacemaker = MKPlacemark(coordinate: targetLocation)
        let targetItem = MKMapItem(placemark: targetPlacemaker)
        targetItem.name = sna
//        let userMapItem = MKMapItem.forCurrentLocation()
//        userMapItem.name "我的目前位置"
//        let routes = [userMapItem,targetItem]
        let routes = [testItem,targetItem]
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving] )
    }
}
