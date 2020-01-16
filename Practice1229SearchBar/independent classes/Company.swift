//
//  Company.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/7.
//  Copyright © 2020 cm0521. All rights reserved.
//

import Foundation
public class Company{
    var name: String
    var account: String?
    var password: String?
    var number: String
    var address :String
    var taxID :String
    var ltdID : String
    var staffList : [Staff]?
    
    
    init(_ name : String, _ number: String, _ address :String, _ taxID :String, _ ltdID : String){
        self.name = name
        self.number = number
        self.address = address
        self.taxID = taxID
        self.ltdID = ltdID
    }

}
