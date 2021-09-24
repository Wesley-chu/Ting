//
//  Account.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/7/13.
//

import Foundation
import KeychainAccess


class Account {
    static let shared = Account()
    let keychain = Keychain()
    let encryption = EncryptionRSA()
    
    public var id: String? {
        didSet{
            keychain["id"] = id
        }
    }
    public var password: String? {
        didSet{
            setUserDefaults(password: password)
        }
    }
    
    private init(){
        let getPassword = encryption.decrypt(text: UserDefaults.standard.string(forKey: "user"))
        id = keychain["id"]
        password = getPassword
    }
    
    public func logout(){
        id = nil
        password = nil
    }
    
    private func setUserDefaults(password:String?){
        UserDefaults.standard.setValue(encryption.encrypt(text: password), forKey: "user")
    }
    
    
    
}
