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
    let id : String!
    let title : String?
    let image : String?
    var readyInMinutes : Int?
    var servings: Int?
    var recipeURL : String?
    var ingredients : [String]?
    var instructions : [String]?
    // MARK: Initializers
    
    // construct a Recipes from a dictionary
    init(dictionary: [String:AnyObject]) {
        id = String(describing: dictionary[spoonacular.JSONResponseKeys.id]!)
        title = dictionary[spoonacular.JSONResponseKeys.title] as? String
        image = dictionary[spoonacular.JSONResponseKeys.image] as? String
       }
    
    //get the main properities to view on the main view
    static func getRecipesFromResults(_ results: [[String:AnyObject]]) -> [Recipe] {
        
        var recipes = [Recipe]()
        
        // iterate through array of dictionaries, each Recipe is a dictionary
        for result in results {
            recipes.append(Recipe (dictionary: result))
        }
        
        return recipes
    }
    
    //when cell is selected. this function is called to set the rest properties to be presented on the details view
    mutating func setRemainPropertires(_ dictionary: [String:AnyObject]){
        readyInMinutes = dictionary[spoonacular.JSONResponseKeys.readyInMinutes] as! Int
        servings = dictionary[spoonacular.JSONResponseKeys.servings] as! Int
        recipeURL = dictionary[spoonacular.JSONResponseKeys.sourceUrl] as! String
        
        guard let ingredientsArr = dictionary[spoonacular.JSONResponseKeys.ingredients] as? [[String:AnyObject]] else { return }
        ingredients = [String]()
        for ingredient in ingredientsArr{
            ingredients?.append(ingredient["original"] as! String)
        }
        
        guard let instructionsArr = dictionary[spoonacular.JSONResponseKeys.instructions] as? [[String:AnyObject]] else { return }
        
        instructions = [String]()
        for instruction in instructionsArr{
            let steps = instruction["steps"] as! [[String : AnyObject]]
            for step in steps{
                instructions?.append(step["step"] as! String)
            }
        }
    }
}

