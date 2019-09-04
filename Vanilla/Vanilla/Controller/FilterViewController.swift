//
//  FilterViewController.swift
//  Vanilla
//
//  Created by Hend  on 9/2/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var ingredientsTV: UITableView!
    @IBOutlet weak var ingredientsField: UITextField!
    @IBOutlet weak var ingredientsHC: NSLayoutConstraint!
    @IBOutlet weak var ingredientsBtn: UIButton!
    
    @IBOutlet weak var recipesTV: UITableView!
    @IBOutlet weak var recipeField: UITextField!
    @IBOutlet weak var recipesHC: NSLayoutConstraint!
    @IBOutlet weak var recipesBtn: UIButton!
    
    var ingredients = [String]()
    var isIngredTVVisiable = false
    var recipes = [String]()
    var isRecipesTVVisiable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTV(arrName: "Recipes")
        configureTV(arrName: "Ingredients")
        
    }
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        if sender == recipesBtn{
            spoonacular.sharedInstance().autoCompleteRecipes(recipes: self.recipeField.text ?? ""){(recipes, error) in
                if error == nil{
                    self.recipes = recipes
                    DispatchQueue.main.async {
                        self.UpdateUI(arrName: "recipes")
                    }
                }
            }
        }else if sender == ingredientsBtn{
            spoonacular.sharedInstance().autoCompleteIngredients(ingredient: self.ingredientsField.text ?? "") {(ingredients, error) in
                if error == nil{
                    self.ingredients = ingredients
                    DispatchQueue.main.async {
                        self.UpdateUI(arrName: "ingredients")
                    }
                }
            }
        }
    }
    
    private func configureTV(arrName:String){
        if arrName == "Recipes"{
            recipesTV.delegate = self
            recipesTV.dataSource = self
            recipesHC.constant = 0
            recipeField.delegate = self
        }else if arrName == "Ingredients"{
            ingredientsTV.delegate = self
            ingredientsTV.dataSource = self
            ingredientsHC.constant = 0
            ingredientsField.delegate = self
        }
    }
    
    private func UpdateUI(arrName: String) {
        
        if arrName == "recipes"{
            self.textFieldShouldReturn(self.recipeField)
            UIView.animate(withDuration: 0.5){
                if self.isRecipesTVVisiable{
                    self.recipesHC.constant = 0
                    self.isRecipesTVVisiable = false
                }else{
                    self.recipesTV.reloadData()
                    self.recipesHC.constant = 30 * 3
                    self.isRecipesTVVisiable = true
                }
            }
        }else if arrName == "ingredients"{
            self.textFieldShouldReturn(self.ingredientsField)
            UIView.animate(withDuration: 0.5){
                if self.isIngredTVVisiable{
                    self.ingredientsHC.constant = 0
                    self.isIngredTVVisiable = false
                }else{
                    self.ingredientsTV.reloadData()
                    self.ingredientsHC.constant = 30 * 3
                    self.isIngredTVVisiable = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch tableView {
        case recipesTV:
            return 5
        case ingredientsTV:
            return ingredients.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == recipesTV{
            cell = tableView.dequeueReusableCell(withIdentifier: "RecipesCell")!
            let recipe = self.recipes[(indexPath as NSIndexPath).row]
            // Set the name
            cell.textLabel!.text = recipe
        }
        else if tableView == ingredientsTV{
            cell = tableView.dequeueReusableCell(withIdentifier: "IngredeintsCell")!
            let ingredient = self.ingredients[(indexPath as NSIndexPath).row]
            // Set the name
            cell.textLabel!.text = ingredient
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row + 1)
        UIView.animate(withDuration: 0.5){
            switch tableView{
            case self.recipesTV:
                self.recipesHC.constant = 0
                self.isRecipesTVVisiable = false
            case self.ingredientsTV:
                self.ingredientsHC.constant = 0
                self.isIngredTVVisiable = false
            default: ()
            }
            self.view.layoutIfNeeded()
        }
    }
    
}

extension FilterViewController:  UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0{
            textField.tag = 1
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
