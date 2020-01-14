//
//  testController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2019/12/29.
//  Copyright © 2019 cm0521. All rights reserved.
//

import UIKit

class testController: UIViewController {

    
    @IBOutlet weak var testSB: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //
        testSB.becomeFirstResponder()
        //

        // Do any additional setup after loading the view.
    }
    
    func setSBCancel(){
        testSB.showsCancelButton = true
    }
    

}
