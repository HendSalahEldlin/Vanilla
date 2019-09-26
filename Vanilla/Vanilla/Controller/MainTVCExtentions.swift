//
//  MainTVCExtentions.swift
//  Vanilla
//
//  Created by Hend  on 9/26/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
import CoreData

extension MainTVC: CellActionDelegate {
    
    func shareARecipe(indexPath: IndexPath) {
        var sourceUrl : String?
        if parent?.restorationIdentifier == "MainRecipes"{
            let recipe = self.recipes[(indexPath as NSIndexPath).row]
            if recipe.recipeURL == nil{
                Spoonacular.sharedInstance().getRecipeLink(recipeId: recipe.id)
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
            let recipe = fetchedResultController.object(at: indexPath)
            presentActivityVC(sourceUrl: recipe.url!)
        }
    }
    
    func addToFav(indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MainTVRecipeCell
        if parent?.restorationIdentifier == "MainRecipes"{
            let recipeId = self.recipes[(indexPath as! NSIndexPath).row].id
            if cell.favBtn.currentImage == #imageLiteral(resourceName: "emptyHeart-30x30"){
                cell.favBtn.setImage(#imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
                Spoonacular.sharedInstance().favRecipes[recipeId!] = Date()
            }else{
                cell.favBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
                if Spoonacular.sharedInstance().favRecipes[recipeId!] == nil{
                    //remove from fetchedResult
                    for recipe in fetchedResultController.fetchedObjects as! [FavRecipe]{
                        if recipe.id == recipeId{
                            dataController.viewContext.delete(recipe)
                            dataController.hasChanges()
                            break
                        }
                    }
                }else{
                    Spoonacular.sharedInstance().favRecipes.removeValue(forKey: recipeId!)
                }
            }
        }else{
            cell.favBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
            let recipeToDelete = fetchedResultController.object(at: indexPath)
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
