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

let ballEdge: CGFloat = 50.0
let newBallDefaultY: CGFloat = -(5 * ballEdge)
let dropDuration = 0.4
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
//            DispatchQueue.main.async { [weak self] in
                self.objectWillChange.send()
//            }
        }
    }
    
    var state : BallState = .number
    {
        willSet {
//            DispatchQueue.main.async { [weak self] in
                if newValue == .null {
                        self.opacity = 0
                } else {
                    self.opacity = 1
                }
                    self.objectWillChange.send()
                
//            }
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
    }
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
        return [.null,.number].randomElement(using: &generator) ?? .null
    }

    static func random() -> BallState {
        var g = SystemRandomNumberGenerator()
        return BallState.random(using: &g)
    }
}

class Chalk: ObservableObject,Identifiable {
    let id = UUID()
    @Published var unused : Bool = true
}

class ChalkStack: ObservableObject {
    var totalCount:Int = 20
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
        self.init(totalCount: 20)
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

class Chessboard: ObservableObject {
    
    let rows: Int = 7, columns: Int = 7

    var objectWillChange = ObservableObjectPublisher()
    
    private var needBang:Bool = false
    private var scoreTime:Int = 1
    
    var chalkStack: ChalkStack = ChalkStack()
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    
    var grid: [BallModel] = [BallModel]()
    {
        willSet {
//            DispatchQueue.main.async { [weak self] in
                self.objectWillChange.send()
//            }
        }
    }
    
    var operating:Bool = false
    {
        willSet {
//            DispatchQueue.main.async { [weak self] in
                self.objectWillChange.send()
//            }
        }
    }
    
    var score:Int = 0
    {
        willSet {
//            DispatchQueue.main.async { [weak self] in
                self.objectWillChange.send()
//            }
        }
    }
    //@Published var ballMatrix:[[BallModel]] = [[BallModel]]() //= Array(repeating: Array(repeating: BallModel(), count: 7), count: 7)
    
    
   var newBall = BallModel(num: BallNumber.random())
   {
        willSet {
            objectWillChange.send()
        }
    }
    
    
    init() {
        self.grid = self.randomGrid()
        self.collapse()
        self.initChess()
        self.chalkStack.stackEmpty = rowUp
    }
    
    func rowUp() {
        
    }
    
    func initChess() {
        self.checkChessBoard()
        while needBang {
            self.bang()
            self.collapse()
            self.checkChessBoard()
        }
        self.score = 0
    }
    
    func operationChess() {
        self.checkChessBoard()
        if needBang {
            self.operationBang()
        } else {
            self.operating = false
        }
    }
    
    func operationBang() {
        self.operating = true
        self.bangWithAnimation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard (self != nil) else {
                return
            }
//            self!.objectWillChange.send()
            self!.checkChessBoard()
            if self!.needBang {
                self!.scoreTime += 1
                self!.operationBang()
            } else {
                self!.operating = false
                self!.scoreTime = 1
            }
        }

    }
    
    
    func randomGrid() -> [BallModel] {
        var grid:[BallModel] = Array(repeating: BallModel(), count: rows * columns)
        
        for i in 0...rows * columns - 1 {
            let ball = BallModel()
            grid[i] = ball
        }
        return grid
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return self.rowIndexIsValid(row: row) && self.columnIndexIsValid(column: column)
    }
    
    func rowIndexIsValid(row:Int) -> Bool {
        return row >= 0 && row < rows
    }
    
    func columnIndexIsValid(column:Int) -> Bool {
        return column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> BallModel {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    
    func singleRow(row: Int) -> [BallModel] {
        assert(rowIndexIsValid(row: row), "Index out of range")
        let singleRowBalls = self.grid[row * columns ... row * columns + columns - 1]
        return Array(singleRowBalls)
    }
    
    func singleColumn(column: Int) -> [BallModel] {
        assert(columnIndexIsValid(column: column), "Index out of range")
        let singleColumnBall = self.grid.indices.filter{ $0 % columns == column}.map{ self.grid[$0] }
        return singleColumnBall
    }
    
    func benchmarkX(offsetX:CGFloat) -> (column: Int, newX: CGFloat) {
        var offsetX = offsetX

        if offsetX > 0 {
            offsetX += ballEdge / 2
        } else {
            offsetX -= ballEdge / 2
        }
        let column = Int(offsetX) / Int(ballEdge)
        return  (column + 3, CGFloat(column) * ballEdge)
    }
    
    func generateNewBall() {
        self.newBall = BallModel(num: BallNumber.random())
    }
    
    
    func collapse() {
        for column in 0...(columns - 1) {
            self.collapseSingleColumn(column)
        }
        print("after collapse:\(self.grid)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for item in self.grid {
                item.dropOffset = 0.0
            }
        }
    }
    
    func collapseSingleColumn(_ column: Int) {
        
//        for i in (0...(rows - 2)).reversed() {
//            for j in (0...(rows - i - 2)).reversed() {
//                if self[j, column].state != .null {
////                    let temp = self[j,column]
////                    self[j,column] = self[j+1,column]
////                    self[j+1,column] = temp
//                    let temp = BallModel()
//                    temp.copyNewBall(self[j,column])
//                    self[j,column].copyNewBall(self[j+1,column])
//                    self[j+1,column].copyNewBall(temp)
//                }
//            }
//        }
        
        let singleColumnArray = self.singleColumn(column: column)
        let numberArray = singleColumnArray.filter{$0.state == .number}
        let numberIndexArray = singleColumnArray.indices.filter{singleColumnArray[$0].state == .number}
        for i in 0...(rows - 1) {
            let numCount = numberArray.count
            if numberArray.count > i {
                let numberIndex = numCount - i - 1
                let rowIndex = rows - i - 1
//                DispatchQueue.main.async {
                    withAnimation(Animation.linear(duration: 0.4)) {
                         numberArray[numberIndex].dropOffset = ballEdge * CGFloat((rowIndex - numberIndexArray[numberIndex]))
                    }
//                }
                self[rowIndex,column].copyNewBall(numberArray[numberIndex])
            } else {
                self[rows - i - 1, column].state = .null
            }
        }
    }
    
    func checkChessBoard() {
        self.allColumnCheck()
        self.allRowCheck()
        for item in self.grid {
            print(item)
        }
    }
    
    func allColumnCheck() {
        for column in 0...columns - 1 {
            singleColumnCheck(column)
        }
    }
    
    func singleColumnCheck(_ column: Int) {
        
        let singleColumnBalls = self.singleColumn(column: column)
        print("singleColumn:\(singleColumnBalls.filter{$0.state == .number})")
        let numCount = singleColumnBalls.filter{$0.state != .null}.count
        let needBangBalls = singleColumnBalls.filter{$0.state == .number && $0.num.rawValue == numCount }
        print("need Bang:\(needBangBalls)")
        if needBangBalls.count > 0 {
//            withAnimation(Animation.easeOut(duration: 0.6)) {
                 let _ = needBangBalls.map{ $0.shouldBang = true }
//            }
           self.needBang = true
        }
    }
    
    func allRowCheck() {
        for row in 0...rows - 1 {
            singleRowCheck(row)
        }
    }
    
    func singleRowCheck(_ row: Int) {
        let singleRowBalls = self.singleRow(row: row)
        let continuousArray = singleRowBalls.split{$0.state == .null}
        for item in continuousArray {
            let needBangBalls = item.filter{$0.state == .number && $0.num.rawValue == item.count}
            if needBangBalls.count > 0 {
//                withAnimation(Animation.easeOut(duration: 0.6)) {
                    let _ = needBangBalls.map{ $0.shouldBang = true }
//                }
                self.needBang = true
            }
        }
    }
    
    
    func bangWithAnimation() {
        DispatchQueue.main.async {
            withAnimation(Animation.easeIn(duration: 0.3)) {
                for item in self.grid {
                    if item.shouldBang {
                        item.ballScale = 3.0
                        item.opacity = 0
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            for item in self!.grid {
                if item.shouldBang {
                    item.ballScale = 1.0
                }
            }
            self?.bang()
            self?.collapse()
        }
    }
    
    func bang() {
        for item in self.grid {
            if item.shouldBang {
                item.state = .null
                item.shouldBang = false
                self.score += basicScore * self.scoreTime
            }
        }
        self.needBang = false
    }
    
    func dropNewBall(_ column:Int) -> CGFloat {
        self.operating = true
        let singleColumnBalls = self.singleColumn(column: column)
        print("dropSingleColumn:\(singleColumnBalls.filter{$0.state == .number})")
        let numCount = singleColumnBalls.filter{$0.state != .null}.count
        if numCount < rows {
            withAnimation(Animation.linear.delay(0.6)) {
                self.chalkStack.useChalk()
                self[rows - numCount - 1, column].copyNewBall(self.newBall)
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + dropDuration + 0.2) { [weak self] in
                self?.operationChess()
                self?.newBall.generateNewBall()
                print("new ball:\(String(describing: self?.newBall))")
            }
            print("drop row:\(rows - numCount - 1)")
            return CGFloat((rows - numCount + 1)) * ballEdge
        }
        return 0;
    }
}
