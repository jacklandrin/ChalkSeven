//
//  RecordModel.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/13.
//  Copyright © 2020 jack. All rights reserved.
//

import Foundation
import Combine

struct Record: Codable, Identifiable, Hashable {
    let id = UUID()
    var score : Int
    var date: String
}


class RecordList: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    static let shared = RecordList()
    
    @UserDefaultValue(key: "records", defaultValue: [])
    var records:[Record]
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    func createNewRecord(score: Int)  {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let newRecord = Record(score: score, date: formatter.string(from: now))
        self.records.append(newRecord)
    }
}

@propertyWrapper
struct UserDefaultValue<Value: Codable> {
    
    let key: String
    let defaultValue: Value
    
    var wrappedValue: Value {
        get {
            let data = UserDefaults.standard.data(forKey: key)
            let value = data.flatMap { try? JSONDecoder().decode(Value.self, from: $0) }
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
