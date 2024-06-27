//
//  UserDefaultProtocol.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/27/24.
//

import Foundation

protocol UserDefaultProtocol {
    func setStringData(val: String, key: String)
    func setBooleanData(val: Bool, key: String)
    func setIntData(val: Int, key: String)
    func setData(val: Any, key: String)
    
    func getStringData(key: String) -> String?
    func getBooleanData(key: String, defaultValue: Bool) -> Bool
    func getIntData(key: String, defautValue: Int) -> Int
    func getData(key: String, defaultValue: Any?) -> Any?
    
    func removeData(key: String)
}

extension UserDefaultProtocol {
    func setStringData(val: String, key: String) {
        UserDefaults.standard.set(val, forKey: key)
    }
    
    func setBooleanData(val: Bool, key: String) {
        UserDefaults.standard.set(val, forKey: key)
    }
    
    func setData(val:Any, key: String) {
        UserDefaults.standard.set(val, forKey: key)
    }
    
    func setIntData(val: Int, key: String) {
        UserDefaults.standard.set(val, forKey: key)
    }
    
    func getStringData(key: String) -> String? {
        let saved = (UserDefaults.standard.value(forKey: key) as? String)
        return saved
    }
    
    func getBooleanData(key: String, defaultValue: Bool = false) -> Bool {
        let saved = UserDefaults.standard.value(forKey: key) as? Bool
        return saved ?? defaultValue
    }
    
    func getData(key: String, defaultValue: Any?) -> Any? {
        let saved = UserDefaults.standard.value(forKey: key)
        return saved ?? defaultValue
    }
    
    func getIntData(key: String, defautValue: Int = 0) -> Int {
        let saved = UserDefaults.standard.value(forKey: key) as? Int
        return saved ?? defautValue
    }
    
    func removeData(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
