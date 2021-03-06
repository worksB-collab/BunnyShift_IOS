//
//  AcceptableNotificationCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/18.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class AcceptableNotificationCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var shift: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var submitTime: UILabel!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var reject: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var reuseIdentifier: String {
        return "AcceptableNotificationCell"
    }
    
    class var nibName: String {
        return "AcceptableNotificationCell"
    }
    
    func configureCell(title: String, shift: String, time: String, submitTime: String) {
        self.title?.text = title
        self.shift?.text = shift
        self.time?.text = time
        self.submitTime?.text = submitTime
    }
}
