// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit
import WebKit
import Tauri
import os.log
import SQLite3

struct PingArgs: Decodable {
    let value: String?
}

class SqlitePlugin: Plugin {
    var webView: WKWebView!
    var dm: DBManager!
    @objc public override func load(webview: WKWebView) {
        self.webView = webview
        self.dm = DBManager()
    }
    @objc public func ping(_ invoke: Invoke) throws {
        dm.insertUser(name: "testname", email: "testemail", password: "testpassword");
        let us = dm.getAllUsers();
        for u in us {
            if #available(iOS 14.0, *) {
                os_log("user \(u.id), \(u.name), \(u.email), \(u.password)")
            } else {
                // Fallback on earlier versions
            }
        }
        let args = try invoke.parseArgs(PingArgs.self)
        invoke.resolve(["value": args.value])
    }
}

@_cdecl("init_plugin_sqlite")
func initPlugin() -> Plugin {
    return SqlitePlugin()
}


class User{
    var id: Int
    var name: String
    var email: String
    var password: String
    var address: String
    
    init(id: Int, name: String, email: String, password: String, address: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.address = address
    }
}


class DBManager{
    init(){
        db = openDatabase()
        createUserTable()
    }
    
    let dataPath: String = "MyDB"
    var db: OpaquePointer?
    
    // Create DB
    func openDatabase()->OpaquePointer?{
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dataPath)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK{
            debugPrint("Cannot open DB.")
            return nil
        }
        else{
            print("DB successfully created.")
            return db
        }
    }
    
    // Create users table
    func createUserTable() {
        let createTableString = """
            CREATE TABLE IF NOT EXISTS User (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                email TEXT,
                password TEXT,
                address TEXT
            );
        """

        var createTableStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("User table is created successfully.")
            } else {
                print("User table creation failed.")
            }
        } else {
            print("User table creation failed.")
        }

        sqlite3_finalize(createTableStatement)
    }

    
    // Add new user with registration screen (name, email, password required.)
    // User should add his/her address later on Profile screen with updateUser method
    func insertUser(name: String, email: String, password: String) -> Bool{
//        let users = getAllUsers()
        
        // Check user email is exist in User table or not
//        for user in users{
//            if user.id == id || user.email == email{
//                return false
//            }
//        }
        
        let insertStatementString = "INSERT INTO User (name, email, password, address) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, "", -1, nil) // assign empty value to address

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("User is created successfully.")
                sqlite3_finalize(insertStatement)
                return true
            } else {
                print("Could not add.")
                return false
            }
        } else {
            print("INSERT statement is failed.")
            return false
        }
    }

    // Get all the users from User table
    func getAllUsers() -> [User] {
        let queryStatementString = "SELECT * FROM User;"
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(db,  queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                
                users.append(User(id: Int(id), name: name, email: email, password: password, address: ""))
                print("User Details:")
                print("\(id) | \(name) | \(email) | \(password) | \(address)")
            }
        } else {
            print("SELECT statement is failed.")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
   
    // Get user from User table by Email
    func getUserbyEmail(email:String) -> [User] {
        let queryStatementString = "SELECT * FROM User WHERE email = ?;"
        var queryStatement: OpaquePointer? = nil
        var user : [User] = []
        
        if sqlite3_prepare_v2(db,  queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (email as NSString).utf8String, -1, nil)
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                
                user.append(User(id: Int(id), name: name, email: email, password: password, address: address))
                print("User Details:")
                print("\(id) | \(name) | \(email) | \(password) | \(address)")
            }
        } else {
            print("SELECT statement is failed.")
        }
        sqlite3_finalize(queryStatement)
        return user
    }

    // Update user on User table
    func updateUser(name: String, address: String, email: String) -> Bool{
        let updateStatementString = "UPDATE User SET name=?, address=? WHERE email=?;"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (email as NSString).utf8String, -1, nil)

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("User updated successfully.")
                sqlite3_finalize(updateStatement)
                return true
            } else {
                print("Could not update.")
                return false
            }
        } else {
            print("UPDATE statement is failed.")
            return false
        }
    }
    
}
