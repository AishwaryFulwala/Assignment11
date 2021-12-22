//
//  Login.swift
//  Assignment11
//
//  Created by DCS on 16/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class Login: UIViewController {
    
    private let lbltitle : UILabel = {
        let l = UILabel()
        l.text = "Sign in"
        l.font = l.font.withSize(30)
        l.textColor = .white
        return l
    }()
    
    private let txtuid: UITextField = {
        let t = UITextField()
        t.borderStyle = .roundedRect
        t.leftViewMode = .always
        t.placeholder = "Enter UserID"
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let imguid : UIImageView = {
        let img = UIImageView(image: UIImage(named: "p1.png"))
        img.contentMode = .scaleAspectFit
        img.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return img
    }()

    private let txtpwd : UITextField = {
        let t = UITextField()
        t.borderStyle = .roundedRect
        t.leftViewMode = .always
        t.placeholder = "Enter Password"
        t.isSecureTextEntry = true
        t.layer.cornerRadius = 5
        t.layer.shadowColor = UIColor.white.cgColor
        t.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        t.layer.shadowOpacity = 5.0
        t.layer.shadowRadius = 5.0
        return t
    }()
    
    private let imgpwd : UIImageView = {
        let img = UIImageView(image: UIImage(named: "pwd.png"))
        img.contentMode = .scaleAspectFit
        img.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return img
    }()
    
    private let btnsignin: UIButton = {
        let b = UIButton()
        b.setTitle("Sign in", for: .normal)
        b.backgroundColor = UIColor(red: (100/255), green: (150/255), blue: (200/255), alpha: 1)
        b.layer.cornerRadius = 6
        b.tag = 0
        b.addTarget(self, action: #selector(signin), for: .touchUpInside)
        return b
    }()
    
    @objc func signin() {
        if txtuid.text == "Admin" && txtpwd.text == "Admin123" {
            UserDefaults.standard.setValue(txtuid.text, forKey: "username")
             
            let ah = AdminHome()
            navigationController?.pushViewController(ah, animated: true)
            self.present(ah, animated: true)
        }
        else {
            let id = Int(txtuid.text!)
            let pwd = txtpwd.text
            let check = SQLiteHandler.shared.check(id: id!, pwd: pwd!)
            
            if check == true {
                UserDefaults.standard.setValue(txtuid.text, forKey: "username")
              
                let sh = StudHome()
                navigationController?.pushViewController(sh, animated: true)
                self.present(sh, animated: true)
            }
            else {
                lblerror.text = "Invalid Username or Password"
            }
        }
    }
    
    private let lblerror : UILabel = {
        let l = UILabel()
        l.text = ""
        l.textColor = .red
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        back()
        
        view.addSubview(lbltitle)
        
        view.addSubview(txtuid)
        txtuid.leftView = imguid
        
        view.addSubview(txtpwd)
        txtpwd.leftView = imgpwd
        
        view.addSubview(btnsignin)
        view.addSubview(lblerror)
        
    }
    
    override func viewDidLayoutSubviews() {
        lbltitle.frame = CGRect(x: 140, y: 75, width: 100, height: 50)
        txtuid.frame = CGRect(x: 30, y: 200, width: view.width - 60, height: 50)
        txtpwd.frame = CGRect(x: 30, y: txtuid.bottom + 50, width: view.width - 60, height: 50)
        btnsignin.frame = CGRect(x: 110, y: txtpwd.bottom + 80, width: 150, height: 50)
        lblerror.frame = CGRect(x: 70, y: txtpwd.bottom + 20, width: 250, height: 50)
    }
}
