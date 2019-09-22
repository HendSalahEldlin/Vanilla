//
//  FavouritesViewController.swift
//  Vanilla
//
//  Created by Hend  on 9/21/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
import CoreData

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    var dataController : DataController!
    var fetchedresultController : NSFetchedResultsController<FavRecipe>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.delegate = self
        fetchedresultController.delegate = self
        setUpFetchedResultController()
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
    }

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedresultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavRecipeCell")! as! TVRecipeCell
        
        cell.indexPath = indexPath
        cell.delegate = self
        let recipe = fetchedresultController.object(at: indexPath)
        
        // Set the name and image
        cell.titleLabel.text = recipe.title
        cell.imageView?.image = UIImage(data: recipe.image!)
        
        return cell
    }
    
}

extension FavouritesViewController: CellActionDelegate {
    func shareARecipe(indexPath: IndexPath) {
        let recipe = fetchedresultController.object(at: indexPath)
        let activityVC = UIActivityViewController(activityItems: [recipe.url as Any], applicationActivities: nil)
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
        cell.favBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
        //remove from tableView
        let recipeToDelete = fetchedresultController.object(at: indexPath)
        dataController.viewContext.delete(recipeToDelete)
        dataController.hasChanges()
    }
    
}

extension FavouritesViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .left)
        default:
            break
        }
    }
}
