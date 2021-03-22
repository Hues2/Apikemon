//
//  WelcomeVC.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 21/03/2021.
//

import UIKit
import Firebase

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do text animation here
        
    }
    
    //If credentials are correct, user will be taken to the main page
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTF.text, let password = passwordTF.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print("Error signing user in, \(e.localizedDescription)")
                }else{
                    self.performSegue(withIdentifier: "WelcomeToMainPage", sender: self)
                }
            }
        }
    }
    
    //Tkes the user to the register page
    @IBAction func registerPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToRegisterPage", sender: self)
    }
}
