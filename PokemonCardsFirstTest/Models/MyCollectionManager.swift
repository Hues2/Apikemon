//
//  MyCollectionManager.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 22/03/2021.
//

import Foundation
import Firebase

class MyCollectionManager {    
    
    let db = Firestore.firestore()
    var userEmail = Auth.auth().currentUser?.email
    var cards : [Card] = []
    var dic :  [String : [String]] = [:]
    var commonCards: [Card] = []
    var uncommonCards : [Card] = []
    var rareCards : [Card] = []

    
    func getCards(result : @escaping ([Card]) -> Void){
        //If user is logged in, then it loads their collection of cards
        if let user = userEmail{
            db.collection(user).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting cards: \(err)")
                } else {
                    //In each document there is a key "Card" with an array as a value
                    //I need to access each string within the array
                    for document in querySnapshot!.documents {
                        //I know that the cards saved as a dictionary with an array of strings
                        //as values so I cast it as that with as!
                        self.dic = document.data() as! [String : [String]]
                        var id : String = ""
                        var name : String = ""
                        var imageUrl : String = ""
                        var rarity : String = ""
                        
                        for (_, value) in self.dic{
                            id = value[0]
                            name = value[1]
                            imageUrl = value[2]
                            rarity = value [3]
                            
                        }
                        let card = Card(id: id, name: name, imageString: imageUrl, rarity: rarity)
                        self.addToCorrectList(card: card)
                        //self.cards.append(card)
                    }
                    self.groupCardsTogetherInSortedList()
                    result(self.cards)
                }
            }
        }
    }
    
    
    func populateImageDataList(cards : [Card]) -> [Data]{
        var list : [Data] = []
        for card in self.cards{
            let imageString = card.imageString
            if let imageUrl = URL(string: imageString){
                let data = try! Data(contentsOf: imageUrl)
                list.append(data)
            }
        }
        return list
    }
    
    
    func addToCorrectList(card : Card){
        if card.rarity == "Common"{
            commonCards.append(card)
        }else if card.rarity == "Uncommon"{
            uncommonCards.append(card)
        }else{
            rareCards.append(card)
        }
    }
    
    func groupCardsTogetherInSortedList(){
        cards += commonCards
        cards += uncommonCards
        cards += rareCards
    }
}
