//
//  ViewController.swift
//  TestTask
//
//  Created by Max Stefankiv on 28.03.2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let userDataService: UserDataServiceProtocol = UserDataService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // looks like user is already logged in
        if userDataService.email != nil {
            self.performSegue(withIdentifier: "toHomeVC", sender: nil)
        }
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
            self.makeAlert(title: "Error", message: "Email or Password")
            return
        }
        
        userDataService.save(email: email)
        userDataService.save(password: password)
        
        self.performSegue(withIdentifier: "toHomeVC", sender: nil)
    }
    @IBAction func signUpClicked(_ sender: Any) {
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
            self.makeAlert(title: "Error", message: "Email or Password")
            return
        }

        userDataService.save(email: email)
        userDataService.save(password: password)
        
        self.performSegue(withIdentifier: "toHomeVC", sender: nil)
    }
    
    func makeAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

