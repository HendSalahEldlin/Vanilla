//
//  MainTVC.swift
//  Vanilla
//
//  Created by Hend  on 9/20/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
class MainTVC: UITableViewController {
    
    // MARK: Properties
    var recipes = spoonacular.sharedInstance().recipes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipes = spoonacular.sharedInstance().recipes
        self.tableView.register(MainTVRecipeCell.self, forCellReuseIdentifier: "RecipeCell")
        /*spoonacular.sharedInstance().getRecipes() {(success, error) in
            if success{
                DispatchQueue.main.async {
                    self.recipes = spoonacular.sharedInstance().recipes
                    self.tableView.reloadData()
                }
            }
        }*/
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell")! as! MainTVRecipeCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        let recipe = self.recipes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        //cell.titleLabel?.text = recipe.title
        //cell.minutesLabel.text = "\(recipe.readyInMinutes ?? 0) minutes"
        
        if let imageData = getImage(indexPath: indexPath) {
            let image = UIImage(data: imageData)
            cell.imageView?.image = image!
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = self.recipes[(indexPath as NSIndexPath).row]
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.recipeIndex = (indexPath as NSIndexPath).row
        
        if recipe.ingredients == nil{
            spoonacular.sharedInstance().getRecipeInformation(recipeId: recipe.id, recipeIndex: (indexPath as NSIndexPath).row) {(success, error) in
                if success{
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailsVC, animated: true)
                    }
                }
            }
        }else{
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    /*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let imageData = getImage(indexPath: indexPath) else{
            return 0
        }
        let imageRatio = UIImage(data: imageData)!.getImageRatio()
        return tableView.frame.width / imageRatio
    }*/
    
    func getImage(indexPath : IndexPath) -> Data? {
        let recipe = self.recipes[(indexPath as NSIndexPath).row]
        guard let image = recipe.image else{
            return nil
        }
        var url = URL(string: image)
        if !UIApplication.shared.canOpenURL(url!){
            url = URL(string: spoonacular.Constants.baseUri + image)!
        }
        let data = try? Data(contentsOf: url!)
        return data
    }
    
}

extension MainTVC: CellActionDelegate {
    func shareARecipe(indexPath: IndexPath) {
        let recipe = self.recipes[(indexPath as NSIndexPath).row]
        spoonacular.sharedInstance().getRecipeLink(recipeId: recipe.id)
        {(SourceUrl, error) in
            if error == nil{
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
        let cell = tableView.cellForRow(at: indexPath) as! MainTVRecipeCell
        if cell.favBtn.currentImage == #imageLiteral(resourceName: "emptyHeart-30x30"){
            cell.favBtn.setImage(#imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
        }else{
            cell.favBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
        }
        
    }
    
}
