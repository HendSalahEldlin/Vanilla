//
//  CollectionVC.swift
//  Vanilla
//
//  Created by Hend  on 9/8/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import Foundation
import UIKit


class collectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arr : [String]!
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        arr = ["asdfasdfasdfaasdfasdfasdfsdfasd", "asdfasd","asdfasd", "asasdfasd", "sdfdf", "asasd", "asdfasdfasdfasdfasdf"]
    }
}


extension collectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = arr[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let s = ( arr[indexPath.row] as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFontSize])
        
        return s

    }
    
}

class Cell : UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
}
