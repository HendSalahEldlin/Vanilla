//
//  TVRecipeCell.swift
//  Vanilla
//
//  Created by Hend  on 8/27/19.
//  Copyright © 2019 Hend . All rights reserved.
//

import Foundation
import UIKit


protocol CellActionDelegate {
    func shareARecipe(indexPath: IndexPath)
    func addToFav(indexPath: IndexPath)
}

class TVRecipeCell: UITableViewCell {
    
    var delegate: CellActionDelegate?
    var indexPath: IndexPath!
    
    var mainImageView : UIImageView  = {
    var imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    imageView.contentMode = UIView.ContentMode.scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.clipsToBounds = true
    return imageView
    }()
    
    var titleLabel : UILabel = {
        var label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 20),]
        label.attributedText = NSAttributedString(string: "", attributes: attributes)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    var minutesLabel : UILabel = {
        var label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        return label
    }()
    
    var shareBtn : UIButton = {
        let button   = UIButton(type: .custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "share_30x30") as UIImage?
        button.setImage(image, for: .normal)
        return button
    }()
    
    var favBtn : UIButton = {
        let button  = UIButton(type: .custom) as UIButton
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "emptyHeart-30x30") as UIImage?
        button.setImage(image, for: .normal)
        return button
    }()
    
    var view : UIView = {
       var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.4976205584, green: 0.4678901179, blue: 0.2717226436, alpha: 0.5754227312)
        return view
    }()
     
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(mainImageView)
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        
        
        mainImageView.addSubview(view)
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        
        /*mainImageView.addSubview(minutesLabel)
        minutesLabel.leftAnchor.constraint(equalTo: self.mainImageView.leftAnchor, constant: 30).isActive = true
        minutesLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20).isActive = true*/
        
        self.addSubview(shareBtn)
        shareBtn.rightAnchor.constraint(equalTo: self.mainImageView.rightAnchor, constant: -15).isActive = true
        shareBtn.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: -10).isActive = true
        shareBtn.addTarget(self, action: #selector(share), for:.touchUpInside)
        
        self.addSubview(favBtn)
        favBtn.rightAnchor.constraint(equalTo: self.shareBtn.leftAnchor, constant: -15).isActive = true
        favBtn.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: -10).isActive = true
        favBtn.addTarget(self, action: #selector(favourite), for:.touchUpInside)
        
        
     }
     required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }
    
    @objc func share(sender: UIButton!){
        delegate?.shareARecipe(indexPath: self.indexPath)
    }
    
    @objc func favourite(){
        delegate?.addToFav(indexPath: self.indexPath)
    } 
}
