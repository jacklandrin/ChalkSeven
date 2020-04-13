//
//  ChalkStack.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/13.
//  Copyright © 2020 jack. All rights reserved.
//

import Foundation
import Combine

class Chalk: ObservableObject,Identifiable {
    let id = UUID()
    @Published var unused : Bool = true
}

let chalkStackCount = 20

class ChalkStack: ObservableObject {
    var totalCount:Int = chalkStackCount
    var stackEmpty: () -> Void = {}
    @Published var chalks = [Chalk]()
    @Published var currentChalk: Int = 0
    
    init(totalCount: Int) {
        self.totalCount = totalCount
        self.chalks = Array(repeating: Chalk(), count: totalCount)
        for i in 0...self.totalCount - 1 {
            self.chalks[i] = Chalk()
        }
    }
    
    convenience init() {
        self.init(totalCount: chalkStackCount)
    }
    
    func indexIsValid(index:Int) -> Bool {
        return index >= 0 && index < totalCount
    }
    
    subscript(index: Int) -> Chalk {
        get {
            assert(indexIsValid(index: index), "Index out of range")
            return chalks[index]
        }
        set {
            assert(indexIsValid(index: index), "Index out of range")
            chalks[index] = newValue
        }
    }
    
    func useChalk() {
        self.currentChalk += 1
        self[self.totalCount - self.currentChalk].unused = false
        if self.currentChalk == self.totalCount {
            self.stackEmpty()
            self.currentChalk = 0
            for item in self.chalks {
                item.unused = true
            }
        }
        
    }
}

