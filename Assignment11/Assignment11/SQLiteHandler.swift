//
//  SQLiteHandler.swift
//  Assignment11
//
//  Created by DCS on 18/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteHandler {
    
    static let shared = SQLiteHandler()
    
    let dbpath = "studdb.sqlite"
    var db:OpaquePointer?
    
    private init() {
        db = openDatabase()
        createTable()
        createTableN()
    }
    
    func openDatabase() -> OpaquePointer? {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docURL.appendingPathComponent(dbpath)
        
        var database:OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &database) == SQLITE_OK {
            print("Opened connection to the database successfully at: \(fileURL)")
            return database
        }
        else {
            print("Error connecting to the database")
            return nil
        }
    }
    
    func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS stud(
            spid INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            password TEXT,
            class TEXT,
            phone TEXT
        );
        """
        
        var createTableSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableSataement, nil) == SQLITE_OK {
            if sqlite3_step(createTableSataement) == SQLITE_DONE {
                print("stud table created")
            }
            else {
                print("stud table could not be created")
            }
        }
        else {
            print("stud table could not be prepared")
        }
        
        sqlite3_finalize(createTableSataement)
    }
    
    func insert (s : Stud, completion : @escaping ((Bool) -> Void)) {
        let insertString = "INSERT INTO stud(name, password, class, phone) VALUES(?, ?, ?, ?);"
        
        var insertSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertString, -1, &insertSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertSataement, 1, (s.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertSataement, 2, (s.pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertSataement, 3, (s.Class as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertSataement, 4, (s.phone as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertSataement) == SQLITE_DONE {
                print("Inserted row Successfully")
                completion(true)
            }
            else {
                print("could not insert row")
                completion(false)
            }
        }
        else {
            print("Insert statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(insertSataement)
    }
    
    func update (s : Stud, completion : @escaping ((Bool) -> Void)) {
        let updateString = "UPDATE stud SET name = ?, password = ?, class = ?, phone = ? WHERE spid = ?;"
        
        var updateSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateString, -1, &updateSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(updateSataement, 1, (s.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateSataement, 2, (s.pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateSataement, 3, (s.Class as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateSataement, 4, (s.phone as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateSataement, 5, Int32(s.spid))
            
            if sqlite3_step(updateSataement) == SQLITE_DONE {
                print("Updated row Successfully")
                completion(true)
            }
            else {
                print("could not update row")
                completion(false)
            }
        }
        else {
            print("Upadte statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(updateSataement)
    }
    
    func delete (for id : Int, completion : @escaping ((Bool) -> Void)) {
        let deleteString = "DELETE FROM stud WHERE spid = ?;"
        
        var deleteSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deleteSataement, 1, Int32(id))
            
            if sqlite3_step(deleteSataement) == SQLITE_DONE {
                print("delete row Successfully")
                completion(true)
            }
            else {
                print("could not delete row")
                completion(false)
            }
        }
        else {
            print("delete statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(deleteSataement)
    }
    
    func fetch () -> [Stud] {
        let fetchString = "SELECT * FROM stud;"
        
        var fetchSataement: OpaquePointer? = nil
        
        var s = [Stud]()
        
        if sqlite3_prepare_v2(db, fetchString, -1, &fetchSataement, nil) == SQLITE_OK {
            while sqlite3_step(fetchSataement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchSataement, 0))
                let name = String(cString: sqlite3_column_text(fetchSataement, 1))
                let pwd = String(cString: sqlite3_column_text(fetchSataement, 2))
                let Class = String(cString: sqlite3_column_text(fetchSataement, 3))
                let phone = String(cString: sqlite3_column_text(fetchSataement, 4))
                
                s.append(Stud(spid : id, name : name, pwd : pwd, Class : Class, phone : phone))
                print("\(id) | \(name) | \(pwd) | \(Class) | \(phone)")
                
                print("fetch row Successfully")
            }
        }
        else {
            print("fetch statement could not be prepared")
        }
        
        sqlite3_finalize(fetchSataement)
        
        return s
    }
    
    func fetchclass (for Class : String) -> [Stud] {
        let fetchString = "SELECT * FROM stud WHERE class = ?;"
        
        var fetchSataement: OpaquePointer? = nil
        
        var s = [Stud]()
        
        if sqlite3_prepare_v2(db, fetchString, -1, &fetchSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(fetchSataement, 1, (Class as NSString).utf8String, -1, nil)
            
            while sqlite3_step(fetchSataement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchSataement, 0))
                let name = String(cString: sqlite3_column_text(fetchSataement, 1))
                let pwd = String(cString: sqlite3_column_text(fetchSataement, 2))
                let Class = String(cString: sqlite3_column_text(fetchSataement, 3))
                let phone = String(cString: sqlite3_column_text(fetchSataement, 4))
                
                s.append(Stud(spid : id, name : name, pwd : pwd, Class : Class, phone : phone))
                print("\(id) | \(name) | \(pwd) | \(Class) | \(phone)")
                
                print("fetch row Successfully")
            }
        }
        else {
            print("fetch statement could not be prepared")
        }
        
        sqlite3_finalize(fetchSataement)
        
        return s
    }
    
    func createTableN() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS notice(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT,
            description TEXT
        );
        """
        
        var createTableSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableSataement, nil) == SQLITE_OK {
            if sqlite3_step(createTableSataement) == SQLITE_DONE {
                print("notice table created")
            }
            else {
                print("notice table could not be created")
            }
        }
        else {
            print("notice table could not be prepared")
        }
        
        sqlite3_finalize(createTableSataement)
    }
    
    func insertN (n : NoticeClass, completion : @escaping ((Bool) -> Void)) {
        let insertString = "INSERT INTO notice(title, date, description) VALUES(?, ?, ?);"
        
        var insertSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertString, -1, &insertSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertSataement, 1, (n.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertSataement, 2, (n.date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertSataement, 3, (n.description as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertSataement) == SQLITE_DONE {
                print("Inserted row Successfully")
                completion(true)
            }
            else {
                print("could not insert row")
                completion(false)
            }
        }
        else {
            print("Insert statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(insertSataement)
    }
    
    func updateN (n : NoticeClass, completion : @escaping ((Bool) -> Void)) {
        let updateString = "UPDATE notice SET title = ?, date = ?, description = ? WHERE id = ?;"
        
        var updateSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateString, -1, &updateSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(updateSataement, 1, (n.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateSataement, 2, (n.date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateSataement, 3, (n.description as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateSataement, 4, Int32(n.id))
            
            if sqlite3_step(updateSataement) == SQLITE_DONE {
                print("Updated row Successfully")
                completion(true)
            }
            else {
                print("could not update row")
                completion(false)
            }
        }
        else {
            print("Upadte statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(updateSataement)
    }
    
    func deleteN (for id : Int, completion : @escaping ((Bool) -> Void)) {
        let deleteString = "DELETE FROM notice WHERE id = ?;"
        
        var deleteSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deleteSataement, 1, Int32(id))
            
            if sqlite3_step(deleteSataement) == SQLITE_DONE {
                print("delete row Successfully")
                completion(true)
            }
            else {
                print("could not delete row")
                completion(false)
            }
        }
        else {
            print("delete statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(deleteSataement)
    }
    
    func fetchN () -> [NoticeClass] {
        let fetchString = "SELECT * FROM notice;"
        
        var fetchSataement: OpaquePointer? = nil
        
        var n = [NoticeClass]()
        
        if sqlite3_prepare_v2(db, fetchString, -1, &fetchSataement, nil) == SQLITE_OK {
            while sqlite3_step(fetchSataement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchSataement, 0))
                let title = String(cString: sqlite3_column_text(fetchSataement, 1))
                let date = String(cString: sqlite3_column_text(fetchSataement, 2))
                let description = String(cString: sqlite3_column_text(fetchSataement, 3))
               
                n.append(NoticeClass(id: id, title: title, date: date, description: description))
                print("\(id) | \(title) | \(date) | \(description)")
                
                print("fetch row Successfully")
            }
        }
        else {
            print("fetch statement could not be prepared")
        }
        
        sqlite3_finalize(fetchSataement)
        
        return n
    }
    
    func check(id : Int, pwd : String) -> Bool {
        var cnt = 0
        
        let fetchString = "SELECT count(*) FROM stud where spid = ? and password = ?;"
        
        var fetchSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, fetchString, -1, &fetchSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(fetchSataement, 1, Int32(id))
            sqlite3_bind_text(fetchSataement, 2, (pwd as NSString).utf8String, -1, nil)
            
            if sqlite3_step(fetchSataement) == SQLITE_ROW {
                cnt = Int(sqlite3_column_int(fetchSataement, 0))
                
                print("\(cnt)")
            }
        }
        else {
            print("fetch statement could not be prepared")
        }
        
        sqlite3_finalize(fetchSataement)
        
        if cnt == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    func fetchid (id : Int) -> Stud {
        let fetchString = "SELECT * FROM stud WHERE spid = ?;"
        
        var fetchSataement: OpaquePointer? = nil
        
        let s = Stud(spid: 0, name: "", pwd: "", Class: "", phone: "")
        
        if sqlite3_prepare_v2(db, fetchString, -1, &fetchSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(fetchSataement, 1, Int32(id))
            
            while sqlite3_step(fetchSataement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchSataement, 0))
                let name = String(cString: sqlite3_column_text(fetchSataement, 1))
                let pwd = String(cString: sqlite3_column_text(fetchSataement, 2))
                let Class = String(cString: sqlite3_column_text(fetchSataement, 3))
                let phone = String(cString: sqlite3_column_text(fetchSataement, 4))
                
                s.spid = id
                s.name = name
                s.pwd = pwd
                s.Class = Class
                s.phone = phone
                
                print("\(id) | \(name) | \(pwd) | \(Class) | \(phone)")
                
                print("fetch row Successfully")
            }
        }
        else {
            print("fetch statement could not be prepared")
        }
        
        sqlite3_finalize(fetchSataement)
        
        return s
    }
    
    func fetchidn (id : Int) -> NoticeClass {
        let fetchString = "SELECT * FROM notice WHERE id = ?;"
        
        var fetchSataement: OpaquePointer? = nil
        
        let n = NoticeClass(id: 0, title: "", date: "", description: "")
        
        if sqlite3_prepare_v2(db, fetchString, -1, &fetchSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(fetchSataement, 1, Int32(id))
            
            while sqlite3_step(fetchSataement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchSataement, 0))
                let title = String(cString: sqlite3_column_text(fetchSataement, 1))
                let date = String(cString: sqlite3_column_text(fetchSataement, 2))
                let des = String(cString: sqlite3_column_text(fetchSataement, 3))
                
                n.id = id
                n.title = title
                n.date = date
                n.description = des
                
                print("\(id) | \(title) | \(date) | \(des)")
                
                print("fetch row Successfully")
            }
        }
        else {
            print("fetch statement could not be prepared")
        }
        
        sqlite3_finalize(fetchSataement)
        
        return n
    }
    
    func chpwd (s : Stud, completion : @escaping ((Bool) -> Void)) {
        let updateString = "UPDATE stud SET password = ? WHERE spid = ?;"
        
        var updateSataement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateString, -1, &updateSataement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(updateSataement, 1, (s.pwd as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateSataement, 2, Int32(s.spid))
            
            if sqlite3_step(updateSataement) == SQLITE_DONE {
                print("Updated row Successfully")
                completion(true)
            }
            else {
                print("could not update row")
                completion(false)
            }
        }
        else {
            print("Upadte statement could not be prepared")
            completion(false)
        }
        
        sqlite3_finalize(updateSataement)
    }
}
