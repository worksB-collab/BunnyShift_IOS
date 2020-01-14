//
//  Toast.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/13.
//  Copyright © 2020 cm0521. All rights reserved.
//

import Foundation
import Toast_Swift

public class Toast{
    
    public static func showToast(_ view : UIView, _ name : String){
        // create a new style
        var style = ToastStyle()
        
        // this is just one of many style options
        style.messageColor = .white
        style.backgroundColor = UIColor(named: "Color3")!
        
        // present the toast with the new style
        view.makeToast(name, duration: 1.0, position: .bottom, style: style)
        
    }
}
