//
//  LocationsTableVC.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/16/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import UIKit

class LocationsTableVC:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var locationsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsTable.delegate=self
        locationsTable.dataSource=self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.locationsTable.reloadData()
        }
    }
    
    func showError(message:String,title:String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction=UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Table view delegate methods
    internal func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell=tableView.dequeueReusableCell(withIdentifier: "locationsCell")
        let currentLocation:StudentLocation?=LocationsModel.locations[indexPath.row]
        let firstName=(currentLocation?.firstName) ?? ""
        let lastName=(currentLocation?.lastName) ?? ""
        if currentLocation != nil{
            let text="\(String(describing: firstName)) \(String(describing: lastName))"
            if firstName=="" {
                cell?.textLabel?.text="Annonymous"
            }
            else{
                cell?.textLabel?.text=text
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return LocationsModel.locations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let application=UIApplication.shared
        var url:URL?=nil
        print(LocationsModel.locations[indexPath.row])
        if let mediaUrl=LocationsModel.locations[indexPath.row].mediaUrl{
            url=URL(string: mediaUrl)
        }
        if let url=url{
            if application.canOpenURL(url){
                application.open(url, options: [:], completionHandler: nil)
            }
            else{
                self.showError(message: "The location URL is not a valid one", title: "Cannot open URL")
            }
        }
        else if url==nil{
            self.showError(message: "The location URL is not a valid one", title: "Cannot open URL")
        }
    }
}
