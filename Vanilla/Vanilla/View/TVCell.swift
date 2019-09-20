//
//  CuisineCell.swift
//  Vanilla
//
//  Created by Hend  on 9/18/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import UIKit
protocol TVCellActionDelegate {
    func CellChecked(indexPath: IndexPath, tableView : UITableView)
}

class TVCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var CheckBtn: UIButton!

    var delegate : TVCellActionDelegate?
    var tableView : UITableView?
    var indexPath : IndexPath?
    
    @IBAction func CellChecked(_ sender: Any) {
        delegate?.CellChecked(indexPath: indexPath!, tableView : tableView!)
    }
}
