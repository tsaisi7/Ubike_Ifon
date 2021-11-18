//
//  StationViewController.swift
//  Ubike_Ifon
//
//  Created by Adam on 2021/10/6.
//

import UIKit

class StationViewController: UIViewController{
    
    @IBOutlet var stationTableView: UITableView!
    
    let urlStr = "https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json"
    var stationData = [Station]()

    override func viewDidLoad() {
        super.viewDidLoad()
        stationTableView.delegate = self
        stationTableView.dataSource = self
        getJson(url: urlStr)
    }
    
    func getJson(url:String){
        if let url = URL(string: url){
            URLSession.shared.dataTask(with: url){ data, response, error in
                if let data = data{
                    do{
                        let stations = try JSONDecoder().decode([Station].self, from: data)
                        for station in stations{
                            self.stationData.append(station)
                        }
                        DispatchQueue.main.async{
                            self.stationTableView.reloadData()
                        }
                    } catch{
                        print(error)
                    }
                }
            }.resume()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStationDetail"{
            if let indexPath = stationTableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! StationDetailViewController
                destinationController.sna = self.stationData[indexPath.row].sna
                destinationController.ar = self.stationData[indexPath.row].ar
                destinationController.sbi = self.stationData[indexPath.row].sbi
                destinationController.bemp = self.stationData[indexPath.row].bemp
                destinationController.lat = self.stationData[indexPath.row].lat
                destinationController.lng = self.stationData[indexPath.row].lng
            }
        }
    }
}

extension StationViewController{
    
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

extension StationViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationcell", for: indexPath)as! StationTableViewCell
        cell.snaLabel?.text = stationData[indexPath.row].sna.replacingOccurrences(of: "YouBike2.0_", with: "",options: NSString.CompareOptions.literal, range: nil)
        cell.sbiLabel?.text = String(stationData[indexPath.row].sbi)
        cell.bempLabel?.text = String(stationData[indexPath.row].bemp)
        return cell
    }
}
extension StationViewController: UITableViewDelegate{
    
}
