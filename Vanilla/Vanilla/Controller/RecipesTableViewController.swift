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
        self.tableView.register(TVRecipeCell.self, forCellReuseIdentifier: "TVRecipeCell")
        /*spoonacular.sharedInstance().getRecipes() {(success, error) in
            if success{
                DispatchQueue.main.async {
                self.recipes = spoonacular.sharedInstance().recipes
                self.tableView.reloadData()
                }
            }
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.recipes = spoonacular.sharedInstance().recipes
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVRecipeCell")! as! TVRecipeCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        let recipe = self.recipes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.titleLabel.text = recipe.title
        cell.minutesLabel.text = "\(recipe.readyInMinutes ?? 0) minutes"
        
        if let imageData = getImage(indexPath: indexPath) {
            cell.imageView?.image = UIImage(data: imageData)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = self.recipes[(indexPath as NSIndexPath).row]
        print(recipe.title!)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let imageData = getImage(indexPath: indexPath) else{
            return 0
        }
        let imageRatio = UIImage(data: imageData)!.getImageRatio()
        return tableView.frame.width / imageRatio
    }
    
    func getImage(indexPath : IndexPath) -> Data? {
        let recipe = self.recipes[(indexPath as NSIndexPath).row]
        guard let image = recipe.image else{
            return nil
        }
        let url = URL(string: spoonacular.Constants.baseUri + image)!
        let data = try? Data(contentsOf: url)
        return data
    }
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}


extension RecipesTableViewController: CellActionDelegate {
    func shareARecipe(indexPath: IndexPath) {
        print("share for index: \(indexPath)")
        let recipe = self.recipes[(indexPath as NSIndexPath).row]
        spoonacular.sharedInstance().getRecipeLink(recipeId: recipe.id)
        {(SourceUrl, error) in
            if error == nil{
                print(SourceUrl)
                let activityVC = UIActivityViewController(activityItems: [SourceUrl as Any], applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = {
                    (activity, success, items, error) in
                    if success{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    
    func addToFav(indexPath: IndexPath) {
        print("favourite \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath) as! TVRecipeCell
        let image = UIImage(named: "redHeart-30x30") as UIImage?
        cell.favBtn.setImage(image, for: .normal)
    }

}
