//
//  ViewController.swift
//  Podedex
//
//  Created by Johnny Hacking on 12/27/16.
//  Copyright © 2016 HackingInnovations. All rights reserved.
//

import UIKit
import AVFoundation // Needed for music

//Import the needed protocals for the UICollection View to work properly
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    
    // Search bar to search for pokemon
    @IBOutlet weak var searchBar: UISearchBar!  // Added the search bar protocal to get functions we need to search text
    
    
    // This is array holding all the pokemon data coming out of csv
    var pokemon = [Pokemon]()
    // This is a filtered array of the pokemon for the search bar
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // connecting data source and delagate to collection which is an IBOutlet from above that is connected.
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    // function to load the music
    func initAudio(){
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError{
            
            print(err.debugDescription)
        }
        
    }
    
    // This will parse through csv file and its called as soon as the app is loaded.  You can see it being called above
    func parsePokemonCSV(){
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        // when doing a do statement you must have a catch which is easy just say to print errors
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
            
        } catch let err as NSError{
            
            print(err.debugDescription)
            
        }
        
    }
    
    //***************************************************************************************************
    //The followoing functions are required to get the collection view working.  Boilerplate code
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create cells
        
        // Use the DequeueReusable to create cells as they are on the page instead of loading all.
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            // I am creating a cell object from our pokemon class and using the configureCell method we created to place object into
            // Model Portion
            //      let pokemon = Pokemon(name: "Pokemon", pokedexId: indexPath.row) ------ Changed to code below after test
            
            //       let poke = pokemon[indexPath.row]
            
            // added it into the view
            // View Portion
            //       cell.configureCell(poke)
            
            let poke: Pokemon!
            
            if inSearchMode{
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            return cell
        }else{
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode{
            
            poke = filteredPokemon[indexPath.row]
        } else{
            poke = pokemon[indexPath.row]
        }
        
        //  Make sure seguea is setup in story board
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //pokemon is the array variable from above
        if inSearchMode{
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    //********************************************************************************************************
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0   //changing the transparency when in a state.
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            //$0 is a place holder for all the items in the original pokemon array variable
            //we are setting filteredPokemon equal to the full array variable and seeing if anything that is in lower/ text in search bar is included in the range of that list.  Hope that makes sense
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
        
    }
    
    // Function to prepare data to be sent in segua
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC{
                // Sender of type Pokemon which you can see is being sent from above on did select func and detailsVC is pulling from the PokemonDetailVC class where that var is defined
                if let poke = sender as? Pokemon{
                    detailsVC.pokemon = poke
                }
            }
        }
        
    }
    

}

