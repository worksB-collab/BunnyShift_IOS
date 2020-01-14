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
    
    
//    // jump to the page we want by its storyBoard ID
//    @IBAction func chooseAccount_company(_ sender: UIButton) {
//        if let controller = storyboard?.instantiateViewController(withIdentifier: "CompanyCreationViewController") {
//            present(controller, animated: true, completion: nil)
//        }
//    }
    
    
//    // back to topic page
//    @IBAction func chooseAccount_backToTopic(_ sender: UIButton) {
//        // jump to the page we want by its storyBoard ID
//        if let controller = storyboard?.instantiateViewController(withIdentifier: "RootNavigationController") {
//            present(controller, animated: true, completion: nil)
//        }
//
//    }
    
    
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




