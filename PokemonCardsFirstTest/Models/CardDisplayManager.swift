//
//  CardDisplayManager.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 23/03/2021.
//

import UIKit
import Firebase

struct CardDisplayManager{
    
    var db = Firestore.firestore()

    //This function handles the alert, but takes in the card as a parameter as the alert button handles the saving and deleting of the card
    func displaySellAlert(vc : UIViewController, card : Card){
        //Create the alert controller.
        let alert = UIAlertController(title: "Enter a price", message: "Enter the price you would like to sell this card for", preferredStyle: .alert)

        //Add the text field.
        alert.addTextField { (textField) in
            textField.placeholder = "Price"
        }
        //Create the button for the alert
        let sellCardAction = UIAlertAction.init(title: "Sell", style: .default) { _ in
            //This is the "onClick action functionality"
            if let arrayOfTextFields = alert.textFields?.first, let priceString = arrayOfTextFields.text{
                let price = Double(priceString)
                if let safePrice = price{
                    //Pice was entered
                    let price = safePrice
                    //Add to market collection
                    saveCardOnMarket(card: card, price: price)
                }else{
                    //No price was entered
                    print("No price entered")
                }
                
                //Remove from users collection
                
                
                //Take back to collection
                //Add confirmation of added to market
                
            }
        }
        //Add the button to the alert
        alert.addAction(sellCardAction)
        //Present the alert.
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func sellCardOnMarket(){
        
    }
    
    
    //Saves the passed in card to the market collection, with a price
    func saveCardOnMarket(card : Card, price : Double){
        self.db.collection("Market").document(card.id).setData(["Card" : [card.id, card.name, card.imageString, card.rarity], "Price" : price], merge: true) { (error) in
            if let e = error{
                print("Error saving cards to firestore, \(e.localizedDescription)")
            }else{
                print("Successfully saved data to firestore")
            }
        }
    }
    
    func deleteCardFromUserCollection(cardId : String){
        
    }
}
