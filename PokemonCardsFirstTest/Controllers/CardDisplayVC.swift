//
//  CardDisplayVC.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 23/03/2021.
//

import UIKit

class CardDisplayVC: UIViewController {
    @IBOutlet weak var cardImage: UIImageView!

    var cardDisplayManager = CardDisplayManager()
    var imageData : Data?
    var cardName : String?
    var cardId : String?
    var card : Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let safeName = card?.name{
            title = safeName
        }
        if let safeImageData = imageData{
            DispatchQueue.main.async {
                self.cardImage.image = UIImage(data: safeImageData)
            }
        }
    }
    
    
    @IBAction func addToMarketPressed(_ sender: UIBarButtonItem) {

        if let safeCard = card{
            cardDisplayManager.displaySellAlert(vc : self, card : safeCard)
        }
        
        
        
    }
    
    @IBAction func sellButton(_ sender: UIButton) {
        
       

    }
    
    
}
