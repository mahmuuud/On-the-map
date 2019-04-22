//
//  LoginVC.swift
//  On the map
//
//  Created by mahmoud mohamed on 4/10/19.
//  Copyright © 2019 mahmoud mohamed. All rights reserved.
//

import UIKit

class LoginVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
        username.delegate=self
        password.delegate=self
    }

    @IBAction func login(_ sender: Any) {
        if  username.text != "" &&  password.text != ""{
            configureLoginUI(loggingIn: true)
            Client.postSession(username: username.text!, password: password.text!,completionHandler: handleLoginResponse(success:error:errorType:))
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let application=UIApplication.shared
        application.open(URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!, options: [:], completionHandler: nil)
    }
    
    func configureLoginUI(loggingIn:Bool){
        username.isEnabled = !loggingIn
        password.isEnabled = !loggingIn
        loginBtn.isEnabled = !loggingIn
        
        if loggingIn{
            activityIndicator.startAnimating()
        }
        
        else{
            activityIndicator.stopAnimating()
        }
    }
    
    func handleLoginResponse(success:Bool,error:Error?,errorType:Client.ErrorType?){
        if success{
            DispatchQueue.main.async {
                self.configureLoginUI(loggingIn: false)
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
        else if errorType == .CredentialsError{
            DispatchQueue.main.async {
                ErrorHandler.showError(vc: self, message: "Error logging in ,please check your credentials", title: "Login Failed!")
                self.configureLoginUI(loggingIn: false)
            }
        }
        else{
            DispatchQueue.main.async {
                ErrorHandler.showError(vc: self, message: "Error logging in ,please check your Internet connection", title:  "Login Failed!")
                self.configureLoginUI(loggingIn: false)
            }
        }
    }
    
    //MARK: textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

