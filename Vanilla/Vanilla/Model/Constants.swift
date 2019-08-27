//
//  Constants.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

extension spoonacular {
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let subdomain = "api."
        static let ApiHost = "spoonacular.com"
        static let baseUri = "https://spoonacular.com/recipeImages/"
    }
    
    // MARK: Methods
    struct URLExtentions {
        static let searchRecipes = "/recipes/search"
        static let Ingredients = "/food/ingredients"
        static let Products = "/food/products"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        //MARK: StudentLocation Parameter Keys
        static let apiKey = "apiKey"
        static let ingredients = "ingredients"
        static let number = "number"
        static let query = "query"
        static let cuisine = "cuisine"
        static let diet = "diet"
        static let intolerances = "intolerances"
        static let instructionsRequired = "instructionsRequired"
    }
    
    struct ParameterValues {
        //MARK: StudentLocation Parameter Keys
        static let apiKey = "533b313eed91460cb6bfe1e1eefe9b7f"
        static let number = "100"
        static let instructionsRequired = "true"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys{
        static let id = "id"
        static let title = "title"
        static let image = "image"
        static let readyInMinutes = "readyInMinutes"
        static let baseUri = "baseUri"
    }
    
    enum Cuisines {
        case African, American, British, Cajun, Caribbean, Chinese, EasternEuropean, European, French, German, Greek, Indian, Irish, Italian, Japanese, Jewish, Korean, LatinAmerican, Mediterranean, Mexican, MiddleEastern, Nordic, Southern, Spanish, Thai, Vietnamese
    }
    
    enum Diet {
        case GlutenFree, Ketogenic, Vegetarian, Lacto_Vegetarian, Ovo_Vegetarian, Vegan, Pescetarian, Paleo, Primal, Whole30
    }
    
    enum Intolerances{
        case DairyFree, EggFree, GlutenFree, GrainFree, PeanutFree, SeafoodFree, SesameFree, ShellfishFree, SoyFree, SulfiteFree, TreeNutFree, WheatFree}
}

