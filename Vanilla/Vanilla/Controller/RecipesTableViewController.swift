//
//  RecipesTableViewController.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
import CoreData
class RecipesTableViewController: UITableViewController {
    
    // MARK: Properties
    var recipes = spoonacular.sharedInstance().recipes
    var dataController : DataController!
    var fetchedresultController : NSFetchedResultsController<FavRecipe>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = parent?.restorationIdentifier
        self.tableView.register(TVRecipeCell.self, forCellReuseIdentifier: "TVRecipeCell")
        if parent?.restorationIdentifier == "MainRecipes"{
            //MainRecipes
            spoonacular.sharedInstance().getRecipes() {(success, error) in
                if success{
                    DispatchQueue.main.async {
                        self.recipes = spoonacular.sharedInstance().recipes
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if parent?.restorationIdentifier == "FavRecipes"{
            dataController = DataController(modelName: "Vanilla")
            setUpFetchedResultController()
            if spoonacular.sharedInstance().favRecipes.count>0{
                let Ids = Array(spoonacular.sharedInstance().favRecipes.keys).joined(separator: ",")
                
                spoonacular.sharedInstance().getRecipeInformationBulk(Ids:Ids) {(results, error) in
                    if error == nil{
                        self.getLastAddedToFavs(results)
                        DispatchQueue.main.async {
                            //self.recipes = spoonacular.sharedInstance().recipes
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedresultController = nil
    }
    
    fileprivate func setUpFetchedResultController() {
        let fetchRequest : NSFetchRequest<FavRecipe> = FavRecipe.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedresultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedresultController.delegate = self
        do{
            try fetchedresultController.performFetch()
        }catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    fileprivate func getLastAddedToFavs(_ results: [[String : AnyObject]]) {
        for i in 0..<results.count{
            let favRecipe = FavRecipe(context: dataController.viewContext)
            favRecipe.id = String(describing: results[i][spoonacular.JSONResponseKeys.id]!)
            favRecipe.title = results[i][spoonacular.JSONResponseKeys.title] as? String
            favRecipe.image = try? Data(contentsOf: URL(string: (results[i][spoonacular.JSONResponseKeys.image] as? String)!)!)
            favRecipe.minutes = Int16(results[i][spoonacular.JSONResponseKeys.readyInMinutes] as! Int)
            favRecipe.servings = Int16(results[i][spoonacular.JSONResponseKeys.servings] as! Int)
            favRecipe.url = results[i][spoonacular.JSONResponseKeys.sourceUrl] as! String
            favRecipe.creationDate = spoonacular.sharedInstance().favRecipes[favRecipe.id as! String]
            
            dataController.viewContext.insert(favRecipe)
            dataController.hasChanges()
            
            guard let ingredientsArr = results[i][spoonacular.JSONResponseKeys.ingredients] as? [[String:AnyObject]] else { return }
            for ingredient in ingredientsArr{
                let myIngredient = Ingredient(context: dataController.viewContext)
                myIngredient.recipeId = favRecipe.id
                myIngredient.original = ingredient["original"] as! String
                myIngredient.image = try? Data(contentsOf: URL(string: spoonacular.Constants.ingredientsBaseUri + (ingredient["image"] as! String))!)
                dataController.viewContext.insert(myIngredient)
                dataController.hasChanges()
            }
            
            /*guard let instructionsArr = results[i][spoonacular.JSONResponseKeys.instructions] as? [[String:AnyObject]] else { return }
             
             var instructions = [String]()
             for instruction in instructionsArr{
             let steps = instruction["steps"] as! [[String : AnyObject]]
             for step in steps{
             instructions.append(step["step"] as! String)
             }
             }*/
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parent?.restorationIdentifier == "MainRecipes" ? recipes.count : fetchedresultController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVRecipeCell")! as! TVRecipeCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        switch parent?.restorationIdentifier {
        case "MainRecipes":
            let recipe = self.recipes[(indexPath as NSIndexPath).row]
            // Set the name and image
            cell.titleLabel.text = recipe.title
            if let imageData = getImage(indexPath: indexPath) {
                let image = UIImage(data: imageData)
                cell.imageView?.image = image!
            }
        case "FavRecipes":
            let recipe = fetchedresultController.object(at: indexPath)
            
            // Set the name and image
            cell.titleLabel.text = recipe.title
            cell.mainImageView.image = UIImage(data: recipe.image!)
        default:()
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch parent?.restorationIdentifier {
        case "MainRecipes":
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
        default:()
        }
        
        
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
        var url = URL(string: image)
        if !UIApplication.shared.canOpenURL(url!){
            url = URL(string: spoonacular.Constants.baseUri + image)!
        }
        let data = try? Data(contentsOf: url!)
        return data
    }
    
}

extension RecipesTableViewController: CellActionDelegate {
    func shareARecipe(indexPath: IndexPath) {
        var sourceUrl : String?
        switch parent?.restorationIdentifier {
        case "MainRecipes":
            let recipe = self.recipes[(indexPath as NSIndexPath).row]
            if recipe.recipeURL == nil{
                spoonacular.sharedInstance().getRecipeLink(recipeId: recipe.id)
                {(SourceUrl, error) in
                    if error == nil{
                        sourceUrl = SourceUrl
                    }
                }
            }else{
                sourceUrl = recipe.recipeURL
            }
        case "FavRecipes":
            let recipe = fetchedresultController.object(at: indexPath)
            sourceUrl = recipe.url
        default:()
        }
        
        let activityVC = UIActivityViewController(activityItems: [sourceUrl as Any], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success{
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    func addToFav(indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TVRecipeCell
        let recipeId = parent?.restorationIdentifier == "MainRecipes" ? self.recipes[(indexPath as! NSIndexPath).row].id : fetchedresultController.object(at: indexPath).id
        if cell.favBtn.currentImage == #imageLiteral(resourceName: "emptyHeart-30x30"){
            cell.favBtn.setImage(#imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
            spoonacular.sharedInstance().favRecipes[recipeId!] = Date()
        }else{
            cell.favBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
            spoonacular.sharedInstance().favRecipes.removeValue(forKey: recipeId!)
        }
    }

}

extension RecipesTableViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            break
            //tableView.insertRows(at: [newIndexPath!], with: .right)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .left)
        default:
            break
        }
    }
}
