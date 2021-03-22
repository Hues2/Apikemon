//
//  MainPageVC.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 21/03/2021.
//

import UIKit
import Firebase

class MainPageVC: UIViewController {
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        //Tries to sign the user out
        do {
          try Auth.auth().signOut()
            //Takes the user all the way back to the login page
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hides the back button as we dont need it because we have implemented a log out button
        navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }
    
    
    //Takes user to their collection of cards (Read data of database)
    @IBAction func myCollectionPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "MainToMyCollection", sender: self)
    }
    
    
    @IBAction func openPacksPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "MainToSetsPage", sender: self)
    }
    
    
    //Displays the entire collection of cards (API call)
    @IBAction func allCardsPressed(_ sender: UIButton) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
