//
//  RoundRecButton.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/13.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class RoundRecButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = bounds.height / 5
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor(named : "Color7"), for: .normal)
        backgroundColor = UIColor(named : "Color1")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

import UIKit

class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
    }
    
    
}
