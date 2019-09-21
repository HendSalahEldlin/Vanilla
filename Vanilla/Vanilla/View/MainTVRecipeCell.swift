//
//  MainTVRecipeCell.swift
//  Vanilla
//
//  Created by Hend  on 9/20/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
class MainTVRecipeCell: UITableViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    var delegate: CellActionDelegate?
    var indexPath: IndexPath!
    
    @IBAction func favBtnPressed(_ sender: UIButton) {
        delegate?.addToFav(indexPath: self.indexPath)
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        delegate?.shareARecipe(indexPath: self.indexPath)
    }
}
