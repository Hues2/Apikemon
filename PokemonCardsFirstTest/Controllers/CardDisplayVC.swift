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
        cardDisplayManager.delegate = self
        //cardDisplayManager.deleteDelegate = self
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
            sender.title = "Adding to market..."
        }
        
    }
}


//MARK: - Card Display Manager
//Pops off the top view (takes user bac to their card collection)

extension CardDisplayVC : CardDisplayDelegate{
    func popToCollection() {
        navigationController?.popViewController(animated: true)
    }
}


