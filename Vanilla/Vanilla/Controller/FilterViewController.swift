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
    
    @IBOutlet weak var ingredientsTV: UITableView!
    @IBOutlet weak var ingredientsField: UITextField!
    @IBOutlet weak var ingredientsHC: NSLayoutConstraint!
    @IBOutlet weak var ingredientsBtn: UIButton!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    @IBOutlet weak var ingredientsStackViewHC: NSLayoutConstraint!
    @IBOutlet weak var ingredientSubStackView: UIStackView!
    
    @IBOutlet weak var typeTV: UITableView!
    @IBOutlet weak var typeHC: NSLayoutConstraint!
    @IBOutlet weak var typeBtn: UIButton!
    
    @IBOutlet weak var cuisineTV: UITableView!
    @IBOutlet weak var cuisineHC: NSLayoutConstraint!
    @IBOutlet weak var cuisineBtn: UIButton!
    
    @IBOutlet weak var dietTV: UITableView!
    @IBOutlet weak var dietHC: NSLayoutConstraint!
    @IBOutlet weak var dietBtn: UIButton!
    
    @IBOutlet weak var minField: UITextField!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var mainSearchBtn: UIButton!
    
    var ingredients = [String]()
    var ingredientsQuery = [String]()
    var ingredientsDic = [String:Bool]()
    var isIngredTVVisiable = false
    
    var recipes = [String]()
    var isRecipesTVVisiable = false
    
    let recipeTypes = [ "mainCourse", "sideDish", "dessert", "appetizer", "salad", "bread", "breakfast", "soup", "beverage", "sauce", "marinade", "fingerfood", "snack", "drink"]
    var isTypeTVVisiable = false
    
    let cuisines = ["African", "American", "British", "Cajun", "Caribbean", "Chinese", "EasternEuropean", "European", "French", "German", "Greek", "Indian", "Irish", "Italian", "Japanese", "Jewish", "Korean", "LatinAmerican", "Mediterranean", "Mexican", "MiddleEastern", "Nordic", "Southern", "Spanish", "Thai", "Vietnamese"]
    var cuisinesQuery = [String]()
    var cuisinesDic = [String:Bool]()
    var isCuisineTVVisiable = false
    
    let diets = ["GlutenFree", "Ketogenic", "Vegetarian", "Lacto_Vegetarian", "Ovo_Vegetarian", "Vegan", "Pescetarian", "Paleo", "Primal", "Whole30"]
    var isDietTVVisiable = false
    
    let colors : [UIColor] = [#colorLiteral(red: 0.2674680898, green: 0.9852552817, blue: 0.9153829225, alpha: 1), #colorLiteral(red: 1, green: 0.7254621479, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.506867155, blue: 0.4642497881, alpha: 1), #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cuisineTV.register(UINib(nibName: "TVCell", bundle: nil), forCellReuseIdentifier: "TVCell")
        ingredientsTV.register(UINib(nibName: "TVCell", bundle: nil), forCellReuseIdentifier: "TVCell")
        configureTV(arrName: "Recipes")
        configureTV(arrName: "Ingredients")
        configureTV(arrName: "recipeTypes")
        configureTV(arrName: "Cuisines")
        configureTV(arrName: "Diets")
        minField.delegate = self
        slider.value = 300
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
                    for item in ingredients{
                        self.ingredientsDic[item] = false
                        for i in self.ingredientsQuery{
                            if i == item{
                                self.ingredientsDic[item] = true
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.UpdateUI(arrName: "ingredients")
                        self.closeOtherTVs(UIControl: sender)
                        self.AddDoneBtn()
                    }
                }
            }
        case typeBtn:
            self.UpdateUI(arrName: "recipeTypes")
            closeOtherTVs(UIControl: sender)
        case cuisineBtn:
            for item in cuisines{
                cuisinesDic[item] = false
                for i in self.cuisinesQuery{
                    if i == item{
                        self.cuisinesDic[item] = true
                    }
                }
            }
            self.UpdateUI(arrName: "Cuisines")
            closeOtherTVs(UIControl: sender)
        case dietBtn:
            self.UpdateUI(arrName: "Diets")
            closeOtherTVs(UIControl: sender)
        case mainSearchBtn:
            let type = (typeBtn.titleLabel?.text != "Select a Recipe Type" ? typeBtn.titleLabel?.text : "")!
            let cuisine = (cuisineBtn.titleLabel?.text != "Select a Cuisine" ? cuisineBtn.titleLabel?.text : "")!
            let diet = (dietBtn.titleLabel?.text != "Select a Diet" ? dietBtn.titleLabel?.text : "")!
            let maxMin = Int(minField.text! == "" ? "300" : minField.text!) as! Int ?? 300
            
            spoonacular.sharedInstance().recipesComplexSearch(recipes: recipeField.text!, ingredients: ingredientsQuery.joined(separator: ","), type: type, cuisine: cuisine, diet: diet, maxReadyTime: maxMin){(success, error) in
                if success{
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        default:()
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        closeOtherTVs(UIControl: sender)
        minField.text = "\(Int(sender.value))"
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if sender == minField{
            closeOtherTVs(UIControl: sender)
            slider.value = Float(sender.text!) as! Float ?? 0
        }
    }
    
    @objc func deletePressed(_ sender: UIButton){
        let parentView = sender.superview!
        let label = parentView.subviews[0] as! UILabel
        ingredientsQuery.remove(at: ingredients.firstIndex(of: label.text!)!)
        let horizontalSV = parentView.superview as! UIStackView
        parentView.removeFromSuperview()
        ArrangeStackViews(horizontalSV: horizontalSV)
        self.view.layoutIfNeeded()
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
                    self.recipesHC.constant = self.recipesTV.rowHeight * CGFloat((self.recipes.count <= 3 ? self.recipes.count : 3) )
                    self.isRecipesTVVisiable = true
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
                    self.ingredientsHC.constant = self.ingredientsTV.rowHeight  * CGFloat((self.ingredients.count <= 3 ? self.ingredients.count : 3))
                    self.isIngredTVVisiable = true
                }
            }
        case "recipeTypes":
            UIView.animate(withDuration: 0.5){
                if self.isTypeTVVisiable{
                    self.typeHC.constant = 0
                    self.isTypeTVVisiable = false
                }else{
                    self.typeTV.reloadData()
                    self.typeHC.constant = self.typeTV.rowHeight  * 3
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
                    self.cuisineHC.constant = self.cuisineTV.rowHeight * 3
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
                    self.dietHC.constant = self.dietTV.rowHeight * 3
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
            removeDoneBtn()
            doneBtnPressed()
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
            removeDoneBtn()
            doneBtnPressed()
            cuisineHC.constant = 0
            isCuisineTVVisiable = false
            dietHC.constant = 0
            isDietTVVisiable = false
        case cuisineBtn:
            recipesHC.constant = 0
            isRecipesTVVisiable = false
            ingredientsHC.constant = 0
            isIngredTVVisiable = false
            removeDoneBtn()
            doneBtnPressed()
            typeHC.constant = 0
            isTypeTVVisiable = false
            dietHC.constant = 0
            isDietTVVisiable = false
        case dietBtn:
            recipesHC.constant = 0
            isRecipesTVVisiable = false
            ingredientsHC.constant = 0
            isIngredTVVisiable = false
            removeDoneBtn()
            doneBtnPressed()
            typeHC.constant = 0
            isTypeTVVisiable = false
            cuisineHC.constant = 0
            isCuisineTVVisiable = false
        case minField, slider:
            recipesHC.constant = 0
            isRecipesTVVisiable = false
            ingredientsHC.constant = 0
            isIngredTVVisiable = false
            removeDoneBtn()
            doneBtnPressed()
            typeHC.constant = 0
            isTypeTVVisiable = false
            cuisineHC.constant = 0
            isCuisineTVVisiable = false
            dietHC.constant = 0
            isDietTVVisiable = false
        default:()
        }
    }
    
    fileprivate func addHorizontalSubView(_ stackView: UIStackView, _ view: UIStackView) {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis  = NSLayoutConstraint.Axis.horizontal
        horizontalStackView.distribution  = UIStackView.Distribution.equalSpacing
        horizontalStackView.spacing  = 8
        horizontalStackView.addArrangedSubview(stackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(horizontalStackView)
    }
    
    private func generateColoredLabel(view : UIStackView, stackViewHC: NSLayoutConstraint, text : String){
        //Text Label
        let textLabel = UILabel()
        textLabel.backgroundColor =  #colorLiteral(red: 0.5960784314, green: 0.7520280394, blue: 0.9921568627, alpha: 0.8766588185)
        textLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        textLabel.text  = text
        
        //Button View
        let deleteBtn   = UIButton(type: .roundedRect) as UIButton
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        deleteBtn.setImage(#imageLiteral(resourceName: "icons8-delete-30 (3)"), for: .normal)
        deleteBtn.backgroundColor = textLabel.backgroundColor
        deleteBtn.addTarget(self, action: #selector(deletePressed), for:.touchUpInside)
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution  = UIStackView.Distribution.fill
        stackView.spacing   = 0
        
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(deleteBtn)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        /* if vertical stack view is empty then add the new horizontal stack view
            else add the new subView to the last horizontal stack view*/
        if view.subviews.count > 0 {
            var horizontalStackView = view.subviews[view.subviews.count - 1] as! UIStackView
            /*let horizontalStackViewWidth = Double(horizontalStackView.frame.size.width)
            var subviewsWidth = 0.0
            for subview in horizontalStackView.arrangedSubviews{
                subviewsWidth = Double(+subview.frame.size.width)
            }
             if horizontalStackViewWidth - subviewsWidth >= Double(stackView.frame.width){
             */
            
            /* if current horizontalStackView.subviews  between 0:2 then add the new subview to it else create new horizontalStackView and add the subview to it */
            if horizontalStackView.subviews.count > 0 && horizontalStackView.subviews.count < 3{
             horizontalStackView.addArrangedSubview(stackView)
                horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            }else{
                addHorizontalSubView(stackView, view)
            }
        }else{
            addHorizontalSubView(stackView, view)
        }
        stackViewHC.constant = CGFloat(view.subviews.count * 20)
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
    
    private func AddDoneBtn(){
        if ingredientSubStackView.subviews.count == 2{
            let doneBtn  = UIButton(type: .custom) as UIButton
            doneBtn.translatesAutoresizingMaskIntoConstraints = false
            doneBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            doneBtn.setImage(#imageLiteral(resourceName: "icons8-checked-30"), for: .normal)
            doneBtn.addTarget(self, action: #selector(doneBtnPressed), for:.touchUpInside)
            ingredientSubStackView.addArrangedSubview(doneBtn)
        }
    }
    
    private func removeDoneBtn(){
        if ingredientSubStackView.subviews.count == 3{
            (ingredientSubStackView.subviews[2]).removeFromSuperview()
        }
    }
    
    @objc func doneBtnPressed(){
        self.ingredientsHC.constant = 0
        self.isIngredTVVisiable = false
        for view in ingredientsStackView.subviews{
            view.removeFromSuperview()
        }
        for item in ingredientsQuery{
            self.generateColoredLabel(view: self.ingredientsStackView, stackViewHC: self.ingredientsStackViewHC, text: item)
        }
        removeDoneBtn()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath) as! TVCell
            let ingredient = self.ingredients[(indexPath as NSIndexPath).row]
            // Set the name
            cell.delegate = self
            cell.label.text = ingredient
            cell.indexPath = indexPath
            cell.tableView = tableView
            if self.ingredientsDic[ingredient] == false{
                cell.CheckBtn.setImage(#imageLiteral(resourceName: "icons8-unchecked-checkbox-30"), for: .normal)
            }else{
                cell.CheckBtn.setImage(#imageLiteral(resourceName: "icons8-checked-checkbox-30"), for: .normal)
            }
            return cell
        }else if tableView == typeTV{
            cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell")!
            let type = self.recipeTypes[(indexPath as NSIndexPath).row]
            // Set the name
            cell.textLabel!.text = type
        }else if tableView == cuisineTV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath) as! TVCell
            let cuisine = self.cuisines[(indexPath as NSIndexPath).row]
            // Set the name
            cell.delegate = self
            cell.label!.text = cuisine
            cell.indexPath = indexPath
            cell.tableView = tableView
            if self.cuisinesDic[cuisine] == false{
                cell.CheckBtn.setImage(#imageLiteral(resourceName: "icons8-unchecked-checkbox-30"), for: .normal)
            }else{
                cell.CheckBtn.setImage(#imageLiteral(resourceName: "icons8-checked-checkbox-30"), for: .normal)
            }
            return cell
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
                self.recipeField.text = recipe
            case self.typeTV:
                self.typeHC.constant = 0
                self.isTypeTVVisiable = false
                let type = self.recipeTypes[(indexPath as NSIndexPath).row]
                self.typeBtn.titleLabel?.text = type
            /*case self.cuisineTV:
                self.cuisineHC.constant = 0
                self.isCuisineTVVisiable = false
                let cuisine = self.cuisines[(indexPath as NSIndexPath).row]
                self.generateColoredLabel(view: self.cuisinesStackView, stackViewHC: self.cuisinesStackViewHC, text: cuisine)*/
            case self.dietTV:
                self.dietHC.constant = 0
                self.isDietTVVisiable = false
                let diet = self.diets[(indexPath as NSIndexPath).row]
                self.dietBtn.titleLabel?.text = diet
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

extension FilterViewController:TVCellActionDelegate{
    func CellChecked(indexPath: IndexPath, tableView: UITableView) {
        let cell = tableView.cellForRow(at: indexPath) as! TVCell
        if cell.CheckBtn.currentImage == #imageLiteral(resourceName: "icons8-unchecked-checkbox-30"){
            cell.CheckBtn.setImage(#imageLiteral(resourceName: "icons8-checked-checkbox-30"), for: .normal)
            if tableView == ingredientsTV{
                ingredientsDic[cell.label.text!] = true
                ingredientsQuery.append(cell.label.text!)
            }else{
                cuisinesDic[cell.label.text!] = true
                cuisinesQuery.append(cell.label.text!)
                self.cuisineBtn.titleLabel?.text = cuisinesQuery.joined(separator: ",")
                print(cuisinesQuery)
            }
        }else{
            cell.CheckBtn.setImage(#imageLiteral(resourceName: "icons8-unchecked-checkbox-30"), for: .normal)
            if tableView == ingredientsTV{
                ingredientsDic[cell.label.text!] = false
                ingredientsQuery.remove(at: ingredientsQuery.firstIndex(of: cell.label.text!)!)
            }else{
                cuisinesDic[cell.label.text!] = false
                cuisinesQuery.remove(at: cuisinesQuery.firstIndex(of: cell.label.text!)!)
                self.cuisineBtn.titleLabel?.text = cuisinesQuery.joined(separator: ",")
                print(cuisinesQuery)
            }
        }
    }
}
