//
//  PackOpnerViewController.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 20/03/2021.
//

import UIKit
import Firebase

class PackOpenerVC: UIViewController {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var openPackButtonOutlet: UIButton!
    @IBOutlet weak var nextCardButtonOutlet: UIButton!
    @IBOutlet weak var tapLabel: UILabel!
    
    var setId : String?
    var setLogo : String?
    var packOpnerManager = PackOpenerManager()
    var cards : [Card] = []
    var indexOfCard = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Open a pack"
        hideNextCardButton()
        //This sets the cardImage as the logo of the selected set
        if setLogo != nil{
            displayLogo()
        }
    }
    
    func hideNextCardButton(){
        nextCardButtonOutlet.isHidden = true
        tapLabel.isHidden = true
    }
    
    // Call the API info with the setID, passed through with the segue
    @IBAction func openPackButton(_ sender: UIButton) {
        indexOfCard  = 0
        //Sets the cards list as the list of random cards that the manager returns via the closure
        if let safeSetId = setId{
            packOpnerManager.getCardsFromSelectedSet(safeSetId) { (listOfRandomCards) in
                //This sets the cards list as the cards that comeback from the closure
                self.cards = listOfRandomCards
                //Call function to save the opened pack to firestore
                self.packOpnerManager.saveCardsToFirestore(cards: self.cards)
                //Set the button to hidden, as user cannot open another pack
                //until they have seen all the cards in the opened pack
                self.nextCardButtonOutlet.isHidden = false
            }
        }
        //Dont let the user open another pack when a pack is being displayed
        openPackButtonOutlet.isHidden = true
        //This makes the set logo dissapear
        fadeOut()
        DispatchQueue.main.async {
            //And this makes the back of the card appear, meaning that the pack has been opened
            UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut) {
                self.cardImage.image = #imageLiteral(resourceName: "CardBackImage")
                self.cardImage.alpha = 1
            }
            self.tapLabel.isHidden = false
        }
    }
    
    //This method makes each card fade in and out
    @IBAction func showNextCard(_ sender: UIButton) {
        //Checks to see if it is the last card
        if indexOfCard < 10{
            //Fades current card out
            fadeOut()
            //This is to transform the image url string into data
            //that can be used to set the imageView
            changeCardImage()
                indexOfCard += 1
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut) {
                        self.cardImage.alpha = 1.0
                    }
                }
            } else{
            print("No more cards")
            openPackButtonOutlet.isHidden = false
            hideNextCardButton()
            //This sets the cardImage as the logo of the selected set
            displayLogo()
            //Set this to empty so that another pack can be opened
            cards = []
        }
    }
    
    
    
    func changeCardImage(){
        let imageUrl = URL(string: cards[self.indexOfCard].imageString)
        if let safeUrl = imageUrl{
            let imageData = try! Data(contentsOf: safeUrl)
            DispatchQueue.main.async {
                self.cardImage.image = UIImage(data: imageData)
            }
        }
    }
    
    func displayLogo(){
        if setLogo != nil{
            if let logoUrl = URL(string: setLogo!){
                let logoData = try! Data(contentsOf: logoUrl)
                DispatchQueue.main.async {
                    self.cardImage.image = UIImage(data: logoData)
                }
            }
        }
    }
    
    func fadeOut(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut) {
                self.cardImage.alpha = 0.0
            }
        }
    }
}
