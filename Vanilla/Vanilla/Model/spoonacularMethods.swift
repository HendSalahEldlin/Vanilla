//
//  spoonacularMethods.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

extension spoonacular{
    
    
    func getRecipes(completionHandlerForRecipes: @escaping (_ success : Bool, _ errorString: String?) -> Void){
        /* 1. Specify parameters, method */
        let parameters = [ParameterKeys.apiKey:ParameterValues.apiKey, ParameterKeys.number:ParameterValues.number, ParameterKeys.instructionsRequired:ParameterValues.instructionsRequired] as! [String : AnyObject]
        taskForGETMethod(Constants.subdomain, method: URLExtentions.searchRecipes, parameters: parameters){(results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForRecipes(false, error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                let mainDictionary = results as! [String: AnyObject]
                let resultDictionry = mainDictionary["results"] as? [[String: AnyObject]]
                self.recipes = Recipe.getRecipesFromResults(resultDictionry!)
                completionHandlerForRecipes(true, nil)
            }
        }
        
    }
    
    func getRecipeLink(recipeId : String, completionHandlerForRecipes: @escaping (_ SourceUrl : String, _ errorString: String?) -> Void){
        /* 1. Specify parameters, method */
        let parameters = [ParameterKeys.apiKey:ParameterValues.apiKey] as! [String : AnyObject]
        
        let extention = URLExtentions.recipes + recipeId + "/information"
        taskForGETMethod(Constants.subdomain, method: extention, parameters: parameters){(results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForRecipes("", error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                let mainDictionary = results as! [String: AnyObject]
                let SourceUrl = mainDictionary["sourceUrl"] as? String
                completionHandlerForRecipes(SourceUrl!, nil)
            }
        }
        
    }
    
    func autoCompleteIngredients(ingredient : String, completionHandlerForRecipes: @escaping (_ names : [String], _ errorString: String?) -> Void){
        /* 1. Specify parameters, method */
        let parameters = [ParameterKeys.apiKey:ParameterValues.apiKey, ParameterKeys.query:ingredient, ParameterKeys.number:ParameterValues.number] as! [String : AnyObject]
        
        let extention = URLExtentions.autoCompleteIngredients
        taskForGETMethod(Constants.subdomain, method: extention, parameters: parameters){(results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForRecipes([String](), error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                let resultsArr = results as! [[String: String]]
                var namesArr = [String]()
                for result in resultsArr{
                    namesArr.append(result["name"]!)
                }
                completionHandlerForRecipes(namesArr, nil)
            }
        }
        
    }
    
    func autoCompleteRecipes(recipes : String, completionHandlerForRecipes: @escaping (_ titles : [String], _ errorString: String?) -> Void){
        /* 1. Specify parameters, method */
        let parameters = [ParameterKeys.apiKey:ParameterValues.apiKey, ParameterKeys.query:recipes, ParameterKeys.number:ParameterValues.number] as! [String : AnyObject]
        
        let extention = URLExtentions.autoCompleteRecipes
        taskForGETMethod(Constants.subdomain, method: extention, parameters: parameters){(results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForRecipes([String](), error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                let resultsArr = results as! [[String: AnyObject]]
                var titlesArr = [String]()
                for result in resultsArr{
                    titlesArr.append(result["title"]! as! String)
                }
                completionHandlerForRecipes(titlesArr, nil)
            }
        }
        
    }
    
    func recipesComplexSearch(recipes : String, ingredients : String, type : String, cuisine : String, diet : String, maxReadyTime : Int, completionHandlerForComplexSearch: @escaping (_ success : Bool, _ errorString: String?) -> Void){
        /* 1. Specify parameters, method */
        let parameters = [ParameterKeys.apiKey:ParameterValues.apiKey, ParameterKeys.number:ParameterValues.number, ParameterKeys.query:recipes, ParameterKeys.ingredients:ingredients, ParameterKeys.type:type, ParameterKeys.cuisine:cuisine, ParameterKeys.diet:diet, ParameterKeys.maxReadyTime:maxReadyTime] as! [String : AnyObject]
        
        let extention = URLExtentions.recipesComplexSearch
        taskForGETMethod(Constants.subdomain, method: extention, parameters: parameters){(results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForComplexSearch(false, error.userInfo["NSLocalizedDescription"] as! String)
            } else {
                let mainDictionary = results as! [String: AnyObject]
                let resultDictionry = mainDictionary["results"] as? [[String: AnyObject]]
                self.recipes = Recipe.getRecipesFromResults(resultDictionry!)
                completionHandlerForComplexSearch(true, nil)
            }
        }
        
    }
}
