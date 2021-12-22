//
//  FetchStud.swift
//  Assignment11
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class FetchStud: UIViewController {
  
    var a : String = ""
    
    private let tob:UIToolbar = {
        let t = UIToolbar()
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handlecancel))
        let s = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        t.items = [cancel]
        t.setBackgroundImage(UIImage(),
                             forToolbarPosition: .any,
                             barMetrics: .default)
        t.setShadowImage(UIImage(), forToolbarPosition: .any)
        t.tintColor = .white
        return t
    }()
    
    @objc private func handlecancel() {
        let ah = AdminHome()
        navigationController?.pushViewController(ah, animated: true)
        self.present(ah, animated: true)
    }
    
    private let lbltitle : UILabel = {
        let l = UILabel()
        l.text = """
        Students Management
        System
        """
        l.font = l.font.withSize(30)
        l.textColor = .white
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()
    
    private let txtclass : UITextField = {
        let t = UITextField()
        t.placeholder = "Class"
        t.textAlignment = .center
        t.borderStyle = .roundedRect
        t.layer.cornerRadius = 5
        t.layer.shadowRadius = 2.0
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let btnsearch : UIButton = {
        let b = UIButton()
        b.setTitle("Search", for: .normal)
        b.layer.cornerRadius = 6
        b.backgroundColor = UIColor(red: (100/255), green: (150/255), blue: (200/255), alpha: 1)
        b.tintColor = .white
        b.addTarget(self, action: #selector(search), for: .touchUpInside)
        return b
    }()
    
    @objc func search()
    {
        data = SQLiteHandler.shared.fetchclass(for: txtclass.text!)
        self.tb.reloadData()
        print("hi")
    }
    
    private let tb = UITableView()
    
    private var data = [Stud]()
    
    func back() {
        let iv : UIImageView = {
            let i = UIImageView()
            i.contentMode = .scaleAspectFill
            i.clipsToBounds = true
            i.frame = view.bounds
            i.image = UIImage(named: "Back.jpeg")
            return i
        }()
        
        view.addSubview(iv)
        view.sendSubviewToBack(iv)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = SQLiteHandler.shared.fetch()
        tb.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        back()
        
        view.addSubview(txtclass)
        view.addSubview(btnsearch)
        view.addSubview(tob)
        view.addSubview(lbltitle)
        view.addSubview(tb)
        
        tb.backgroundColor = UIColor.clear
        tb.dataSource = self
        tb.delegate = self
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if a != "class" {
            txtclass.isHidden = true
            btnsearch.isHidden = true
        }
        else {
            txtclass.isHidden = false
            btnsearch.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        tob.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 90, height: 50)
        lbltitle.frame = CGRect(x: 35, y: view.safeAreaInsets.top + 30, width: 300, height: 130)
        txtclass.frame = CGRect(x: 40, y: lbltitle.bottom, width: 170 , height: 40)
        btnsearch.frame = CGRect(x: 240, y: lbltitle.bottom, width: 100, height: 40)
        tb.frame = CGRect(x: 0,
                          y: txtclass.bottom + 20,
                          width: view.width,
                          height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }
}

extension FetchStud: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let s = data[indexPath.row]
        cell.textLabel?.text = "\(s.name) \t | \t \(s.Class) \t | \t \(s.phone)"
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor(red: (237/255), green: (229/255), blue: (206/255), alpha: 1)
        cell.textLabel?.font =  UIFont.systemFont(ofSize: 20)
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if a == "update" {
            let adds = AddStud()
            adds.name = data[indexPath.row]
            navigationController?.pushViewController(adds, animated: true)
            self.present(adds, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if a == "delete" {
            let id = data[indexPath.row].spid
            SQLiteHandler.shared.delete(for: id) { (success) in
                if success {
                    self.data.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                else {
                    print("unable to delete from vc")
                }
            }
        }
    }
}
