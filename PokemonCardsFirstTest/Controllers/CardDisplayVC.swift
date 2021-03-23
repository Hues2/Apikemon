//
//  CardDisplayVC.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 23/03/2021.
//

import UIKit

class CardDisplayVC: UIViewController {
    @IBOutlet weak var cardImage: UIImageView!
    
    var imageData : Data?
    var cardName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = cardName{
            title = name
        }
        if let safeImageData = imageData{
            DispatchQueue.main.async {
                self.cardImage.image = UIImage(data: safeImageData)
            }
        }
    }
    
}
