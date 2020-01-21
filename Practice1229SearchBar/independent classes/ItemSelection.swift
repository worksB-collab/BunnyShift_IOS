//
//  ItemSelection.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/9.
//  Copyright © 2020 cm0521. All rights reserved.
//

import Foundation

public class ItemSelection{
    
    var list : [String] = []
    var selected  : [Bool] = []
    
    init(){
        
    }
    
    init(_ list : [String]){
        self.list  = list
        selected = [Bool](repeating: false, count: list.count)
    }
    
    func getSelected() -> Int{
        for i in 0 ..< selected.count{
            if selected[i]{
                return i
            }
        }
       return -1
    }
}
