//
//  FilterViewController.swift
//  Vanilla
//
//  Created by Hend  on 9/2/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var recipesTV: UITableView!
    @IBOutlet weak var recipeField: UITextField!
    @IBOutlet weak var recipesHC: NSLayoutConstraint!
    @IBOutlet weak var recipesBtn: UIButton!
    @IBOutlet weak var recipesStackView: UIStackView!
    @IBOutlet weak var recipesStackViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var ingredientsTV: UITableView!
    @IBOutlet weak var ingredientsField: UITextField!
    @IBOutlet weak var ingredientsHC: NSLayoutConstraint!
    @IBOutlet weak var ingredientsBtn: UIButton!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    @IBOutlet weak var ingredientsStackViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var typeTV: UITableView!
    @IBOutlet weak var typeHC: NSLayoutConstraint!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var typesStackView: UIStackView!
    @IBOutlet weak var typeStackViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var cuisineTV: UITableView!
    @IBOutlet weak var cuisineHC: NSLayoutConstraint!
    @IBOutlet weak var cuisineBtn: UIButton!
    @IBOutlet weak var cuisinesStackView: UIStackView!
    @IBOutlet weak var cuisinesStackViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var dietTV: UITableView!
    @IBOutlet weak var dietHC: NSLayoutConstraint!
    @IBOutlet weak var dietBtn: UIButton!
    @IBOutlet weak var dietsStackView: UIStackView!
    @IBOutlet weak var dietsStackViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var minField: UITextField!
    @IBOutlet weak var slider: UISlider!
    
    var ingredients = [String]()
    var isIngredTVVisiable = false
    
    var recipes = [String]()
    var isRecipesTVVisiable = false
    
    let recipeTypes = [ "mainCourse", "sideDish", "dessert", "appetizer", "salad", "bread", "breakfast", "soup", "beverage", "sauce", "marinade", "fingerfood", "snack", "drink"]
    var isTypeTVVisiable = false
    
    let cuisines = ["African", "American", "British", "Cajun", "Caribbean", "Chinese", "EasternEuropean", "European", "French", "German", "Greek", "Indian", "Irish", "Italian", "Japanese", "Jewish", "Korean", "LatinAmerican", "Mediterranean", "Mexican", "MiddleEastern", "Nordic", "Southern", "Spanish", "Thai", "Vietnamese"]
    var isCuisineTVVisiable = false
    
    let diets = ["GlutenFree", "Ketogenic", "Vegetarian", "Lacto_Vegetarian", "Ovo_Vegetarian", "Vegan", "Pescetarian", "Paleo", "Primal", "Whole30"]
    var isDietTVVisiable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTV(arrName: "Recipes")
        configureTV(arrName: "Ingredients")
        configureTV(arrName: "recipeTypes")
        configureTV(arrName: "Cuisines")
        configureTV(arrName: "Diets")
        minField.delegate = self
    }
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        switch sender {
        case recipesBtn:
            spoonacular.sharedInstance().autoCompleteRecipes(recipes: self.recipeField.text ?? ""){(recipes, error) in
                if error == nil{
                    self.recipes = recipes
                    DispatchQueue.main.async {
                        self.UpdateUI(arrName: "recipes")
                        self.closeOtherTVs(UIControl: sender)
                    }
                }
            }
        case ingredientsBtn:
            spoonacular.sharedInstance().autoCompleteIngredients(ingredient: self.ingredientsField.text ?? "") {(ingredients, error) in
                if error == nil{
                    self.ingredients = ingredients
                    DispatchQueue.main.async {
                        self.UpdateUI(arrName: "ingredients")
                        self.closeOtherTVs(UIControl: sender)
                    }
                }
            }
        case typeBtn:
            self.UpdateUI(arrName: "recipeTypes")
            closeOtherTVs(UIControl: sender)
        case cuisineBtn:
            self.UpdateUI(arrName: "Cuisines")
            closeOtherTVs(UIControl: sender)
        case dietBtn:
            self.UpdateUI(arrName: "Diets")
            closeOtherTVs(UIControl: sender)
        default:()
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        minField.text = "\(Int(sender.value))"
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if sender == minField{
            slider.value = Float(sender.text!) as! Float ?? 0
        }
    }
    
    private func configureTV(arrName:String){
        switch arrName {
        case "Recipes":
            recipesTV.delegate = self
            recipesTV.dataSource = self
            recipesHC.constant = 0
            recipeField.delegate = self
        case "Ingredients":
            ingredientsTV.delegate = self
            ingredientsTV.dataSource = self
            ingredientsHC.constant = 0
            ingredientsField.delegate = self
        case "recipeTypes":
            typeTV.delegate = self
            typeTV.dataSource = self
        case "Cuisines":
            cuisineTV.delegate = self
            cuisineTV.dataSource = self
        case "Diets":
            dietTV.delegate = self
            dietTV.dataSource = self
        default:()
        }
    }
    
    private func UpdateUI(arrName: String) {
        switch arrName {
        case "recipes":
            self.textFieldShouldReturn(self.recipeField)
            UIView.animate(withDuration: 0.5){
                if self.isRecipesTVVisiable{
                    self.recipesHC.constant = 0
                    self.isRecipesTVVisiable = false
                }else{
                    if self.recipes.count == 0 {
                        self.recipes.append("No recipes With this title")
                    }
                    self.recipesTV.reloadData()
                    self.isRecipesTVVisiable = true
                    self.recipesHC.constant = CGFloat(30 * (self.recipes.count <= 3 ? self.recipes.count : 3) )
                }
            }
        case "ingredients":
            self.textFieldShouldReturn(self.recipeField)
            UIView.animate(withDuration: 0.5){
                if self.isIngredTVVisiable{
                    self.ingredientsHC.constant = 0
                    self.isIngredTVVisiable = false
                }else{
                    if self.ingredients.count == 0 {
                        self.ingredients.append("No ingredients With this title")
                    }
                    self.ingredientsTV.reloadData()
                    self.ingredientsHC.constant = CGFloat(30 * (self.ingredients.count <= 3 ? self.ingredients.count : 3) )
                    self.isIngredTVVisiable = true
                }
            }
        case "recipeTypes":
            UIView.animate(withDuration: 0.5){
                if self.isTypeTVVisiable{
                    self.typeHC.constant = 0
                    self.isTypeTVVisiable = false
                }else{
                    if self.ingredients.count == 0 {
                        self.ingredients.append("No recipes With this title")
                    }
                    self.typeTV.reloadData()
                    self.typeHC.constant = 30 * 3
                    self.isTypeTVVisiable = true
                }
            }
        case "Cuisines":
            UIView.animate(withDuration: 0.5){
                if self.isCuisineTVVisiable{
                    self.cuisineHC.constant = 0
                    self.isCuisineTVVisiable = false
                }else{
                    self.cuisineTV.reloadData()
                    self.cuisineHC.constant = 30 * 3
                    self.isCuisineTVVisiable = true
                }
            }
        case "Diets":
            UIView.animate(withDuration: 0.5){
                if self.isDietTVVisiable{
                    self.dietHC.constant = 0
                    self.isDietTVVisiable = false
                }else{
                    self.dietTV.reloadData()
                    self.dietHC.constant = 30 * 3
                    self.isDietTVVisiable = true
                }
            }
        default:()
        }
    }
    
    private func closeOtherTVs(UIControl : UIControl){
        switch UIControl {
        case recipeField, recipesBtn:
            ingredientsHC.constant = 0
            isIngredTVVisiable = false
            typeHC.constant = 0
            isTypeTVVisiable = false
            cuisineHC.constant = 0
            isCuisineTVVisiable = false
            dietHC.constant = 0
            isDietTVVisiable = false
        case ingredientsField, ingredientsBtn:
            recipesHC.constant = 0
            isRecipesTVVisiable = false
            typeHC.constant = 0
            isTypeTVVisiable = false
            cuisineHC.constant = 0
            isCuisineTVVisiable = false
            dietHC.constant = 0
            isDietTVVisiable = false
        case typeBtn:
            recipesHC.constant = 0
            isRecipesTVVisiable = false
            ingredientsHC.constant = 0
            isIngredTVVisiable = false
            cuisineHC.constant = 0
            isCuisineTVVisiable = false
            dietHC.constant = 0
            isDietTVVisiable = false
        case cuisineBtn:
            recipesHC.constant = 0
            isRecipesTVVisiable = false
            ingredientsHC.constant = 0
            isIngredTVVisiable = false
            typeHC.constant = 0
            isTypeTVVisiable = false
            dietHC.constant = 0
            isDietTVVisiable = false
        case dietBtn:
            recipesHC.constant = 0
            isRecipesTVVisiable = false
            ingredientsHC.constant = 0
            isIngredTVVisiable = false
            typeHC.constant = 0
            isTypeTVVisiable = false
            cuisineHC.constant = 0
            isCuisineTVVisiable = false
        default:()
        }
    }
   
    private func generateColoredLabel(view : UIStackView, stackViewHC: NSLayoutConstraint, text : String){
        //Text Label
        let textLabel = UILabel()
        textLabel.backgroundColor =  .random()
        textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        textLabel.text  = text
        
        //Button View
        let deleteBtn   = UIButton(type: .custom) as UIButton
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "X-30X30") as UIImage?
        deleteBtn.setImage(image, for: .normal)
        deleteBtn.backgroundColor = textLabel.backgroundColor
        deleteBtn.addTarget(self, action: #selector(deletePressed), for:.touchUpInside)
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = UIStackView.Alignment.leading
        stackView.distribution  = UIStackView.Distribution.fill
        stackView.spacing   = 0
        
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(deleteBtn)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        if view.subviews.count > 0 {
            var horizontalStackView = view.subviews[view.subviews.count - 1] as! UIStackView
            if horizontalStackView.subviews.count > 0 && horizontalStackView.subviews.count < 3{
                horizontalStackView.addArrangedSubview(stackView)
                horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            }else{
                let horizontalStackView   = UIStackView()
                horizontalStackView.axis  = NSLayoutConstraint.Axis.horizontal
                horizontalStackView.distribution  = UIStackView.Distribution.equalSpacing
                horizontalStackView.spacing  = 0
                horizontalStackView.addArrangedSubview(stackView)
                horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
                view.addArrangedSubview(horizontalStackView)
            }
        }else{
            let horizontalStackView   = UIStackView()
            horizontalStackView.axis  = NSLayoutConstraint.Axis.horizontal
            horizontalStackView.distribution  = UIStackView.Distribution.equalSpacing
            horizontalStackView.spacing  = 0
            horizontalStackView.addArrangedSubview(stackView)
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            view.addArrangedSubview(horizontalStackView)
        }
        
        stackViewHC.constant = CGFloat(view.subviews.count * 20)
    }
    
    private func random() -> UIColor {
        return UIColor(red:  CGFloat(arc4random()), green: CGFloat(arc4random()), blue:  CGFloat(arc4random()), alpha: 1.0)
    }
    
    @objc func deletePressed(_ sender: UIButton){
        let parentView = sender.superview!
        let horizontalSV = parentView.superview as! UIStackView
        parentView.removeFromSuperview()
        ArrangeStackViews(horizontalSV: horizontalSV )
        
    }
    
    // Shifts StackViews To be arranged by first added When labels deleted
    private func ArrangeStackViews(horizontalSV : UIStackView){
        let verticalSV = horizontalSV.superview as! UIStackView
        
        if horizontalSV.subviews.count ?? 0 == 0{
            horizontalSV.removeFromSuperview()
            if verticalSV.axis == NSLayoutConstraint.Axis.vertical{
                verticalSV.heightAnchor.constraint(equalToConstant: CGFloat(verticalSV.subviews.count * 30))
            }
        }else if horizontalSV.subviews.count ?? 0 > 0 && verticalSV.subviews.count > 1 {
            var index = verticalSV.arrangedSubviews.firstIndex(of: horizontalSV)! + 1
            if index < verticalSV.subviews.count && verticalSV.arrangedSubviews[index].subviews.count > 0 {
                let firstSubView = verticalSV.arrangedSubviews[index].subviews[0] as! UIStackView
                firstSubView.removeFromSuperview()
                horizontalSV.addArrangedSubview(firstSubView)
                ArrangeStackViews(horizontalSV: verticalSV.arrangedSubviews[index] as! UIStackView)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch tableView {
        case recipesTV:
            return recipes.count
        case ingredientsTV:
            return ingredients.count
        case typeTV:
            return recipeTypes.count
        case cuisineTV:
            return cuisines.count
        case dietTV:
            return diets.count
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
        }else if tableView == typeTV{
            cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell")!
            let type = self.recipeTypes[(indexPath as NSIndexPath).row]
            // Set the name
            cell.textLabel!.text = type
        }else if tableView == cuisineTV{
            cell = tableView.dequeueReusableCell(withIdentifier: "CuisineCell")!
            let cuisine = self.cuisines[(indexPath as NSIndexPath).row]
            // Set the name
            cell.textLabel!.text = cuisine
        }else if tableView == dietTV{
            cell = tableView.dequeueReusableCell(withIdentifier: "DietCell")!
            let diet = self.diets[(indexPath as NSIndexPath).row]
            // Set the name
            cell.textLabel!.text = diet
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIView.animate(withDuration: 0.5){
            switch tableView{
            case self.recipesTV:
                self.recipesHC.constant = 0
                self.isRecipesTVVisiable = false
                let recipe = self.recipes[(indexPath as NSIndexPath).row]
                self.generateColoredLabel(view: self.recipesStackView, stackViewHC: self.recipesStackViewHC, text: recipe)
            case self.ingredientsTV:
                self.ingredientsHC.constant = 0
                self.isIngredTVVisiable = false
                let ingredient = self.ingredients[(indexPath as NSIndexPath).row]
                self.generateColoredLabel(view: self.ingredientsStackView, stackViewHC: self.ingredientsStackViewHC, text: ingredient)
            case self.typeTV:
                self.typeHC.constant = 0
                self.isTypeTVVisiable = false
                let type = self.recipeTypes[(indexPath as NSIndexPath).row]
                self.generateColoredLabel(view: self.typesStackView, stackViewHC: self.typeStackViewHC, text: type)
            case self.cuisineTV:
                self.cuisineHC.constant = 0
                self.isCuisineTVVisiable = false
                let cuisine = self.cuisines[(indexPath as NSIndexPath).row]
                self.generateColoredLabel(view: self.cuisinesStackView, stackViewHC: self.cuisinesStackViewHC, text: cuisine)
            case self.dietTV:
                self.dietHC.constant = 0
                self.isDietTVVisiable = false
                let diet = self.diets[(indexPath as NSIndexPath).row]
                self.generateColoredLabel(view: self.dietsStackView, stackViewHC: self.dietsStackViewHC, text: diet)
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
        self.closeOtherTVs(UIControl: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

extension UIColor {
    static func random () -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0)
    }
}
