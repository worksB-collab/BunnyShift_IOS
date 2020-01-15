//
//  StaffCollectionViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/8.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

@IBDesignable class StaffCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class var reuseIdentifier: String {
        return "StaffCollectionViewCell"
    }
    class var nibName: String {
        return "StaffCollectionViewCell"
    }
    
    func configureCell(name: String) {
        self.name?.text = name
        
    }
    
    
}


