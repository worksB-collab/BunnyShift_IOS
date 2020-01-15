//
//  CompanyScheduleCollectionViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/3.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

@IBDesignable class CompanyScheduleCollectionViewCell: UICollectionViewCell {
    
    var clicked = false
//    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var btnTest: UIButton!
    @IBAction func btnTestAction(_ sender: UIButton) {
        if clicked{
            clicked = false
        }else{
            clicked = true
        }
        setButtonColor()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class var reuseIdentifier: String {
        return "CSCollectionCell"
    }
    class var nibName: String {
        return "CompanyScheduleCollectionViewCell"
    }
    
    func configureCell(name: String) {
//        self.nameLabel.text = name
        self.btnTest?.setTitle( name ,for: .normal)
        
    }
    
    func setButtonColor(){
        if clicked{
            btnTest.setTitleColor(.white, for: .normal)
        }else{
           btnTest.setTitleColor(UIColor(named: "Color7")!, for: .normal)
        }
    }
    
}
