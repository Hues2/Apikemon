//
//  ViewController.swift
//  PokemonCardsFirstTest
//
//  Created by Greg Ross on 19/03/2021.
//

import UIKit

class ChooseSetVC: UIViewController {
    
    @IBOutlet weak var setsTableView: UITableView!

    var setsManager = SetsManager()
    var listOfSets : [SetOfCards] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick a set"
        setsTableView.delegate = self
        //Set this class as the delegate for the sets manager
        setsTableView.dataSource = self
        //This next method does not get called until the closure has the result
        //When it does have the result (in this case I named it list)
        //I use it to populate the list and then can reload the table
        setsManager.fetchSets { (list) in
            self.listOfSets = list
            DispatchQueue.main.async {
                self.setsTableView.reloadData()
            }
        }
    }
 
}


//MARK: - UITableViewDataSource

extension ChooseSetVC : UITableViewDataSource{
    //Number of rows will be the size of the array containing all the sets
    // So can't be set until the json data is back from the api
    //The api data is requested on viewDidLoad
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = listOfSets[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath)
        cell.textLabel?.text = name
        return cell
    }
}

extension ChooseSetVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToPackOpener", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToPackOpener"){
            let destination = segue.destination as! PackOpenerVC
            destination.setId = listOfSets[(setsTableView.indexPathForSelectedRow?.row)!].id
            destination.setLogo = listOfSets[(setsTableView.indexPathForSelectedRow?.row)!].logo
        }
    }
    
    
    
}

