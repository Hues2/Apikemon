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
protocol CardDisplayDeleteDelegate{
    func removeCard(cardId: String, imageString : String)
}

struct CardDisplayManager{
    
    var db = Firestore.firestore()
    var userEmail = Auth.auth().currentUser?.email
    //The delegate is for the CardDisplayVC to set its self as the delegate to be able to call the navigationController pop function
    var delegate : CardDisplayDelegate?
    var deleteDelegate : CardDisplayDeleteDelegate?
    
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
            //This checks if there is an input (which there is) and gets the first one
            //even though in this case there is only one (the price input)
            //This conditional bindig also checks to see if the text in this input exists and puts its
            //inside priceString
            if let arrayOfTextFields = alert.textFields?.first, let priceString = arrayOfTextFields.text{
                //User inputed a price and now I try to cast it to a Double
                let price = Double(priceString)
                //If it was posible to cast the inputed price to a double
                //then use that price to upload the card with
                if let safePrice = price{
                    //Pice was entered
                    let price = safePrice
                    
                    //1. Add to market collection
                    saveCardOnMarket(card: card, price: price)
                }else{
                    //No price was entered
                    print("No price entered, or wasn't a valid number")
                }
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
                //Make alert saying couldn't add to marjet, try again later
            }else{
                print("Successfully saved data to firestore")
                //2. Remove from users collection
                //The card only gets deleted if the saving was successful
                deleteCardFromUserCollection(cardId: card.id, cardImageString: card.imageString)
            }
        }
    }
    
    //This method deletes the card from the users colelction
    //Only gets called if the card successfully saved to the market first
    func deleteCardFromUserCollection(cardId : String, cardImageString : String){
        if let safeUserEmail = userEmail{
            db.collection(safeUserEmail).document(cardId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    //Couldn't delete so make an alert that opens in the card display saying error
                } else {
                    print("Document successfully removed!")
                    //Removes the card from the Card Collection array, so that when the user is popped back the their collection, the card that they just placed on the market is gone
                    deleteDelegate?.removeCard(cardId: cardId, imageString: cardImageString)
                
                    //3. Take back to collection
                    //Set te controller as the delegate so that it pops back to the users collection
                    delegate?.popToCollection()
                    
                    //Add confirmation of added to market
                    //Need to set a delegate so that it calls a function that opens an alert saying added to market!
                }
            }
        }
    }
}
