//
//  DateNamingTableViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/10.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

@IBDesignable class DateNamingTableViewCell: UITableViewCell {

    @IBOutlet weak var dateName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var reuseIdentifier: String {
            return "DateNamingTableViewCell"
        }
        class var nibName: String {
            return "DateNamingTableViewCell"
        }
        
        func configureCell(name: String) {
    //        self.nameLabel.text = name
            self.dateName.text = name
    
}


}
