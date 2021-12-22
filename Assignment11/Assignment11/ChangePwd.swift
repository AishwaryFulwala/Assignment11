//
//  ChangePwd.swift
//  Assignment11
//
//  Created by DCS on 22/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class ChangePwd: UIViewController {
    
    var data = Stud(spid: 0, name: "", pwd: "", Class: "", phone: "")
    
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
        let sh = StudHome()
        navigationController?.pushViewController(sh, animated: true)
        self.present(sh, animated: true)
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
    
    private let txtopwd : UITextField = {
        let t = UITextField()
        t.borderStyle = .roundedRect
        t.leftViewMode = .always
        t.placeholder = "Enter Old Password"
        t.isSecureTextEntry = true
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let txtnpwd : UITextField = {
        let t = UITextField()
        t.borderStyle = .roundedRect
        t.leftViewMode = .always
        t.placeholder = "Enter New Password"
        t.isSecureTextEntry = true
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let txtcnpwd : UITextField = {
        let t = UITextField()
        t.borderStyle = .roundedRect
        t.leftViewMode = .always
        t.placeholder = "Enter Confirm New Password"
        t.isSecureTextEntry = true
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let btnchange: UIButton = {
        let b = UIButton()
        b.setTitle("Change", for: .normal)
        b.backgroundColor = UIColor(red: (100/255), green: (150/255), blue: (200/255), alpha: 1)
        b.layer.cornerRadius = 6
        b.tag = 0
        b.addTarget(self, action: #selector(change), for: .touchUpInside)
        return b
    }()
    
    @objc func change() {
        if(data.pwd == txtopwd.text) {
            if(txtnpwd.text == txtcnpwd.text) {
                let pwd = txtnpwd.text!
                
                let s = Stud(spid: data.spid, name : "", pwd : pwd, Class : "", phone : "")
                SQLiteHandler.shared.chpwd(s: s) { (success) in
                    if success {
                        print("update")
                        
                        let sh = StudHome()
                        self.navigationController?.pushViewController(sh, animated: true)
                        self.present(sh, animated: true)
                    } else {
                        print("not update")
                    }
                }
            }
            else {
                lblerror.text = """
                Please enter New Password
                and
                Confirm New Password Same.
                """
            }
        }
        else {
            lblerror.text = "Invalid old Password"
        }
    }
    
    private let lblerror : UILabel = {
        let l = UILabel()
        l.text = ""
        l.textColor = .red
        l.numberOfLines = 3
        l.textAlignment = .center
        return l
    }()
    
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
        let id = Int(UserDefaults.standard.string(forKey: "username")!)
        data = SQLiteHandler.shared.fetchid(id: id!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        back()
        
        view.addSubview(tob)
        view.addSubview(lbltitle)
        view.addSubview(txtopwd)
        view.addSubview(txtnpwd)
        view.addSubview(txtcnpwd)
        view.addSubview(lblerror)
        view.addSubview(btnchange)
    }
    
    override func viewDidLayoutSubviews() {
        tob.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 370, height: 50)
        lbltitle.frame = CGRect(x: 35, y: view.safeAreaInsets.top + 30, width: 300, height: 130)
        txtopwd.frame = CGRect(x: 30, y: lbltitle.bottom + 50, width: view.width - 60, height: 50)
        txtnpwd.frame = CGRect(x: 30, y: txtopwd.bottom + 30, width: view.width - 60, height: 50)
        txtcnpwd.frame = CGRect(x: 30, y: txtnpwd.bottom + 30, width: view.width - 60, height: 50)
        lblerror.frame = CGRect(x: 70, y: txtcnpwd.bottom + 20, width: 250, height: 100)
        btnchange.frame = CGRect(x: 110, y: lblerror.bottom + 20, width: 150, height: 50)
    }
}
