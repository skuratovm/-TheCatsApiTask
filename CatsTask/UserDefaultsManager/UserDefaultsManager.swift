//
//  UserDefaultsManager.swift
//  CatsTask
//
//  Created by Mikhail Skuratov on 24.01.22.
//

import Foundation

class DataBase{
    static let shared = DataBase()
    let defaults = UserDefaults.standard

    var cats:[CatsModelElement]? {
        get {
            if let data = defaults.value(forKey: "data") as? Data{
                return try! PropertyListDecoder().decode([CatsModelElement].self, from: data)
            } else {
                return [CatsModelElement]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue){
                defaults.set(data,forKey: "data")
            }
        }
    }
    func saveSchedule(result: CatsModelElement?,row: Int){

        cats?.insert(result!, at: 0)
    }
    func deleteSchedule(result: CatsModelElement?,row: Int){
        cats?.remove(at: row)
        
    }
}
