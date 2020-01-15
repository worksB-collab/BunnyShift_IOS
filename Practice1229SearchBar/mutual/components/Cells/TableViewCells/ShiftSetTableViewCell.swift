//
//  ShiftSetTableViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/10.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class ShiftSetTableViewCell: UITableViewCell {

    @IBOutlet weak var dateName: UILabel!
    @IBOutlet weak var otherInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class var reuseIdentifier: String {
            return "ShiftSetTableViewCell"
        }
        class var nibName: String {
            return "ShiftSetTableViewCell"
        }
        
        func configureCell(name: String) {
            self.dateName.text = name
            self.otherInfo.text = name
            
        }
}
