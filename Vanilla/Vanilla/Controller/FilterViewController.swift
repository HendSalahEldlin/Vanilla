//
//  FilterViewController.swift
//  Vanilla
//
//  Created by Hend  on 9/2/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var IngredientsTV: UITableView!
    @IBOutlet weak var IngredientsHC: NSLayoutConstraint!
    @IBOutlet weak var IngredientsField: UITextField!
    
    var Ingredients = [String]()
    var isIngredTVVisiable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IngredientsTV.delegate = self
        IngredientsTV.dataSource = self
        IngredientsHC.constant = 0
        self.IngredientsField.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredeintsCell")
        let ingredient = self.Ingredients[(indexPath as NSIndexPath).row]
        // Set the name
        cell!.textLabel!.text = ingredient
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row + 1)
        UIView.animate(withDuration: 0.5){
            self.IngredientsHC.constant = 0
            self.isIngredTVVisiable = false
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        spoonacular.sharedInstance().getIngredients(ingredient: self.IngredientsField.text ?? "") {(ingredients, error) in
            if error == nil{
                self.Ingredients = ingredients
                DispatchQueue.main.async {
                    self.textFieldShouldReturn(self.IngredientsField)
                    UIView.animate(withDuration: 0.5){
                        if self.isIngredTVVisiable{
                            self.IngredientsHC.constant = 0
                            self.isIngredTVVisiable = false
                        }else{
                            self.IngredientsTV.reloadData()
                            self.IngredientsHC.constant = 44.0 * 3
                            self.isIngredTVVisiable = true
                        }
                    }
                }
            }
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
