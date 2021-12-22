//
//  AddStud.swift
//  Assignment11
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class AddStud: UIViewController {

    var name: Stud?
    
    private let tob:UIToolbar = {
        let t = UIToolbar()
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handlecancel))

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
    
    private let txtnm : UITextField = {
        let t = UITextField()
        t.placeholder = "Name"
        t.textAlignment = .center
        t.borderStyle = .roundedRect
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let txtpwd : UITextField = {
        let t = UITextField()
        t.placeholder = "Password"
        t.isSecureTextEntry = true
        t.textAlignment = .center
        t.borderStyle = .roundedRect
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let txtclass : UITextField = {
        let t = UITextField()
        t.placeholder = "Class"
        t.textAlignment = .center
        t.borderStyle = .roundedRect
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let txtpno : UITextField = {
        let t = UITextField()
        t.placeholder = "Phone Number"
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
        let nm = txtnm.text!
        let pwd = txtpwd.text!
        let Class = txtclass.text!
        let pno = txtpno.text!

        if let s = name {
            let s = Stud(spid: s.spid, name : nm, pwd : pwd, Class : Class, phone : pno)
            update(s: s)
        }
        else {
            let s = Stud(spid: 0, name : nm, pwd : pwd, Class : Class, phone : pno)
            insert(s: s)
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
        name = nil
        txtnm.text = ""
        txtpwd.text = ""
        txtclass.text = ""
        txtpno.text = ""
    }
    
    private func insert(s: Stud) {
        SQLiteHandler.shared.insert(s: s) { [weak self] (success) in
            if success {
                print("insert")
                self?.clear()
                let ah = AdminHome()
                self!.navigationController?.pushViewController(ah, animated: true)
                self!.present(ah, animated: true)
            } else {
                print("not insert")
            }
        }
    }

    private func update(s: Stud) {
        SQLiteHandler.shared.update(s: s) { (success) in
            if success {
                print("update")
                self.clear()
                let fs = FetchStud()
                self.navigationController?.pushViewController(fs, animated: true)
                self.present(fs, animated: true)
            } else {
                print("not update")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        back()
        
        view.addSubview(tob)
        view.addSubview(lbltitle)
        view.addSubview(txtnm)
        view.addSubview(txtpwd)
        view.addSubview(txtclass)
        view.addSubview(txtpno)
        
        if let s = name {
            txtnm.text = s.name
            txtpwd.text = s.pwd
            txtclass.text = s.Class
            txtpno.text = s.phone
        }
        
        view.addSubview(btnsave)
    }
    
    override func viewDidLayoutSubviews() {
        tob.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 90, height: 50)
        lbltitle.frame = CGRect(x: 35, y: view.safeAreaInsets.top + 30, width: 300, height: 150)
        txtnm.frame = CGRect(x: 40, y: lbltitle.bottom + 40, width: view.width - 80 , height: 40)
        txtpwd.frame = CGRect(x: 40, y: txtnm.bottom + 20, width: view.width - 80 , height: 40)
        txtclass.frame = CGRect(x: 40, y: txtpwd.bottom + 20, width: view.width - 80 , height: 40)
        txtpno.frame = CGRect(x: 40, y: txtclass.bottom + 20, width: view.width - 80 , height: 40)
        btnsave.frame = CGRect(x: 40, y: txtpno.bottom + 60, width: view.width - 80 , height: 40)
    }
}
