//
//  ProfileViewController.swift
//  TestTask
//
//  Created by Max Stefankiv on 28.03.2023.
//

import UIKit

extension UIImageView {
    func setRounded() {
        layer.cornerRadius = (frame.width / 2)
        layer.masksToBounds = true
   }
}

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var uploadImage: UIImageView!

    private let userDataService: UserDataServiceProtocol = UserDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        uploadImage.addGestureRecognizer(gestureRecognizer)

        if let email = userDataService.email {
            emailLabel.text = email
        }

        // make rounded image
        uploadImage.setRounded()
    }
    
    @objc func choosePicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        userDataService.clear()
        
        // Remove image from UIImageView
        uploadImage.image = nil
        
        // Return to Login screen
        self.performSegue(withIdentifier: "toLoginVC", sender: nil)
    }
    
    func deleteCredentialsFromKeychain(forEmail email: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: email
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            throw KeychainError.unableToDeleteCredentials
        }
    }
    
    enum KeychainError: Error {
        case unableToDeleteCredentials
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

