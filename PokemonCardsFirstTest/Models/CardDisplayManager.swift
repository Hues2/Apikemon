//
//  CardDisplayManager.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 23/03/2021.
//

import UIKit
import Firebase

protocol CardDisplayDelegate{
    func popToCollection()
}

struct CardDisplayManager{
    
    var db = Firestore.firestore()
    var userEmail = Auth.auth().currentUser?.email
    //The delegate is for the controller to set its self as the delegate to be able to call the navigationController pop function
    var delegate : CardDisplayDelegate?

    
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
                    //1. Add to market collection
                    saveCardOnMarket(card: card, price: price)
                    
                    
 
                }else{
                    //No price was entered
                    print("No price entered")
                }
                

                
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
    
    //Saves the passed in card to the market collection, with a price
    func saveCardOnMarket(card : Card, price : Double){
        self.db.collection("Market").document(card.id).setData(["Card" : [card.id, card.name, card.imageString, card.rarity], "Price" : price], merge: true) { (error) in
            if let e = error{
                print("Error saving cards to firestore, \(e.localizedDescription)")
            }else{
                print("Successfully saved data to firestore")
                //2. Remove from users collection
                //The card only gets deleted if the saving was successful
                deleteCardFromUserCollection(cardId: card.id)
            }
        }
    }
    
    //This method deletes the card from the users colelction
    //Only gets called if the card successfully saved to the market first
    func deleteCardFromUserCollection(cardId : String){
        if let safeUserEmail = userEmail{
            db.collection(safeUserEmail).document(cardId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    //3. Take back to collection
                    //Set te controller as the delegate so that it pops back to the users collection
                    delegate?.popToCollection()
                }
            }
        }
    }
}
