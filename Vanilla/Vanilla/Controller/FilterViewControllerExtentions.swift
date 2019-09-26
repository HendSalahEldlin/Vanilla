//
//  FilterViewControllerExtentions.swift
//  Vanilla
//
//  Created by Hend  on 9/26/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit

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

extension FilterViewController : TVCellActionDelegate{
    func CellChecked(indexPath: IndexPath, tableView: UITableView) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TVCell
        if tableView == ingredientsTV{
             let obj = UpdateTVCellState(tableView: tableView, dic: ingredientsDic, query: ingredientsQuery, cell: cell)
            ingredientsDic = obj.0
            ingredientsQuery = obj.1
        }else{
            let obj = UpdateTVCellState(tableView: tableView, dic: cuisinesDic, query: cuisinesQuery, cell: cell)
            cuisinesDic = obj.0
            cuisinesQuery = obj.1
        }
    }
    
    func UpdateTVCellState(tableView : UITableView, dic : [String:Bool], query : [String], cell : TVCell) -> ([String:Bool], [String]){
        var myDic = dic
        var myQuery = query
        if cell.CheckBtn.currentImage == #imageLiteral(resourceName: "icons8-unchecked-checkbox-30"){
            cell.CheckBtn.setImage(#imageLiteral(resourceName: "icons8-checked-checkbox-30"), for: .normal)
            myDic[cell.label.text!] = true
            myQuery.append(cell.label.text!)
        }else{
            cell.CheckBtn.setImage(#imageLiteral(resourceName: "icons8-unchecked-checkbox-30"), for: .normal)
            myDic[cell.label.text!] = false
            myQuery.remove(at: myQuery.firstIndex(of: cell.label.text!)!)
        }
        return (myDic, myQuery)
    }
    
    
}
