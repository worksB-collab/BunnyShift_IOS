//
//  ThirdViewController.swift
//  practice1225Login
//
//  Created by cm0521 on 2019/12/26.
//  Copyright © 2019 cm0521. All rights reserved.
//
import UIKit



class ThirdViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    var numbers = ["3","5","6","7","10","4","3","22","100","123","66"]
    var checknumbers = Array(repeating: false, count: 11)
    var letters = ["😺","😿","😹","🙀","😾","😽","😻","😼"]
    var checkletters = Array(repeating: false, count: 8)
    
    //決定有幾個區塊
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 設置tableView每個Header的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // 設置tableView每個Header的內容
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        let viewLabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        viewLabel.textColor = UIColor(red:0.31, green:0.31, blue:0.31, alpha:1.0)
        
        if section == 0{
            viewLabel.text = "我全都要"
        }
        else if section == 1{
            viewLabel.text = "這我不要"
        }
        view.addSubview(viewLabel)
        tableView.addSubview(view)
        return view
    }
    
    // 根據各區去計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return numbers.count
        }
        return letters.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "datacell"
        
        // 把 tableView 中叫 datacell 的畫面部分跟 TestTableViewCell 類別做連結
        // 用 as！轉型(轉成需要顯示的cell : TestTableViewCell)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ThirdTableViewCell
        
        
        
        if(indexPath.section == 0){
            cell.nameLabel.text = numbers[indexPath.row]
                       cell.accessoryType = checknumbers[indexPath.row] ? .checkmark: .none
        }
        else if indexPath.section == 1{
            cell.nameLabel.text = letters[indexPath.row]
            //            if checkletters[indexPath.row]{
            //                cell.accessoryType = .checkmark}
            //            else{
            //                cell.accessoryType = .none
            //            }
                        cell.accessoryType = checkletters[indexPath.row] ? .checkmark: .none
        }
        cell.thumbnailImageView.image = UIImage(named: "bulb-curvy-flat")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //建立一個 清單(.actionSheet) / dialogue(.alert)
        let optionMenu = UIAlertController(title: "這就是人生", message: "人生好難", preferredStyle: .actionSheet)
        //加入取消動作
        let cancelAction = UIAlertAction(title: "我選擇死亡", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        //加入其他動作
        
        let selectedAction = UIAlertAction(title: "先打場", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            //更改相對應的checkarray(閉包內要加self)
            if(indexPath.section == 0){
                self.checknumbers[indexPath.row] = true
            }
            else{
                self.checkletters[indexPath.row] = true
            }
            
        })
        optionMenu.addAction(selectedAction)
        
        //呈現 清單
        present(optionMenu,animated: true, completion: nil)
        
        //取消選取的列
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
        override var prefersStatusBarHidden: Bool{
            return true
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
