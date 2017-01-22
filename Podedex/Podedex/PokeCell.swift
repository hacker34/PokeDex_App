//
//  PokeCell.swift
//  Podedex
//
//  Created by Johnny Hacking on 1/17/17.
//  Copyright © 2017 HackingInnovations. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    // First thing is to ask what do you want is this class?  Always good to start out with
    
    //*************************************************************************************
    //This class modifies/configures the collection view cells.
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //for each poke cell we want to store our poke data in the class we created.
    
    var pokemon: Pokemon!
    
    // This implements rounded corners for cells
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    //function to call to update the collection view cell
    
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    
}
