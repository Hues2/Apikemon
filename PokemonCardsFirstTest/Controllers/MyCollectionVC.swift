//
//  MyCollectionVC.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 22/03/2021.
//

import UIKit
import Firebase

class MyCollectionVC: UIViewController {
    @IBOutlet weak var myCollectionTableView: UITableView!
    
    let db = Firestore.firestore()
    var userEmail = Auth.auth().currentUser?.email
    var cards : [Card] = []
    var dic :  [String : [String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //myCollectionTableView.delegate = self
        myCollectionTableView.dataSource = self
        
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
                        var rarity : String = ""
                        var imageUrl : String = ""
                        for (_, value) in self.dic{
                            id = value[0]
                            name = value[1]
                            rarity = value [2]
                            imageUrl = value[3]
                        }
                        let card = Card(id: id, name: name, imageString: imageUrl, rarity: rarity)
                        self.cards.append(card)
                    }
                    print(self.cards.count)
                    print(self.cards)
                    //Once the cards list is full, reload the tableview
                    self.myCollectionTableView.reloadData()
                }
            }
        }
        
    }

}

extension MyCollectionVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = cards[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCollectionCardCell", for: indexPath)
        cell.textLabel?.text = name
        return cell
    }
}

extension MyCollectionVC : UITableViewDelegate{
    
}
