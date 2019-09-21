//
//  RecipesTableViewController.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
class RecipesTableViewController: UITableViewController {
    
    // MARK: Properties
    var recipes = spoonacular.sharedInstance().recipes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TVRecipeCell.self, forCellReuseIdentifier: "TVRecipeCell")
        spoonacular.sharedInstance().getRecipes() {(success, error) in
            if success{
                DispatchQueue.main.async {
                self.recipes = spoonacular.sharedInstance().recipes
                self.tableView.reloadData()
                }
            }
        }
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
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let imageData = getImage(indexPath: indexPath) else{
//            return 0
//        }
//        let imageRatio = UIImage(data: imageData)!.getImageRatio()
//        return tableView.frame.width / imageRatio
//    }
    
    
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

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
    
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}

extension RecipesTableViewController: CellActionDelegate {
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
        let cell = tableView.cellForRow(at: indexPath) as! TVRecipeCell
        if cell.favBtn.currentImage == #imageLiteral(resourceName: "emptyHeart-30x30"){
            cell.favBtn.setImage(#imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
        }else{
            cell.favBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
        }
        
    }

}
