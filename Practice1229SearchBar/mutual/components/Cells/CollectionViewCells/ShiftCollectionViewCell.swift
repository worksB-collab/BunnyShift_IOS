//
//  ShiftCollectionViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/13.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class ShiftCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class var reuseIdentifier: String {
        return "ShiftCollectionViewCell"
    }
    class var nibName: String {
        return "ShiftCollectionViewCell"
    }
    
    func configureCell(name: String) {
        self.name?.text = name
        
    }

}
