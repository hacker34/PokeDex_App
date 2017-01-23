//
//  PokemonDetailVC.swift
//  Podedex
//
//  Created by Johnny Hacking on 1/21/17.
//  Copyright © 2017 HackingInnovations. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var nextEvolutiontxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalized
        // image is set here because we already know that data and dont have to request it.
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokedexIdLbl.text = "\(pokemon.pokedexId)"
        
        // Need this function so it can update the UI after it downloads the JSON data
        pokemon.downloadPokemonDetail {
            
            // Whatever we write will only be called after the network call is complete!
            self.updateUI()
        }
    }
    
    func updateUI(){
        // Things are in here that are getting the data
        attackLbl.text = pokemon.baseAttack
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        defenseLbl.text = pokemon.defense
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionID == ""{
            nextEvolutiontxt.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvolutiontxt.text = "Next Evolution: \(pokemon.nextEvolutionName) LVL \(pokemon.nextEvolutionID)"
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: "\(pokemon.nextEvolutionID)")
        }
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }

}
