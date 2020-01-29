//
//  RegularNotificationCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/18.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class RegularNotificationCell: UITableViewCell {

    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var reuseIdentifier: String {
        return "RegularNotificationCell"
    }
    
    class var nibName: String {
        return "RegularNotificationCell"
    }
    
    func configureCell(notification: String, time : String) {
        self.notification?.text = notification
        self.time?.text = time
    }
}
