//
//  SetData.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 19/03/2021.
//

import Foundation

struct SetData : Codable{
    let data : [DataObject]
}


struct DataObject : Codable{
    let id : String
    let name : String
    let images : ImagesObject
}


struct ImagesObject : Codable{
    let logo : String
}
