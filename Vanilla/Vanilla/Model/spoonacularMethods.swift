//
//  spoonacularMethods.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

extension spoonacular{
    
    
    func getRecipes(completionHandlerForRecipes: @escaping (_ success : Bool, _ errorString: String?) -> Void){
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
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
    
}
