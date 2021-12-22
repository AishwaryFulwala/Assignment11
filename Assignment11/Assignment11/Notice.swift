//
//  Notice.swift
//  Assignment11
//
//  Created by DCS on 20/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class Notice: UIViewController {
    
    private let tob:UIToolbar = {
        let t = UIToolbar()
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handlecancel))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil);
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleadd))
        
        t.items = [cancel, space, add]
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
    
    @objc private func handleadd() {
        let an = AddNotice()
        navigationController?.pushViewController(an, animated: true)
        self.present(an, animated: true)
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
    
    private var data = [NoticeClass]()
    
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
        data = SQLiteHandler.shared.fetchN()
        tb.reloadData()
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
        tob.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 370, height: 50)
        lbltitle.frame = CGRect(x: 35, y: view.safeAreaInsets.top + 30, width: 300, height: 130)
        tb.frame = CGRect(x: 0,
                          y: lbltitle.bottom + 10,
                          width: view.width,
                          height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
    }
}

extension Notice : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let n = data[indexPath.row]
        cell.textLabel?.text = "\(n.date) \t | \t \(n.title)"
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
        let addn = AddNotice()
        addn.ntitle = data[indexPath.row]
        navigationController?.pushViewController(addn, animated: true)
        self.present(addn, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let id = data[indexPath.row].id
        SQLiteHandler.shared.deleteN(for: id) { (success) in
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
