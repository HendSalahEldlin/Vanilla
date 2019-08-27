//
//  Recipes.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

// MARK: - StudentInformation
struct Recipe{
    
    // MARK: Properties
    let id : String
    let title : String?
    let image : String?
    let readyInMinutes : Int?
    
    // MARK: Initializers
    
    // construct a Recipes from a dictionary
    init(dictionary: [String:AnyObject]) {
        id = String(describing: dictionary[spoonacular.JSONResponseKeys.id])
        title = dictionary[spoonacular.JSONResponseKeys.title] as? String
        image = dictionary[spoonacular.JSONResponseKeys.image] as? String
        readyInMinutes = dictionary[spoonacular.JSONResponseKeys.readyInMinutes] as? Int
       }
    
    static func getRecipesFromResults(_ results: [[String:AnyObject]]) -> [Recipe] {
        
        var recipes = [Recipe]()
        
        // iterate through array of dictionaries, each Recipe is a dictionary
        for result in results {
            recipes.append(Recipe (dictionary: result))
        }
        
        return recipes
    }
}

