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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Do text animation here
        displayTitleLabel()
    }
    
    
    func displayTitleLabel(){
        titleLabel.text = ""
        var charIndex = 1.0
        let titleText = "Apikemon"
        for letter in titleText{
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1

        }
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
