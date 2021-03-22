//
//  CardData.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 20/03/2021.
//

import Foundation


struct CardData : Codable{
    let data : [CardDataObject]
}

struct CardDataObject : Codable{
    let id : String
    let name : String
    let rarity : String
    let images : ImageObject
}

struct ImageObject : Codable{
    let small : String
}
