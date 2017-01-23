//
//  Pokemon.swift
//  Podedex
//
//  Created by Johnny Hacking on 1/16/17.
//  Copyright © 2017 HackingInnovations. All rights reserved.
//

import Foundation
import Alamofire
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
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    //**********************************
    //inserted later on for data protection
    
    var nextEvolutionName: String{
        if _nextEvolutionName == nil{
            
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil{
            
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionLevel: String{
        
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var description: String{
        
        if _description == nil{
            
            _description = ""
        }
        return _description
    }
    
    var type: String{
        
        if _type == nil{
            
            _type = ""
        }
        return _type
    }
    
    var defense: String{
        
        if _defense == nil{
            
            _defense = ""
        }
        return _defense
    }
    
    var height: String{
        
        if _height == nil{
            
            _height = ""
        }
        return _height
    }
    
    var weight: String{
        
        if _weight == nil{
            
            _weight = ""
        }
        return _weight
    }
    
    var baseAttack: String{
        
        if _baseAttack == nil{
            
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var nextEvolutionTxt: String{
        
        if _nextEvolutionTxt == nil{
            
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    //**********************************
    
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
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL!).responseJSON{ (response) in
            
           // print(self._pokemonURL)   --- Used to debug why JSON data wasn't showing properly
            
            // Basically storinging all the JSON data into the dict var as a Dictionary
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    
                    self._baseAttack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._baseAttack)
                print(self._defense)
                
                // types value in the JSON is a dictionary so we cast it as an array of dictionaries
                if let type = dict["types"] as? [Dictionary<String, String>] , type.count > 0{
                    
                    if let name = type[0]["name"]{
                        
                        self._type = name.capitalized
                    }
                    
                    if type.count > 1 {
                        
                        for x in 1..<type.count {
                            if let name = type[x]["name"]{
                                
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                   // print(self._type)
                    
                    
                }else {
                    
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"]{
                        
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                    print(newDescription)
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil{
                            
                            self._nextEvolutionName = nextEvo
                        }
                        
                        if let uri = evolutions[0]["resource_uri"] as? String {
                            let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                            
                            self._nextEvolutionID = nextEvoID
                            
                            if let lvlExist = evolutions[0]["level"] {
                                
                                if let lvl = lvlExist as? Int{
                                    
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                                
                            }else{
                                self._nextEvolutionLevel = ""
                            }
                        }
                        
                        
                    }
                        
                }
                
            }
            
            completed()
        }
    }
}
