//
//  SetsManager.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 19/03/2021.
//
import UIKit

struct SetsManager{
    
    let apiUrl = "https://api.pokemontcg.io/v2/sets"
    
    //This method fetches all the sets from the API
    //Result is an escaping closure, which means that it waits for the function to finish
    //to "set" the result.
    func fetchSets(result : @escaping ([SetOfCards]) -> Void){
        //Create url
        if let url = URL(string: apiUrl){
            
            //Create the URLRequest to use my API key
            var request = URLRequest(url: url)
            //Add my API key
            request.addValue(Props.apiKey, forHTTPHeaderField: "X-Api-Key")
            
            //Create the session
            let session = URLSession.shared
            
            //Create the task using the request
            let task = session.dataTask(with: request) { (data, response, error) in
                //If there is an error print it and cancel the closure
                if let e = error{
                    print(e)
                    return
                }else{
                    //If the data isn't nil, then call the parse JSON method
                    if let safeData = data{
                        var listOfSets : [SetOfCards] = []
                        if let dataFromApi = parseSetJSON(safeData : safeData){
                            for set in dataFromApi.data{
                                let id = set.id
                                let name = set.name
                                let logo = set.images.logo
                                let set = SetOfCards(id: id, name: name, logo: logo)
                                listOfSets.append(set)
                            }
                            result(listOfSets)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    func parseSetJSON(safeData : Data) -> SetData?{
        do{
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(SetData.self, from: safeData)
            return decodedData
        }catch{
            print(error)
            return nil
        }
        
    }
}
