//
//  AdminHome.swift
//  Assignment11
//
//  Created by DCS on 17/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class AdminHome: UIViewController {
    
    private let tob:UIToolbar = {
        let image = UIImage(named: "log.jpg")
        
        let t = UIToolbar()
        let logout = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handlelog))
            
        t.items = [logout]
        t.setBackgroundImage(UIImage(),
                             forToolbarPosition: .any,
                             barMetrics: .default)
        t.setShadowImage(UIImage(), forToolbarPosition: .any)
        t.tintColor = .white
        return t
    }()

    @objc private func handlelog() {
        UserDefaults.standard.setValue(nil, forKey: "username")
        let l = Login()
        navigationController?.pushViewController(l, animated: true)
        self.present(l, animated: true)
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
    
    private let tb = UITableView()
    
    private var feature = ["Add new student", "Fetch all students data",
                        "Fetch students of particular class",
                        "Modify existing student details", "Remove a student",
                        "Update NoticeBoard"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        back()
        
        view.addSubview(tob)
        view.addSubview(lbltitle)
        view.addSubview(tb)
        
        tb.backgroundColor = UIColor.clear
        tb.dataSource = self
        tb.delegate = self
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidLayoutSubviews() {
        tob.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 10, width: 50, height: 20)
        lbltitle.frame = CGRect(x: 35, y: view.safeAreaInsets.top + 30, width: 300, height: 150)
        tb.frame = CGRect(x: 0,
                            y: lbltitle.bottom + 10,
                            width: view.width,
                            height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }
}

extension AdminHome: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return feature.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = feature[indexPath.row]
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
        if indexPath.row == 0 {
            let adds = AddStud()
            navigationController?.pushViewController(adds, animated: true)
            self.present(adds, animated: true)
        }
        else if indexPath.row == 1 {
            let fs = FetchStud()
            navigationController?.pushViewController(fs, animated: true)
            self.present(fs, animated: true)
        }
        else if indexPath.row == 2 {
            let fs = FetchStud()
            fs.a = "class"
            navigationController?.pushViewController(fs, animated: true)
            self.present(fs, animated: true)
        }
        else if indexPath.row == 3 {
            let fs = FetchStud()
            fs.a = "update"
            navigationController?.pushViewController(fs, animated: true)
            self.present(fs, animated: true)
        }
        else if indexPath.row == 4 {
            let fs = FetchStud()
            fs.a = "delete"
            navigationController?.pushViewController(fs, animated: true)
            self.present(fs, animated: true)
        }
        else if indexPath.row == 5 {
            let ns = Notice()
            navigationController?.pushViewController(ns, animated: true)
            self.present(ns, animated: true)
        }
    }
}
