//
//  AddLocationVC.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/18/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import UIKit

class AddLocationVC: UIViewController {
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var url: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc=segue.destination as! NewLocationMapVC
        vc.locationName=locationName.text!
    }
    
}
