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
    
    override func viewDidLoad() {
        super.viewDidLoad()

       nameLbl.text = pokemon.name
    }

    @IBOutlet weak var nameLbl: UILabel!

}
