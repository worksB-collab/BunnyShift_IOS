//
//  ViewController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2019/12/29.
//  Copyright © 2019 cm0521. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var searchController : UISearchController!
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    
    var originalDataSource:[String] = []
    var currentDataScource:[String] = []
    var didTapDeleteKey = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProductToDataScource(productCount: 14, product:"member")
        addProductToDataScource(productCount: 11, product:"VIP")
        
        tableView.delegate = self
        tableView.dataSource = self
        currentDataScource = originalDataSource
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
        setNavigationBar()
        
        // tap anywhere to dismiss keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    
    func setNavigationBar(){
        navigationItem.title = "search something"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func addProductToDataScource(productCount : Int ,  product: String){
        
        for index in 1...productCount{
            originalDataSource.append("\(product)#\(index)")
        }
    }
    
    func filterCurrentDataSource(searchTerm : String){
        if searchTerm.count > 0 {
            currentDataScource = originalDataSource
            let filteredResults = currentDataScource.filter{$0.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with:"").lowercased())}
            currentDataScource = filteredResults
            tableView.reloadData()
        }
    }
    
    func restoreCurrentDataSource(){
        currentDataScource = originalDataSource
        tableView.reloadData()
    }
    
    @IBAction func restoreData(_ sender: Any) {
        restoreCurrentDataSource()
        searchController.searchBar.text = ""
    }
    
}

extension ViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterCurrentDataSource(searchTerm: searchText)
        }
    }
}

extension ViewController: UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchBar.text{filterCurrentDataSource(searchTerm: searchText)
            
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchBar.text , searchText.isEmpty{
            restoreCurrentDataSource()
        }
    }
    
    // try to make X works starts
    func searchBar(_ searchBar: UISearchBar,
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool
    {
        didTapDeleteKey = text.isEmpty
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String)
    {
        if !didTapDeleteKey && searchText.isEmpty {
            restoreCurrentDataSource()
        }
        
        didTapDeleteKey = false
    }
    // try to make X works ends
}

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableViuew: UITableView , didSelectRowAt IndexPath : IndexPath){
//
//            //取消選取的列
//            tableView.deselectRow(at: IndexPath, animated: true)
//            performSegue(withIdentifier: "segue_ViewController_to_testController", sender: self)
//
//        
        let alertController = UIAlertController( title:"Selection", message :"Selected: \(currentDataScource[IndexPath.row])", preferredStyle: .alert)
        
        searchController.isActive = false
        
        
        let okAction = UIAlertAction(title : "OK", style : .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataScource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentDataScource[indexPath.row]
        tableView.tableFooterView = UIView() // make the empty cells' line invisible
        return cell
        
    }
    
    
    //show up navigation bar again when back to this page
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
}
