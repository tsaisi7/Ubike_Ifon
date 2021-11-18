//
//  ViewController.swift
//  Ubike_Ifon
//
//  Created by Adam on 2021/10/6.
//

import UIKit
import FloatingPanel
import MapKit
import CoreLocation

class ViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
    let urlStr = "https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json"
    
    var stationData = [Station]()
    var locationManager = CLLocationManager()
    let fpc = FloatingPanelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        fpc.delegate = self
        
        getJson(url: urlStr)
        getUserLocation()
        setupUserLocation()
        setupFloatingPanel()
    }
    
    @IBAction func pushButton(_ sender: UIButton) {
        
    }
    
    func getJson(url:String){
        if let url = URL(string: url){
            URLSession.shared.dataTask(with: url){ data, response, error in
                if let data = data{
                    do{
                        let stations = try JSONDecoder().decode([Station].self, from: data)
                        for station in stations{
                            let ann = MKPointAnnotation()
                            ann.coordinate = CLLocationCoordinate2D(latitude: station.lat, longitude:   station.lng)
                            ann.title = station.sna.replacingOccurrences(of: "YouBike2.0_", with: "",options: NSString.CompareOptions.literal, range: nil)+String("\n可借： \(station.sbi)")
                            DispatchQueue.main.async {
                                self.mapView.addAnnotation(ann)
                            }
                        }
                    } catch{
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

extension ViewController{
    
    struct Station: Codable {
        let sno: String
        let sna: String
        let tot: Int
        let sbi: Int
        let mday: String
        let lat: Double
        let lng: Double
        let ar: String
        let bemp: Int
    }
}

extension ViewController: FloatingPanelControllerDelegate{
    
    func setupFloatingPanel(){
        guard let stationVC = storyboard?.instantiateViewController(identifier: "fpc_station") as? StationViewController else{
            return
        }
        fpc.set(contentViewController: stationVC)
        fpc.addPanel(toParent: self)
    }
}

extension ViewController: MKMapViewDelegate{
    
    func setupUserLocation(){
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
//        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.015088, longitude: 121.542743), latitudinalMeters: 300, longitudinalMeters: 300)
    }
}

extension ViewController: CLLocationManagerDelegate{
    
    func getUserLocation(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//    }
}

