//
//  WeekdayCollectionViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/5.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

@IBDesignable class WeekdayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        class var reuseIdentifier: String {
            return "WeekdayCollectionViewCell"
        }
        class var nibName: String {
            return "WeekdayCollectionViewCell"
        }
        
        func configureCell(name: String) {
            self.nameLabel.text = name
            
        }
}
