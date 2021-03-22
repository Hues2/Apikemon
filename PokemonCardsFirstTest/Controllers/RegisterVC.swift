//
//  RegisterVC.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 21/03/2021.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //If the eiaml and password are valid, the user will be registered
    //and the segue will take them to the main page
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTF.text, let password = passwordTF.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print("Error while creating user, \(e.localizedDescription)")
                }else{
                    self.performSegue(withIdentifier: "RegisterToMainPage", sender: self)
                }
            }
        }
    }

}
