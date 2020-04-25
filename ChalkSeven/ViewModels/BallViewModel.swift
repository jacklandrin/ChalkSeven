//
//  BallViewModel.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/11.
//  Copyright © 2020 jack. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

let ballEdge: CGFloat = 44.0
let newBallDefaultY: CGFloat = -(5 * ballEdge)
let dropDuration = 0.3
let basicScore = 7

class BackGridModel: ObservableObject {
    @Published var currentColumn: Int = 7
    @Published var currentRow:Int = 7
}

class BallModel: ObservableObject, Identifiable {
    let id = UUID()
    
    convenience init() {
        let num = BallNumber.random()
        let state = BallState.random()
        self.init(num: num, state: state)
    }
    
    init(num: BallNumber, state: BallState = .number) {
        self.num = num
        self.state = state
    }

    
    var num : BallNumber = .three
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    var state : BallState = .number
    {
        willSet {
            if newValue == .null {
                self.opacity = 0
            } else {
                self.opacity = 1
            }
            self.objectWillChange.send()
        }
    }
    
    var shouldBang : Bool = false
    {
        willSet {
                self.objectWillChange.send()

        }
    }
   
    var dropOffset : CGFloat = 0.0
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
   var ballScale : CGFloat = 1.0
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
   var opacity: Double = 1.0
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    let objectWillChange = ObservableObjectPublisher()
}

extension BallModel : CustomDebugStringConvertible {
    var debugDescription: String {
        return "num:\(self.num)  state:\(self.state)  shouldBang:\(self.shouldBang) dropOffset:\(self.dropOffset)"
    }
}

extension BallModel {
    func copyNewBall(_ newBall: BallModel) {
           self.num = newBall.num
           self.state = newBall.state
           self.shouldBang = newBall.shouldBang
            DispatchQueue.main.async { [weak self] in
                self?.objectWillChange.send()
            }
       }
    
    func generateNewBall() {
        self.num = BallNumber.random()
        self.state = BallState.randomNewBall()
    }
}

extension BallModel {
    static let ballExample = BallModel()
}

class NewBallModel: BallModel {
    var selectedColumn : Int = 4
}

enum BallNumber: Int, CaseIterable {
    case one = 1, two, three, four, five, six, seven
    
    static func random <G: RandomNumberGenerator>(using generator: inout G) -> BallNumber {
        return BallNumber.allCases.randomElement(using: &generator) ?? .one
    }

    static func random() -> BallNumber {
        var g = SystemRandomNumberGenerator()
        return BallNumber.random(using: &g)
    }
}


enum BallState: CaseIterable {
    case null, number , solid, breaking
    
    static func random <G: RandomNumberGenerator>(using generator: inout G) -> BallState {
        return [.null,.null,.number,.number,.number,.solid,.breaking].randomElement(using: &generator) ?? .null
    }
    
    static func randomNewBall <G: RandomNumberGenerator>(using generator: inout G) -> BallState {
        return [.number,.number,.number,.number,.solid].randomElement(using: &generator) ?? .null
    }
    
    static func random() -> BallState {
        var g = SystemRandomNumberGenerator()
        return BallState.random(using: &g)
    }
    
    static func randomNewBall() -> BallState {
        var g = SystemRandomNumberGenerator()
        return BallState.randomNewBall(using: &g)
    }
}

