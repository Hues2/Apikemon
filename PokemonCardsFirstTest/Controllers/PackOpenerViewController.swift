//
//  PackOpnerViewController.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 20/03/2021.
//

import UIKit
import Firebase

class PackOpenerViewController: UIViewController {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var openPackLabel: UILabel!
    @IBOutlet weak var openPackButtonOutlet: UIButton!
    @IBOutlet weak var nextCardButtonOutlet: UIButton!
    @IBOutlet weak var tapLabel: UILabel!
    
    var setId : String?
    var setLogo : String?
    var packOpnerManager = PackOpenerManager()
    var cards : [Card] = []
    var indexOfCard = 0
    var userEmail = Auth.auth().currentUser?.email
    //Create reference to the database
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Open a pack"
        nextCardButtonOutlet.isHidden = true
        tapLabel.isHidden = true
        var charIndex = 2.0
        let titleText = "Open Pack"
        for letter in titleText{
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.openPackLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        //This sets the cardImage as the logo of the selected set
        if setLogo != nil{
            if let logoUrl = URL(string: setLogo!){
                let logoData = try! Data(contentsOf: logoUrl)
                cardImage.image = UIImage(data: logoData)
            }
        }
    }
    
    // Call the API info with the setID, passed through with the segue
    @IBAction func openPackButton(_ sender: UIButton) {
        indexOfCard  = 0
        //Sets the cards list as the list of random cards that the manager returns via the closure
        if let safeSetId = setId{
            packOpnerManager.getCardsFromSelectedSet(safeSetId) { (listOfRandomCards) in
                //This sets the cards list as the cards that comeback from the closure
                self.cards = listOfRandomCards
                
                //This loops through all the 10 cards from the opened pack
                for card in self.cards{
                    //Check to see if there is a logged in user (there should always be)
                    if let user = self.userEmail{
                        self.db.collection("\(user)").addDocument(data: ["Card" : [card.id, card.name, card.imageString, card.rarity]]) { (error) in
                            if let e = error{
                                print("Error saving cards to firestore, \(e.localizedDescription)")
                            }else{
                                print("Successfully saved data to firestore")
                            }
                        }
                    }
                }
                self.nextCardButtonOutlet.isHidden = false
            }
        }
        //Dont let the user open another pack when a pack is being displayed
        openPackButtonOutlet.isHidden = true
        openPackLabel.isHidden = true
        //This makes the set logo dissapear
        UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut) {
            self.cardImage.alpha = 0
        }
        //And this makes the back of the card appear, meaning that the pack has been opened
        UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut) {
            self.cardImage.alpha = 1
            self.cardImage.image = #imageLiteral(resourceName: "CardBackImage")
        }
        tapLabel.isHidden = false
    }
    
    //This method makes each card fade in and out
    @IBAction func showNextCard(_ sender: UIButton) {
        //Checks to see if it is the last card
        if indexOfCard < 10{
            //Fades current card out
            UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut) {
                self.cardImage.alpha = 0.0
            }
            //This is to transform the image url string into data
            //that can be used to set the imageView
            let imageUrl = URL(string: cards[self.indexOfCard].imageString)
            if let safeUrl = imageUrl{
                let imageData = try! Data(contentsOf: safeUrl)
                DispatchQueue.main.async {
                    self.cardImage.image = UIImage(data: imageData)
                }
                indexOfCard += 1
                UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut) {
                    self.cardImage.alpha = 1.0
                }
            }
        } else{
            print("No more cards")
            openPackButtonOutlet.isHidden = false
            openPackLabel.isHidden = false
            tapLabel.isHidden = true
            //This sets the cardImage as the logo of the selected set
            if setLogo != nil{
                if let logoUrl = URL(string: setLogo!){
                    let logoData = try! Data(contentsOf: logoUrl)
                    cardImage.image = UIImage(data: logoData)
                }
            }
            //Set this to empty so that another pack can be opened
            cards = []
            nextCardButtonOutlet.isHidden = true
        }
    }
    
}
