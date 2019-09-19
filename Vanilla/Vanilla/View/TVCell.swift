//
//  CuisineCell.swift
//  Vanilla
//
//  Created by Hend  on 9/18/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
class CuisineCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var CheckBtn: UIButton!

    var indexPath : IndexPath?
    
    @IBAction func CellChecked(_ sender: Any) {
        if CheckBtn.currentImage == #imageLiteral(resourceName: "emptyHeart-30x30"){
            CheckBtn.setImage(#imageLiteral(resourceName: "redHeart-30x30"), for: .normal)
        }else{
            CheckBtn.setImage(#imageLiteral(resourceName: "emptyHeart-30x30"), for: .normal)
        }
    }
}
