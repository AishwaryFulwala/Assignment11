//
//  ReadNotice.swift
//  Assignment11
//
//  Created by DCS on 22/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class ReadNotice: UIViewController {

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

extension ReadNotice : UITableViewDelegate, UITableViewDataSource {
    
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
        let nd = NoticeDetail()
        nd.id = data[indexPath.row].id
        navigationController?.pushViewController(nd, animated: true)
        self.present(nd, animated: true)
    }
}
