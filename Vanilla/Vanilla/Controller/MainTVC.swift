//
//  MainTVC.swift
//  Vanilla
//
//  Created by Hend  on 9/20/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
import CoreData

class MainTVC: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    var recipes = spoonacular.sharedInstance().recipes
    var dataController : DataController!
    var fetchedresultController : NSFetchedResultsController<FavRecipe>!
    // inial count for tableview cells
    var InializedCellCount = 20
    //fromFilter and refresh are bool values. they are set to true if the last view contoller was the filter view controller, but their values are updated in different places
    var fromFilter = false
    var refresh = false
    
    // MARK: UIViewController Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MainTVRecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        self.navigationItem.title = "Vanilla"
        
        // get random recipes
        spoonacular.sharedInstance().getRecipes() {(success, error) in
            if success{
                self.recipes = spoonacular.sharedInstance().recipes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataController = DataController(modelName: "Vanilla")
        dataController.load()
        setUpFetchedResultController()
        
        // make request to get fav recipes information and save them to coreData before present the view
        if spoonacular.sharedInstance().favRecipes.count>0{
            let Ids = Array(spoonacular.sharedInstance().favRecipes.keys).joined(separator: ",")
            spoonacular.sharedInstance().getRecipeInformationBulk(Ids:Ids) {(results, error) in
                if error == nil{
                    self.saveLastAddedToFavs(results)
                }else{
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                }
            }
        }
        
        if parent?.restorationIdentifier == "MainRecipes"{
            // if the last view was the filter result, It will need to refresh the data to present
            //new recipes not the filter result recipes
            if refresh{
                // get new random recipes
                spoonacular.sharedInstance().getRecipes() {(success, error) in
                    if success{
                        self.recipes = spoonacular.sharedInstance().recipes
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showAlert()
                        }
                    }
                }
            }else{
                self.recipes = spoonacular.sharedInstance().recipes
                self.tableView.reloadData()
            }
        }else{
            for btn in self.navigationItem.rightBarButtonItems!{
                btn.isEnabled = false
            }
            self.navigationItem.title = "My Favorites"
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if parent?.restorationIdentifier == "MainRecipes"{
            if fromFilter{
                refresh = true
            }
            fromFilter = false
        }
    }
    
    // MARK: Defined Functions
    
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
    
    // saves fav recipes information to coreData
    fileprivate func saveLastAddedToFavs(_ results: [[String : AnyObject]]) {
        for i in 0..<results.count{
            let favRecipe = FavRecipe(context: dataController.viewContext)
            favRecipe.id = String(describing: results[i][spoonacular.JSONResponseKeys.id]!)
            favRecipe.title = results[i][spoonacular.JSONResponseKeys.title] as? String
            favRecipe.minutes = Int16(results[i][spoonacular.JSONResponseKeys.readyInMinutes] as! Int)
            favRecipe.servings = Int16(results[i][spoonacular.JSONResponseKeys.servings] as! Int)
            favRecipe.url = results[i][spoonacular.JSONResponseKeys.sourceUrl] as! String
            favRecipe.creationDate = spoonacular.sharedInstance().favRecipes[favRecipe.id as! String]
            favRecipe.image = try? Data(contentsOf: URL(string: (results[i][spoonacular.JSONResponseKeys.image] as? String)!)!)
            
            guard let ingredientsArr = results[i][spoonacular.JSONResponseKeys.ingredients] as? [[String:AnyObject]] else { return }
            for ingredient in ingredientsArr{
                let myIngredient = Ingredient(context: dataController.viewContext)
                myIngredient.recipeId = favRecipe.id
                myIngredient.original = ingredient["original"] as! String
                myIngredient.image = try? Data(contentsOf: URL(string: spoonacular.Constants.ingredientsBaseUri + (ingredient["image"] as! String))!)
            }
            
            guard let instructionsArr = results[i][spoonacular.JSONResponseKeys.instructions] as? [[String:AnyObject]] else { return }
             for instruction in instructionsArr{
                 let steps = instruction["steps"] as! [[String : AnyObject]]
                 for step in steps{
                    let myStep = Instruction(context: dataController.viewContext)
                    myStep.recipeId = favRecipe.id
                    myStep.step = step["step"] as! String
                 }
             }
        }
        dataController.hasChanges()
        spoonacular.sharedInstance().favRecipes.removeAll()
    }
    
    //get image data from link
    func getImage(indexPath : IndexPath) -> Data? {
        if parent?.restorationIdentifier == "MainRecipes"{
            let recipe =  self.recipes[(indexPath as NSIndexPath).row]
            guard let image = recipe.image else{ return nil}
            var url = URL(string: image)
            if !UIApplication.shared.canOpenURL(url!){
                url = URL(string: spoonacular.Constants.baseUri + image)!
            }
            let data = try? Data(contentsOf: url!)
            return data
        }
        else{
            let recipe =  fetchedresultController.object(at: indexPath)
            return recipe.image
        }
    }
    
    //update cell design during downloading data to activityIndicator and vice versa
    func changeCellDesign(withActivityIndicator: Bool, cell : MainTVRecipeCell){
        if withActivityIndicator{
            cell.ActivityIndicator.startAnimating()
            cell.myImageView.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.4078431373, blue: 0.2039215686, alpha: 0.66)
        }else{
            cell.ActivityIndicator.stopAnimating()
            cell.myImageView.backgroundColor = #colorLiteral(red: 1, green: 0.9278470278, blue: 0.6771306396, alpha: 0)
        }
        cell.titleLabel.isHidden = withActivityIndicator
        cell.favBtn.isHidden = withActivityIndicator
        cell.shareBtn.isHidden = withActivityIndicator
        cell.isUserInteractionEnabled = !withActivityIndicator
    }
    
    //presentActivityVC to share recipe link
    func presentActivityVC(sourceUrl: String){
        let activityVC = UIActivityViewController(activityItems: [sourceUrl as Any], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    //show alert on network failture
    func showAlert(){
        let alert = UIAlertController(title: "OOPS!", message: "Something went wrong, Do you prefer to reload Vanilla", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.viewWillAppear(true)
            @unknown default:()
            }
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        spoonacular.sharedInstance().getRecipes() {(success, error) in
            if success{
                self.recipes = spoonacular.sharedInstance().recipes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
}

extension MainTVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parent?.restorationIdentifier == "MainRecipes" ? recipes.count == 0 ? InializedCellCount : recipes.count : fetchedresultController.fetchedObjects?.count ?? InializedCellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell")! as! MainTVRecipeCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        if parent?.restorationIdentifier == "MainRecipes"{
            if recipes.count != 0 {
                changeCellDesign(withActivityIndicator: false, cell: cell)
                
                let recipe = self.recipes[(indexPath as NSIndexPath).row]
                // Set the name and image
                cell.titleLabel.text = recipe.title
                if let imageData = getImage(indexPath: indexPath) {
                    let image = UIImage(data: imageData)
                    cell.myImageView.image = image!
                }
                cell.favBtn.setImage( #imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
                if spoonacular.sharedInstance().favRecipes[recipe.id] != nil{
                    cell.favBtn.setImage(#imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
                }
                for favRecipe in fetchedresultController!.fetchedObjects as! [FavRecipe]{
                    if favRecipe.id == recipe.id{
                        cell.favBtn.setImage( #imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
                    }
                }
            }else{
                changeCellDesign(withActivityIndicator: true, cell: cell)
            }
        }else{
            changeCellDesign(withActivityIndicator: false, cell: cell)
            let recipe = fetchedresultController.object(at: indexPath)
            
            // Set the name and image
            cell.titleLabel.text = recipe.title
            cell.myImageView.image = UIImage(data: recipe.image!)
            cell.favBtn.setImage(#imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if recipes.count != 0 {
            guard let imageData = getImage(indexPath: indexPath) else{
                return 0
            }
            let imageRatio = UIImage(data: imageData)!.getImageRatio()
            return tableView.frame.width / imageRatio
        }
        return 186.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if spoonacular.sharedInstance().favRecipes.count>0{
            let Ids = Array(spoonacular.sharedInstance().favRecipes.keys).joined(separator: ",")
            
            spoonacular.sharedInstance().getRecipeInformationBulk(Ids:Ids) {(results, error) in
                if error == nil{
                    self.saveLastAddedToFavs(results)
                }else{
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                }
            }
        }
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            detailsVC.dataController = self.dataController
        if parent?.restorationIdentifier == "MainRecipes"{
            let recipe = self.recipes[(indexPath as NSIndexPath).row]
            detailsVC.recipeIndex = (indexPath as NSIndexPath).row
            if recipe.ingredients == nil{
                spoonacular.sharedInstance().getRecipeInformation(recipeId: recipe.id, recipeIndex: (indexPath as NSIndexPath).row) {(success, error) in
                    if success{
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(detailsVC, animated: true)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showAlert()
                        }
                    }
                }
            }else{
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }else{
            let recipe = fetchedresultController.object(at: indexPath)
            detailsVC.recipeId = recipe.id
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension MainTVC: CellActionDelegate {
    
    func shareARecipe(indexPath: IndexPath) {
        var sourceUrl : String?
        if parent?.restorationIdentifier == "MainRecipes"{
            let recipe = self.recipes[(indexPath as NSIndexPath).row]
            if recipe.recipeURL == nil{
                spoonacular.sharedInstance().getRecipeLink(recipeId: recipe.id)
                {(SourceUrl, error) in
                    if error == nil{
                        DispatchQueue.main.async {
                             self.presentActivityVC(sourceUrl: SourceUrl)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.showAlert()
                        }
                    }
                }
            }else{
                presentActivityVC(sourceUrl: recipe.recipeURL!)
            }
        }else{
            let recipe = fetchedresultController.object(at: indexPath)
            presentActivityVC(sourceUrl: recipe.url!)
        }
    }
    
    func addToFav(indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MainTVRecipeCell
        if parent?.restorationIdentifier == "MainRecipes"{
            let recipeId = self.recipes[(indexPath as! NSIndexPath).row].id
            if cell.favBtn.currentImage == #imageLiteral(resourceName: "emptyHeart-30x30"){
                cell.favBtn.setImage(#imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
                spoonacular.sharedInstance().favRecipes[recipeId!] = Date()
            }else{
                cell.favBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
                if spoonacular.sharedInstance().favRecipes[recipeId!] == nil{
                    //remove from fetchedResult
                    for recipe in fetchedresultController.fetchedObjects as! [FavRecipe]{
                        if recipe.id == recipeId{
                            dataController.viewContext.delete(recipe)
                            dataController.hasChanges()
                            break
                        }
                    }
                }else{
                    spoonacular.sharedInstance().favRecipes.removeValue(forKey: recipeId!)
                }
            }
        }else{
            cell.favBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
            let recipeToDelete = fetchedresultController.object(at: indexPath)
            dataController.viewContext.delete(recipeToDelete)
            dataController.hasChanges()
        }
    }
    
}

extension MainTVC: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if parent?.restorationIdentifier == "FavRecipes"{
                tableView.deleteRows(at: [indexPath!], with: .left)
            }
        default:
            break
        }
    }
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}
