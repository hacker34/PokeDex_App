//
//  Pokemon.swift
//  Podedex
//
//  Created by Johnny Hacking on 1/16/17.
//  Copyright © 2017 HackingInnovations. All rights reserved.
//

import Foundation

// Creating a class that will store all the pokemon data (Blue Print for each pokemon that will be displayed in the App).  This is in the model folder of the MVC structure
class Pokemon{
    
    //*******************************************************************************************
    //This is the best way to setup the information that is going to be stored and used in a class
    
    //Created variables for the information we need
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    
    //Created the getters for the properties created above,  Its a good habbit to always do it right after the variables are created
    var name: String{
        
        return _name
    }
    
    var pokedexId: Int{
        
        return _pokedexId
    }
    
    //Now we need to initialize each pokemon object, this allows you to pass in data to this class.
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        // Build API call with constants and pokedexID
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)"
    }
    
    //******************************************************************************************
    
    func downloadPokemonDetail(){
        
        
    }
}
