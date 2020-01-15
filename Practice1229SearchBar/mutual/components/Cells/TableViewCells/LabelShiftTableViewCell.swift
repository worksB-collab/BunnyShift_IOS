//
//  LabelShiftTableViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/7.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

@IBDesignable class LabelShiftTableViewCell: UITableViewCell {
    
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var start_label: UILabel!
    @IBOutlet weak var end_label: UILabel!
    @IBOutlet weak var staffNum_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var reuseIdentifier: String {
            return "LabelShiftTableViewCell"
        }
        class var nibName: String {
            return "LabelShiftTableViewCell"
        }
        
        func configureCell(name: String) {
    //        self.nameLabel.text = name
            
        }
    
}
