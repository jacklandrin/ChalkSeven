//
//  ContentView.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/11.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI


struct Ball:View {
    @EnvironmentObject var ball: BallModel
//    @State var scale: CGFloat = 1.0
//    @State var opacity: Double = 1.0
    
    var body: some View {
        Circle()
        .overlay(
            ZStack {
                Circle().stroke(Color.black, lineWidth:1)
                Text(ballText()).font(Font.system(size: 38))
                    .foregroundColor(.white)
            }
        )
            .foregroundColor(.blue)
            .frame(width:ballEdge, height:ballEdge)
            .opacity(self.ball.opacity)
            .scaleEffect(self.ball.ballScale)
            .offset(y: self.ball.dropOffset)
    }
    

    
    func ballText() -> String {
//        withAnimation{
            switch self.ball.state {
            case .number:
                return String(self.ball.num.rawValue)
            case .solid:
                return "?"
            case .breaking:
                return "b"
            case .null:
                return ""
            }
    }
        
//    }
}

struct BackGrid: View {
    @EnvironmentObject var backgrid: BackGridModel
    var columnTap: (Int) -> Void = { _ in }
    
    
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                ForEach (0...6, id: \.self) { row in
                    Rectangle().overlay(
                        Rectangle().stroke(Color.yellow, lineWidth: 1)
                    )
                        .foregroundColor(self.backgrid.currentRow == row ? .gray : .clear)
                        .frame(width:7 * ballEdge, height: ballEdge)
                }
            }
            
            HStack(spacing:0) {
                ForEach(0...6, id: \.self) { column in
                    Rectangle().overlay(
                        Rectangle().stroke(Color.yellow, lineWidth: 1)
                    )
                        .foregroundColor(self.backgrid.currentColumn == column ? Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.5) : .clear)
                        .frame(width:ballEdge,height: 7 * ballEdge)
                        .animation(.spring())
                        .onTapGesture {
                            print("tap column:\(column)")
                            self.columnTap(column)
                            self.backgrid.currentColumn = column
                            DispatchQueue.main.asyncAfter(deadline: .now() + dropDuration) {
                                self.backgrid.currentColumn = 7
                            }
                    }
                }
            }
        }
    }
}

struct ChalkSevenView: View {
    @EnvironmentObject var chessboard : Chessboard
    @State var newBallOffsetX: CGFloat = 0.0
    @State var lastNewBallOffsetX: CGFloat = 0.0
    @State var newBallOffsetY: CGFloat = newBallDefaultY
    var backgrid = BackGridModel()
    
    var body: some View {
        VStack {
            Text("score:\(self.chessboard.score)").font(Font.system(size: 60))
            ZStack(alignment: .center) {
                BackGrid(columnTap: { column in
                    self.newBallOffsetX = CGFloat((column - 3)) * ballEdge
                    self.lastNewBallOffsetX = self.newBallOffsetX
                    self.dropBall(column)
                }).environmentObject(backgrid)
                    .frame(width:ballEdge * 7, height: ballEdge * 7)
                .disabled(self.chessboard.operating)
                VStack(spacing:0) {
                    ForEach (0...6, id: \.self) { row in
                            HStack(spacing:0) {
                            ForEach (0...6, id: \.self) { column in
                                Ball().environmentObject(self.chessboard[row, column])
                                .allowsHitTesting(false)
                            }
                        }
                    }
                }.allowsHitTesting(false)
                    .animation(.spring())
                Ball().environmentObject(self.chessboard.newBall).offset(x: self.newBallOffsetX ,y: self.newBallOffsetY)
            }.padding(.top, 100)
            .gesture(DragGesture().onChanged{ gesture in
                let moveX = gesture.translation.width * 1.5 + self.lastNewBallOffsetX
                if abs(moveX) <= 3 * ballEdge {
                    self.moveNewBall(moveX)
                }
            }
            .onEnded{ _ in
                self.moveNewBall(self.newBallOffsetX)
                self.lastNewBallOffsetX = self.newBallOffsetX
        })
        }
            
        
    }
    
    func moveNewBall(_ offsetX:CGFloat) {
        withAnimation(.easeOut) {
            let benchmarkX = self.chessboard.benchmarkX(offsetX: offsetX)
            self.newBallOffsetX = benchmarkX.newX
            self.backgrid.currentColumn = benchmarkX.column
            
        }
        
    }
    
    func dropBall(_ column:Int) {
        let offsetY = self.chessboard.dropNewBall(column)
        withAnimation(Animation.linear(duration: dropDuration)) {
            self.newBallOffsetY = newBallDefaultY + offsetY
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.newBallOffsetY = newBallDefaultY
            self.newBallOffsetX = 0.0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChalkSevenView().environmentObject(Chessboard())
    }
}
