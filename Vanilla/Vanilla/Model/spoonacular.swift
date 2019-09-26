//
//  spoonacular.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import Foundation
class Spoonacular : NSObject{
    // MARK: Properties
    public var recipes = [Recipe]()
    // dictionary for saving the user fav recipes ids and the time of marking them as fav
    //It's used to make one request for multipe recipes information instead of multipe requests
    //and save them to coreData 
    public var favRecipes = [String:Date]()
    
    // shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // create a URL from parameters
    func createURLFromParameters(_ parameters: [String:AnyObject], withSubdomain: String? = nil,withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Spoonacular.Constants.ApiScheme
        components.host = (withSubdomain ?? "") + Spoonacular.Constants.ApiHost
        components.path = (withPathExtension ?? "")
        if parameters.count > 0{
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    // MARK: GET
    func taskForGETMethod(_ Subdomain:String, method: String, parameters: [String:AnyObject],  completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var urlParameters = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: createURLFromParameters(urlParameters, withSubdomain: Subdomain, withPathExtension: method))
        print(request.url!)
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data,  completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> Spoonacular {
        struct Singleton {
            static var sharedInstance = Spoonacular()
        }
        return Singleton.sharedInstance
    }
}
