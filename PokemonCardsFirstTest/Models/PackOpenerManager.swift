//
//  PackOpenerManager.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 20/03/2021.
//
import UIKit

struct PackOpenerManager{
    
    let apiUrl = "https://api.pokemontcg.io/v2/cards?q=set.id:"
    func getCardsFromSelectedSet(_ setId : String, result : @escaping ([Card]) -> Void){
        
        if let url = URL(string : apiUrl + setId){
            
            var request = URLRequest(url: url)
            request.addValue(Props.apiKey, forHTTPHeaderField: "X-Api-Key")
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let e = error{
                    print(e)
                    return
                }else{
                    if let safeData = data{
                        //If the data is safe get the parsed json data
                        if let cardData = parseJSON(safeData){
                            //Create the empty list of random cards
                            var tenRandomCards : [Card] = []
                            let commonCards = self.getSixCommonCards(cardData: cardData)
                            let uncommonCards = self.getThreeUncommonCards(cardData: cardData)
                            let rareCard = self.getOneRareCard(cardData: cardData)
                            
                            for commonCard in commonCards{
                                tenRandomCards.append(commonCard)
                            }
                            for uncommonCard in uncommonCards{
                                tenRandomCards.append(uncommonCard)
                            }
                            
                            tenRandomCards.append(rareCard)
                            
                            result(tenRandomCards)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ safeData : Data) -> CardData?{
        do{
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(CardData.self, from: safeData)
            return decodedData
        }catch{
            print(error)
            return nil
        }
    }
    
    
    
    func getSixCommonCards(cardData : CardData) -> [Card]{
        var listOfRandomIndexes : [Int] = []
        var listOfRandomCommonCards : [Card] = []
        var randomIndex = Int.random(in: 0..<cardData.data.count)
        
        while (listOfRandomCommonCards.count < 6){
            //IF RARITY IS COMMON AND IDEX HAS NOT BEEN USED
            if(cardData.data[randomIndex].rarity == "Common" && !listOfRandomIndexes.contains(randomIndex)){
                let randomCommonCard = Card(id: cardData.data[randomIndex].id, name: cardData.data[randomIndex].name, imageString: cardData.data[randomIndex].images.small, rarity: cardData.data[randomIndex].rarity)
                //ADD THE CAD TO THE LIST
                listOfRandomCommonCards.append(randomCommonCard)
                //ADD THE INDEX TO THE LIST
                listOfRandomIndexes.append(randomIndex)
            }else{
                randomIndex = Int.random(in: 0..<cardData.data.count)
            }
        }
        return listOfRandomCommonCards
    }
    
    
    func getThreeUncommonCards(cardData : CardData) -> [Card]{
        var listOfRandomIndexes : [Int] = []
        var listOfRandomUncommonCards : [Card] = []
        var randomIndex = Int.random(in: 0..<cardData.data.count)
        //ADDS 3 UNCOMMON CARDS
        while (listOfRandomUncommonCards.count < 3){
            //IF THE RARITY IS "Uncommon" AND THE INDEX HAS NEVER BEEN USED (THIS MAKES SURE
            //THAT THERE WILL BE NO RPEATED CARDS) THEN ADD TO THE LIST OF UNCOMMON CARDS
            if(cardData.data[randomIndex].rarity == "Uncommon" && !listOfRandomIndexes.contains(randomIndex)){
                let randomCommonCard = Card(id: cardData.data[randomIndex].id, name: cardData.data[randomIndex].name, imageString: cardData.data[randomIndex].images.small, rarity: cardData.data[randomIndex].rarity)
                //ADD THE CARD TO THE LIST
                listOfRandomUncommonCards.append(randomCommonCard)
                //ADD THE INDEX TO THE LIST
                listOfRandomIndexes.append(randomIndex)
            }else{
                randomIndex = Int.random(in: 0..<cardData.data.count)
            }
        }
        return listOfRandomUncommonCards
    }
    
    
    func getOneRareCard(cardData : CardData) -> Card{
        var randomRareCard : Card? = nil
        var randomIndex = Int.random(in: 0..<cardData.data.count)
        
        while (randomRareCard == nil){
            //IF THE CARD RARITY CONTAINS THE WORD RARE THEN USE THAT ONE
            //NO NEED FOR AN INDEX AS IT WILL USE THE FIRST RARE THAT IT COMES ACCROSS
            //AS IT IS ONLY USING ONE RARE
            if(cardData.data[randomIndex].rarity.contains("Rare") || cardData.data[randomIndex].rarity.contains("Reverse Holo") || cardData.data[randomIndex].rarity.contains("Half Body") || cardData.data[randomIndex].rarity.contains("Full Body") || cardData.data[randomIndex].rarity.contains("Promo") || cardData.data[randomIndex].rarity.contains("Tag Team") || cardData.data[randomIndex].rarity.contains("VMAX") || cardData.data[randomIndex].rarity.contains("EX")){
                randomRareCard = Card(id: cardData.data[randomIndex].id, name: cardData.data[randomIndex].name, imageString: cardData.data[randomIndex].images.small, rarity: cardData.data[randomIndex].rarity)
            }else{
                randomIndex = Int.random(in: 0..<cardData.data.count)
            }
        }
        return randomRareCard!
    }
}




