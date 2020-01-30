//
//  NormalNotificationCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/31.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class NormalNotificationCell: UITableViewCell {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var shift: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var submitTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var reuseIdentifier: String {
        return "NormalNotificationCell"
    }
    
    class var nibName: String {
        return "NormalNotificationCell"
    }
    
    func configureCell(status: String, title: String, shift: String, time: String, submitTime: String) {
        self.status?.text = status
        self.title?.text = title
        self.shift?.text = shift
        self.time?.text = time
        self.submitTime?.text = submitTime
    }
    
}
