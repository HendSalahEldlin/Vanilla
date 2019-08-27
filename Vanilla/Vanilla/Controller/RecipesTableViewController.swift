//
//  RecipesTableViewController.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import Foundation
import UIKit
class RecipesTableViewController: UITableViewController {
    
    // MARK: Properties
    var recipes = spoonacular.sharedInstance().recipes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spoonacular.sharedInstance().getRecipes() {(success, error) in
            DispatchQueue.main.async {
                if success{
                    self.recipes = spoonacular.sharedInstance().recipes
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.recipes = spoonacular.sharedInstance().recipes
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVRecipeCell")! as! TVRecipeCell
        let recipe = self.recipes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.titleLabel.text = recipe.title
        cell.readyInMinutesLabel.text = "\(recipe.readyInMinutes ?? 0)"
        if let image = recipe.image{
            let url = URL(string: spoonacular.Constants.baseUri + image)!
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }
}


