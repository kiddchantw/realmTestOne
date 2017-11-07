//
//  ViewControllerTwo.swift
//  realmTestOne
//
//  Created by kiddchantw on 2017/11/6.
//  Copyright © 2017年 kiddchantw. All rights reserved.
//
// testjsonData from https://data.kcg.gov.tw/dataset?res_format=JSON
//

import UIKit
import RealmSwift

struct kblib:Codable {
    let ID :Int?
    let Title :String?
    let Tel :String?
    let Fax :String?
    let Address:String?
    let Email:String?
    let Facebook:String?
    let OpenTime:String?
    let CloseTime:String?
}




class ViewControllerTwo: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let realm = try! Realm()
    @IBOutlet weak var myTable: UITableView!

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let users = realm.objects(tableTwo.self)

        let deleteAction = UITableViewRowAction(style: .normal, title: "刪除") { (action, indexPath) in
            print("select \(users[indexPath.row].libtitle)")
            
            if let user = self.realm.objects(tableTwo.self).filter(" libtitle = '\(users[indexPath.row].libtitle)'").first {
                try! self.realm.write {
                    self.realm.delete(user)
                    self.myTable.reloadData()
                }
            }
            
        }
        deleteAction.backgroundColor = UIColor.red
        
        let updateAction = UITableViewRowAction(style: .normal, title: "更新") { (action, indexPath) in
            
            if self.realm.objects(tableTwo.self).filter(" libtitle = '\(users[indexPath.row].libtitle)'").first != nil {
                try! self.realm.write {
                    users[indexPath.row].libaddress = "才不告訴你咧"
                    self.myTable.reloadData()
                }
            }
            
        }
        updateAction.backgroundColor = UIColor.blue
        
        return [deleteAction,updateAction]
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let users = realm.objects(tableTwo.self)
        print("numberOfRowsInSection count \(users.count)")
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "Cell")
        let users = realm.objects(tableTwo.self)
        if users.count != 0{
            
            cell?.textLabel?.text = users[indexPath.row].libtitle
            cell?.detailTextLabel?.text=users[indexPath.row].libaddress
            
        }else{
            cell?.textLabel?.text = "realmtest"
            cell?.detailTextLabel?.text = ""
        }
        return cell!
    }
    
    

    
    @IBAction func deleteAll(_ sender: Any) {
        deleteAllItem()
    }
    

    
    
    @IBAction func btngetData(_ sender: Any) {
        getjsonData()
    }
    
    
    
    
    func deleteAllItem(){
        try! realm.write {
            realm.deleteAll()
            myTable.reloadData()
        }
    }
   
    
    func readRealmData(){
        let users = realm.objects(tableTwo.self)
        print("readRealmData count \(users.count)")
    }
    
    
    func getjsonData(){
        let jsonUrlstr = "http://opendata.khcc.gov.tw/public/OD_ksml_info.ashx"
        
        guard let url = URL(string:jsonUrlstr) else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let jsondata = data else {return}
            
            do{
                let kblibOne = try JSONDecoder().decode([kblib].self, from: jsondata)
                print(kblibOne.count)
            
                DispatchQueue.main.async {
                    let nowcount:Int = self.realm.objects(tableTwo.self).count
                    print(nowcount)
                    if nowcount != 0 {
                        print("nowcount != 0")

                        if kblibOne.count != nowcount {
                            let alertController = UIAlertController.init(title: "檢查更新", message: "發現更新檔", preferredStyle: .alert)
                            let cancelAction = UIAlertAction.init(title: "取消更新", style: .cancel, handler: nil)
                            alertController.addAction(cancelAction)
                            let okAction = UIAlertAction.init(title: "開始更新", style: .default, handler: { (action:UIAlertAction) in
                                
                                self.deleteAllItem()
                                print("開始更新")
                               
                                for bbb in kblibOne{
                                    let aaa = tableTwo()
                                    aaa.libtitle = bbb.Title!
                                    aaa.libaddress = bbb.Address!
                                    try! self.realm.write {
                                        self.realm.add(aaa)
                                        self.myTable.reloadData()
                                    }
                                }
                            })
                            alertController.addAction(okAction)
                            self.present(alertController,animated: true, completion: nil)
                        }
                    }else if nowcount == 0 {
                        print(" nowcount == 0")
                        for bbb in kblibOne{
                            let aaa = tableTwo()
                            aaa.libtitle = bbb.Title!
                            aaa.libaddress = bbb.Address!
                                try! self.realm.write {
                                    self.realm.add(aaa)
                                    self.myTable.reloadData()
                            }
                        }
                    }else{
                        print("nowcount Q3")
                    }
                }
            }catch let jsonerror{
                print("error serializing json :" ,jsonerror)
            }
        }.resume()
        
    }
    
    
    
    func searchRealm(){
//        let results = realm.objects(tableTwo.self).filter("libtitle = '總館'")
//        print("user.count \(results.count)")

        let results = realm.objects(tableTwo.self).filter("libaddress contains[c] %@", "左營")
        print("user.count \(results.count)")

    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTable.delegate = self
        myTable.dataSource = self
        
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitle("RealmCRUD", for: .normal)
        button.setTitleColor(UIColor.black,for: .normal)
        button.addTarget(self, action: #selector(self.searchRealm), for: .touchUpInside)
        self.navigationItem.titleView = button
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
