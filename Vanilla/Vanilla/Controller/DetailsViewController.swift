//
//  DetailsViewController.swift
//  Vanilla
//
//  Created by Hend  on 9/20/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak internal var timeLabel: UILabel!
    @IBOutlet weak internal var servingsLabel: UILabel!
    @IBOutlet weak internal var favBtn: UIButton!
    @IBOutlet weak var ingredientsTV: UITableView!
    @IBOutlet weak var ingredientsHC: NSLayoutConstraint!
    @IBOutlet weak var instruncionsTV: UITableView!
    @IBOutlet weak var instruncionsHC: NSLayoutConstraint!
    
    var recipeIndex : Int?
    var recipe : Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipe = spoonacular.sharedInstance().recipes[recipeIndex!]
        self.titleLabel.text = recipe!.title
        self.imageView.image = UIImage(data: getImage(imageURL: (recipe?.image!)!)!)
        self.timeLabel.text = "\(recipe!.readyInMinutes!)" + " Mins"
        self.servingsLabel.text =  " serves " + "\(recipe!.servings!)"
        ingredientsHC.constant = CGFloat(recipe?.ingredients?.count ?? 0) * 30
        instruncionsHC.constant = CGFloat(recipe?.instructions?.count ?? 0) * 30
    }
    
    func getImage(imageURL : String) -> Data? {
        var url = URL(string: imageURL)
        if !UIApplication.shared.canOpenURL(url!){
            url = URL(string: spoonacular.Constants.baseUri + imageURL)!
        }
        let data = try? Data(contentsOf: url!)
        return data
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        spoonacular.sharedInstance().getRecipeLink(recipeId: recipe!.id)
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
        
    @IBAction func favBtnPressed(_ sender: UIButton) {
        if favBtn.currentImage == #imageLiteral(resourceName: "emptyHeart-30x30"){
            favBtn.setImage(#imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
        }else{
            favBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
        }
    }
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case ingredientsTV:
            return recipe?.ingredients?.count ?? 0
        case instruncionsTV:
            return recipe?.instructions?.count ?? 0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case ingredientsTV:
            cell = tableView.dequeueReusableCell(withIdentifier: "DetailsIngredientsTVCell")!
            cell.imageView?.image = #imageLiteral(resourceName: "icons8-filled-circle-30")
            cell.textLabel?.text = recipe?.ingredients![(indexPath as NSIndexPath).row]
        case instruncionsTV:
            cell = tableView.dequeueReusableCell(withIdentifier: "InstructionsTVCell")!
            cell.imageView?.image = #imageLiteral(resourceName: "icons8-filled-circle-30")
            cell.textLabel?.text = "\((indexPath as NSIndexPath).row + 1)" + ") " + (recipe?.instructions![(indexPath as NSIndexPath).row])!
        default:()
        }
        return cell
    }
}
