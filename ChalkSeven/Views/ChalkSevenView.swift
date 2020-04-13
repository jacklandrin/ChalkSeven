//
//  ContentView.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/11.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI



struct ChalkSevenView: View {
    @EnvironmentObject var chessboard : Chessboard
    @State var newBallOffsetX: CGFloat = 0.0
    @State var lastNewBallOffsetX: CGFloat = 0.0
    @State var newBallOffsetY: CGFloat = newBallDefaultY
    
    var backgrid = BackGridModel()
    
    var body: some View {
        NavigationView {
            VStack {
               HStack {
                NavigationLink(destination: RecordView().environmentObject(RecordList.shared)) {
                       Image(systemName: "doc.plaintext")
                           .imageScale(.large)
                   }.offset(x: 3 * ballEdge)
               }
               Spacer()
                VStack(alignment: .leading) {
                    Text("Score:\(self.chessboard.score)").font(Font.system(size: 60))
                    Text("Level:\(self.chessboard.level)").font(Font.system(size: 20)).opacity(0.95)
                }
               
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
                           }.allowsHitTesting(false)
                       }
                   }.allowsHitTesting(false)
                       .animation(.spring())
                   Ball().environmentObject(self.chessboard.newBall).offset(x: self.newBallOffsetX ,y: self.newBallOffsetY)
               }.padding(.top, 100)
               
               HStack {
                   Spacer()
                   ForEach(self.chessboard.chalkStack.chalks, id: \.id) {chalk in
                       ChalkView().environmentObject(chalk)
                   }
                   Spacer()
               }.padding(.top, 40)
               Spacer()
           }
           .simultaneousGesture(DragGesture().onChanged{ gesture in
                   let moveX = gesture.translation.width * 1.5 + self.lastNewBallOffsetX
                   if abs(moveX) <= 3 * ballEdge {
                       self.moveNewBall(moveX)
                   }
               }
               .onEnded{ _ in
                   self.moveNewBall(self.newBallOffsetX)
                   self.lastNewBallOffsetX = self.newBallOffsetX
           })
               .alert(isPresented: .init(get: {self.chessboard.gameOver}, set: {self.chessboard.gameOver = $0 })) {
                   Alert(title: Text("Game Over"), message: Text("Try again?"), dismissButton: .default(Text("Yes"), action: {
                       withAnimation(.easeInOut) {
                        RecordList.shared.createNewRecord(score: self.chessboard.score, level: self.chessboard.level)
                           self.chessboard.createChessBoard()
                       }
                   }))
               }
        }.navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
       
        
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
