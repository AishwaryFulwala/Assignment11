//
//  NoticeDetail.swift
//  Assignment11
//
//  Created by DCS on 22/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class NoticeDetail: UIViewController {

    var id : Int = 0
    
    var data = NoticeClass(id: 0, title: "", date: "", description: "")
    
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
        let rn = ReadNotice()
        navigationController?.pushViewController(rn, animated: true)
        self.present(rn, animated: true)
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
    
    private let lbldisp : UILabel = {
        let l = UILabel()
        l.text = ""
        l.textColor = .white
        l.numberOfLines = 10
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
        data = SQLiteHandler.shared.fetchidn(id: id)
        lbldisp.text = """
        Title :: \(data.title)
        Date :: \(data.date)
        Description :: \(data.description)
        """
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        back()
        
        view.addSubview(tob)
        view.addSubview(lbltitle)
        view.addSubview(lbldisp)
    }
    
    override func viewDidLayoutSubviews() {
        tob.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 90, height: 50)
        lbltitle.frame = CGRect(x: 35, y: view.safeAreaInsets.top + 30, width: 300, height: 130)
        lbldisp.frame = CGRect(x: 20, y: lbltitle.bottom, width: view.width - 40, height: 300)
    }
}
