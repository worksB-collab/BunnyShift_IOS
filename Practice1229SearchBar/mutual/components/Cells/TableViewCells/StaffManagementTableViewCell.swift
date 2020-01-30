//
//  StaffManagementTableViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/14.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class StaffManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UIButton!
    @IBOutlet weak var currentWorkingHours: UIButton!
    @IBOutlet weak var assignedWorkingHours: UIButton!
    @IBOutlet weak var salaryHourly: UIButton!
    @IBAction func salaryHourly(_ sender: UIButton) {
        
    }
    @IBOutlet weak var salaryMonthly: UIButton!
    @IBOutlet weak var btn_fire: UIButton!
    
    @IBOutlet weak var number: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var reuseIdentifier: String {
        return "StaffManagementTableViewCell"
    }
    class var nibName: String {
        return "StaffManagementTableViewCell"
    }
    
    func configureCell(name: String, currentWorkingHours : Int, assignedWorkingHours : Int, salaryHourly : Int, salaryMonthly : Int, number : String) {
        
        self.name.setTitle(name, for: .normal)
        self.currentWorkingHours.setTitle("\(assignedWorkingHours)", for: .normal)
        self.assignedWorkingHours.setTitle("\(assignedWorkingHours)", for: .normal)
        self.salaryHourly.setTitle("\(salaryHourly)/hr", for: .normal)
        self.salaryMonthly.setTitle("\(salaryMonthly)", for: .normal)
        self.number.text = number
        
        
    }
    
}
