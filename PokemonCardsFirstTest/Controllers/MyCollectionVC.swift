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
    
    var myCollectionManager = MyCollectionManager()
    var cards : [Card] = []
    var listOfImageData : [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register the nib
        registerTheCell()
        //Assign the class as the delegate and data source of the table view
        asignDelegates()
        //Fetch the API data
        myCollectionManager.getCards { (listOfCards) in
            //This populates the list of the users cards
            self.cards = listOfCards
            //This transforms the image strings int data
            self.listOfImageData =  self.myCollectionManager.populateImageDataList(cards: self.cards)
            //Once the cards and imageData lists are populated, reload the tableview
            self.myCollectionTableView.reloadData()
        }
    }
    
    func asignDelegates(){
        myCollectionTableView.delegate = self
        myCollectionTableView.dataSource = self
    }
    
    func registerTheCell(){
        myCollectionTableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
    }

    
    
}




//MARK: - UITableViewDataSource
//Handles with addign the cards to the table

extension MyCollectionVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    //As the user swipes on the screen this function will get called a lot
    //So don't make this method do expensive actions, for example transforming
    //the image strings into data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = cards[indexPath.row].name
        let image = listOfImageData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.cardNameLabel.text = name
        cell.rightImageView.image = UIImage(data: image)

        return cell
    }
}

//MARK: - UITableViewDelegate
//Hnadles with the user interaction with the cells in the table

extension MyCollectionVC : UITableViewDelegate{
    
}
