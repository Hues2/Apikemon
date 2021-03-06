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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var myCollectionManager = MyCollectionManager()
    var cards : [Card] = []
    var listOfImageData : [Data] = []
    var isLoading = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your Card Collection"
        //Hide table view and animate the indicator
        displayLoadingIndicator()
        //Register the nib
        registerTheCell()
        //Assign the class as the delegate and data source of the table view
        asignDelegates()
        //Fetch the API data
        myCollectionManager.getCards { (listOfCards) in
            //THIS IS WHERE I NEED TO IMPLEMENT AN ERROR HANDLER IF THE listOfCards GIVE BACK AN ERROR INSTEAD OF A LIST
            //This populates the list of the users cards
            self.cards = listOfCards
            //This transforms the image strings int data
            self.listOfImageData =  self.myCollectionManager.populateImageDataList(cards: self.cards)
            DispatchQueue.main.async {
                //Once the cards and imageData lists are populated, reload the tableview
                self.displayTableView()
            }
        }
    }
    
    func asignDelegates(){
        myCollectionTableView.delegate = self
        myCollectionTableView.dataSource = self
    }
    
    func registerTheCell(){
        myCollectionTableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
    }
    
    func displayLoadingIndicator(){
        myCollectionTableView.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func displayTableView(){
        myCollectionTableView.reloadData()
        isLoading = false
        myCollectionTableView.isHidden = false
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        print("Back on screen!!!!!!!!")
//    }
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
//Handles with the user interaction with the cells in the table

extension MyCollectionVC : UITableViewDelegate{
    //Perfom segue on tap of a cell and pass through the id of the card selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CollectionToCardDisplay", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CollectionToCardDisplay"{
            let destination = segue.destination as! CardDisplayVC
            destination.imageData = listOfImageData[(myCollectionTableView.indexPathForSelectedRow?.row)!]
            destination.card = cards[(myCollectionTableView.indexPathForSelectedRow?.row)!]
            //This sets this VC as the delegate in the prepare method
            destination.cardDisplayManager.deleteDelegate = self
        }
    }
}


//MARK: - Card Dislpay Delete Delegate
//This runs when the card is added to the market, and this removes the card from the 'cards' list
//so that the card isn't in the list when the user is popped back to their collection

extension MyCollectionVC : CardDisplayDeleteDelegate{
    func removeCard(cardId: String, imageString : String) {
        //When this closure returns true it will remove that particular card
        cards.removeAll { (card) -> Bool in
            return card.id == cardId
        }
        //When it returns true it will remove that image data from the list
        listOfImageData.removeAll { (imageUrlData) -> Bool in
            let testUrl = URL(string: imageString)!
            let testData = try! Data(contentsOf: testUrl)
            return imageUrlData == testData
        }
        myCollectionTableView.reloadData()
    }
    
    
}
