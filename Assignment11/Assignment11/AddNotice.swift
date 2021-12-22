//
//  AddNotice.swift
//  Assignment11
//
//  Created by DCS on 20/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class AddNotice: UIViewController {
    
    var ntitle: NoticeClass?
    
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
        let ns = Notice()
        navigationController?.pushViewController(ns, animated: true)
        self.present(ns, animated: true)
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
    
    private let txttitle : UITextField = {
        let t = UITextField()
        t.placeholder = "Title"
        t.textAlignment = .center
        t.borderStyle = .roundedRect
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let txtdate : UITextField = {
        let t = UITextField()
        t.placeholder = "Date"
        t.textAlignment = .center
        t.borderStyle = .roundedRect
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let txtdes : UITextField = {
        let t = UITextField()
        t.placeholder = "Description"
        t.textAlignment = .center
        t.borderStyle = .roundedRect
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let btnsave : UIButton = {
        let b = UIButton()
        b.setTitle("Save", for: .normal)
        b.layer.cornerRadius = 6
        b.backgroundColor = UIColor(red: (100/255), green: (150/255), blue: (200/255), alpha: 1)
        b.tintColor = .white
        b.addTarget(self, action: #selector(save), for: .touchUpInside)
        return b
    }()
    
    @objc func save()
    {
        let t = txttitle.text!
        let date = txtdate.text!
        let des = txtdes.text!
    
        if let n = ntitle {
            let n = NoticeClass(id: n.id, title: t, date: date, description: des)
            update(n: n)
        }
        else {
            let n = NoticeClass(id: 0, title: t, date: date, description: des)
            insert(n: n)
        }
    }
    
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
    
    private func clear() {
        title = nil
        txttitle.text = ""
        txtdate.text = ""
        txtdes.text = ""
    }
    
    private func insert(n: NoticeClass) {
        SQLiteHandler.shared.insertN(n: n) { [weak self] (success) in
            if success {
                print("insert")
                self?.clear()
                let ns = Notice()
                self!.navigationController?.pushViewController(ns, animated: true)
                self!.present(ns, animated: true)
            } else {
                print("not insert")
            }
        }
    }
    
    private func update(n: NoticeClass) {
        SQLiteHandler.shared.updateN(n: n) { (success) in
            if success {
                print("update")
                self.clear()
                let ns = Notice()
                self.navigationController?.pushViewController(ns, animated: true)
                self.present(ns, animated: true)
            } else {
                print("not update")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tob.layer.backgroundColor = UIColor.clear.cgColor
        back()
        
        view.addSubview(tob)
        view.addSubview(lbltitle)
        view.addSubview(txttitle)
        view.addSubview(txtdate)
        view.addSubview(txtdes)
        
        if let n = ntitle {
            txttitle.text = n.title
            txtdate.text = n.date
            txtdes.text = n.description
        }
        
        view.addSubview(btnsave)
    }
    
    override func viewDidLayoutSubviews() {
        tob.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 90, height: 50)
        lbltitle.frame = CGRect(x: 35, y: view.safeAreaInsets.top + 30, width: 300, height: 150)
        txttitle.frame = CGRect(x: 40, y: lbltitle.bottom + 40, width: view.width - 80 , height: 40)
        txtdate.frame = CGRect(x: 40, y: txttitle.bottom + 20, width: view.width - 80 , height: 40)
        txtdes.frame = CGRect(x: 40, y: txtdate.bottom + 20, width: view.width - 80 , height: 100)
        btnsave.frame = CGRect(x: 40, y: txtdes.bottom + 60, width: view.width - 80 , height: 40)
    }
}
