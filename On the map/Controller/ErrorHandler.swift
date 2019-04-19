//
//  ErrorHandler.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/18/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import Foundation
import UIKit
class ErrorHandler {
    class func showError(vc:UIViewController,message:String,title:String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction=UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
