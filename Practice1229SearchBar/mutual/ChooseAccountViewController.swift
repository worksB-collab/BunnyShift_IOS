//
//  ChooseAccountViewController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2019/12/30.
//  Copyright © 2019 cm0521. All rights reserved.
//

import UIKit

class ChooseAccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(named: "Color1")! ]
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var chooseAccount_individual: RoundRecButton!
    
    @IBOutlet weak var chooseAccount_company: RoundRecButton!
    
        
    
    func setNavigationBar(){
        navigationItem.title = "註冊" // 設定title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftItemsSupplementBackButton = true
        
    }
    
    //show up navigation bar again when back to this page
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
}




