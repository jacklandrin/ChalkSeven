//
//  ChessboardModel.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/13.
//  Copyright © 2020 jack. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class Chessboard: ObservableObject {
    
    let rows: Int = 7, columns: Int = 7

    var objectWillChange = ObservableObjectPublisher()
    
    private var needBang:Bool = false
    private var shouldRowUp: Bool = false
    
    var scoreTime:Int = 1
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    var gameOver:Bool = false
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    var level: Int = 1
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    var chalkStack: ChalkStack = ChalkStack()
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    
    var grid: [BallModel] = [BallModel]()
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    var operating:Bool = false
    {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    var score:Int = 0
    {
        willSet {
            self.objectWillChange.send()
        }
    }

    
    
   var newBall = BallModel(num: BallNumber.random())
   {
        willSet {
            objectWillChange.send()
        }
   }
    
    var outRangeBalls = [BallModel]()
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        self.outRangeBalls = self.initOutRangeBalls()
        self.createChessBoard()
        self.chalkStack.stackEmpty = {[weak self] in
            self?.shouldRowUp = true
        }
    }
    
    
    /// initialize the chessboard
    func createChessBoard() {
        self.level = 1
        self.grid = self.randomGrid()
        self.cleanOutRangeBalls()
        print("init grid:\(self.grid)")
        self.collapse()
        self.prepareToStart()
        self.operating = false
    }
    
    func initOutRangeBalls() -> [BallModel]{
        var outRangeBallsTemp = Array(repeating: BallModel(num: .one, state: .null), count: columns)
        for index in 0..<columns {
            let item = BallModel(num: .one, state: .null)
            item.opacity = 0
            outRangeBallsTemp[index] = item
        }
        return outRangeBallsTemp
    }
    
    func cleanOutRangeBalls() {
        for item in self.outRangeBalls {
            item.state = .null
        }
    }
    
    func rowUp() -> Bool {
        var detectOutRange = false
        
        for column in 0...columns - 1 {
            if self.singleColumnRowUp(column) == true {
                detectOutRange = true
            }
        }
        print("detectOutRange\(detectOutRange)")
        self.shouldRowUp = false
        if !detectOutRange {
            self.level += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.operationChess()
            }
        } else {
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.gameOver = true
            }
        }
        return detectOutRange
    }
    
    func singleColumnRowUp(_ column: Int) -> Bool {
        var outOfRange = false
        let singleColumnBalls = self.singleColumn(column: column)
        if singleColumnBalls[0].state != .null {
            outOfRange = true
        }
//        withAnimation(.linear) {
            self.outRangeBalls[column].copyNewBall(singleColumnBalls[0])
            for i in 0...rows - 2 {
                singleColumnBalls[i].copyNewBall(singleColumnBalls[i + 1])
            }
//        }
        singleColumnBalls[rows - 1].state = .solid
        
        return outOfRange
    }
    
    func prepareToStart() {
        self.checkChessBoard()
        while needBang {
            self.checkSolidBall()
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
            if self.shouldRowUp {
                if self.rowUp() == true {
                    return
                }
            } else {
                self.operating = false
            }
        }
    }
    
    func operationBang() {
        self.operating = true
        self.checkSolidBallWithAnimation()
        self.bangWithAnimation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard (self != nil) else {
                return
            }

            self!.checkChessBoard()
            if self!.needBang {
                withAnimation(.spring()) {
                     self!.scoreTime += 1
                }
                self!.operationBang()
            } else { // banging ends
                if self!.shouldRowUp {
                    if self!.rowUp() == true {
                        return
                    }
                }else {
                    self!.operating = false
                    self?.checkGridFull()
                }
                withAnimation(.spring()) {
                    self!.scoreTime = 1
                }
                    
            }
        }

    }
    
    func checkGridFull() {
        let numArray = self.grid.filter{ $0.state != .null }
        
        if numArray.count == self.rows * self.columns {
            self.gameOver = true
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
    
    
    func checkSolidBall() {
        let shouldBangIndexArray = self.grid.indices.filter{ self.grid[$0].shouldBang == true }
        for index in shouldBangIndexArray {
            //above
            if index >= columns {
                let aboveIndex = index - columns
                self.changeSolidBall(index: aboveIndex)
            }
            //blow
            if index < columns * (rows - 1) {
                let blowIndex = index + columns
                self.changeSolidBall(index: blowIndex)
            }
            //left
            if index % rows != 0 {
                let leftIndex = index - 1
                self.changeSolidBall(index: leftIndex)
            }
            
            //right
            if index % rows != columns - 1 {
                let rightIndex = index + 1
                self.changeSolidBall(index: rightIndex)
            }
        }
        print("checkedSolid:\(self.grid)")
    }
    
    func changeSolidBall(index: Int) {
        if self.grid[index].state == .solid {
            self.grid[index].state = .breaking
        } else if self.grid[index].state == .breaking {
            self.grid[index].num = BallNumber.random()
            self.grid[index].state = .number
        }
    }
    
    func checkSolidBallWithAnimation() {
        withAnimation(Animation.easeOut) {
            self.checkSolidBall()
        }
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
        
        let singleColumnArray = self.singleColumn(column: column)
        let numberArray = singleColumnArray.filter{$0.state != .null}
        let numberIndexArray = singleColumnArray.indices.filter{singleColumnArray[$0].state != .null}
        for i in 0...(rows - 1) {
            let numCount = numberArray.count
            if numberArray.count > i {
                let numberIndex = numCount - i - 1
                let rowIndex = rows - i - 1
                    withAnimation(Animation.linear(duration: 0.4)) {
                         numberArray[numberIndex].dropOffset = ballEdge * CGFloat((rowIndex - numberIndexArray[numberIndex]))
                    }
                self[rowIndex,column].copyNewBall(numberArray[numberIndex])
            } else {
                self[rows - i - 1, column].state = .null
            }
        }
    }
    
    func checkChessBoard() {
        self.allColumnCheck()
        self.allRowCheck()
        print("checkedBang:\(self.grid)")
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
            withAnimation(Animation.easeOut.delay(dropDuration + 0.2)) {
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
        } else {
            self.operating = false
            self.checkGridFull()
        }
        return 0;
    }
}
