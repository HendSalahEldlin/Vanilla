//
//  Constants.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

extension Spoonacular {
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let subdomain = "api."
        static let ApiHost = "spoonacular.com"
        static let baseUri = "https://spoonacular.com/recipeImages/"
        static let ingredientsBaseUri = "https://spoonacular.com/cdn/ingredients_100x100/"
    }
  
    // MARK: Methods
    struct URLExtentions {
        static let recipes = "/recipes/"
        static let searchRecipes = "/recipes/random"
        static let autoCompleteIngredients = "/food/ingredients/autocomplete"
        static let autoCompleteRecipes = "/recipes/autocomplete"
        static let recipesComplexSearch = "/recipes/complexSearch"
        static let recipesInformationBulk = "/recipes/informationBulk"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        //MARK: StudentLocation Parameter Keys
        static let apiKey = "apiKey"
        static let number = "number"
        static let instructionsRequired = "instructionsRequired"
        static let recipeId = "id"
        static let query = "query"
        static let ingredients = "includeIngredients"
        static let type = "type"
        static let cuisine = "cuisine"
        static let diet = "diet"
        static let maxReadyTime = "maxReadyTime"
        static let ids = "ids"
    }
    
    struct ParameterValues {
        //MARK: StudentLocation Parameter Keys
        static let apiKey = "533b313eed91460cb6bfe1e1eefe9b7f"
        static let number = "50"
        static let instructionsRequired = "true"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys{
        static let id = "id"
        static let title = "title"
        static let image = "image"
        static let readyInMinutes = "readyInMinutes"
        static let baseUri = "baseUri"
        static let servings = "servings"
        static let sourceUrl = "sourceUrl"
        static let ingredients = "extendedIngredients"
        static let instructions = "analyzedInstructions"
    }
}

