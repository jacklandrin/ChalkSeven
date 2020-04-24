//
//  BackGridView.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/13.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct BackGrid: View {
    @EnvironmentObject var backgrid: BackGridModel
    var columnTap: (Int) -> Void = { _ in }
    
    
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                ForEach (0...6, id: \.self) { row in
                    Rectangle().overlay(
                        Rectangle().stroke(Color.yellow, lineWidth: 2)
                    )
                        .foregroundColor(self.backgrid.currentRow == row ? .gray : .clear)
                        .frame(width:7 * ballEdge, height: ballEdge)
                }
            }
            
            HStack(spacing:0) {
                ForEach(0...6, id: \.self) { column in
                    Rectangle().overlay(
                        Rectangle().stroke(Color.yellow, lineWidth: 1).opacity(0.9)
                    )
                        .foregroundColor(self.backgrid.currentColumn == column ? Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.5) : .clear)
                        .frame(width:ballEdge,height: 7 * ballEdge)
                        .animation(.spring())
                    .contentShape(Rectangle())
                        .simultaneousGesture(TapGesture(count: 1)
                            .onEnded {
                                print("tap column:\(column)")
                                self.columnTap(column)
                                self.backgrid.currentColumn = column
                                DispatchQueue.main.asyncAfter(deadline: .now() + dropDuration) {
                                    self.backgrid.currentColumn = 7
                                }
                        })
                }
            }
        }
    }
}


struct BackGrid_Previews: PreviewProvider {
    static var previews: some View {
        BackGrid().environmentObject(BackGridModel()).previewLayout(.fixed(width:7 * ballEdge, height: 7 * ballEdge))
    }
}
