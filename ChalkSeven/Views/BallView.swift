//
//  BallView.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/13.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct Ball:View {
    @EnvironmentObject var ball: BallModel
    
    var body: some View {
        Circle()
        .overlay(
            ZStack {
                Image("ball_stroke").resizable().padding(-3)
                Text(ballText()).font(Font.custom("Eraser Dust", size: 40))
                    .foregroundColor(.white)
                    .opacity(0.95)
            }.padding(2)
        )
            .foregroundColor(ballColor())
            .frame(width:ballEdge, height:ballEdge)
            .opacity(self.ball.opacity)
            .scaleEffect(self.ball.ballScale)
            .offset(y: self.ball.dropOffset)
            .opacity(0.90)
    }
    

    
    func ballText() -> String {
        switch self.ball.state {
        case .number:
            return String(self.ball.num.rawValue)
        case .solid:
            return "S"
        case .breaking:
            return "?"
        case .null:
            return ""
        }
    }
    
    func ballColor() -> Color {
        if self.ball.state == .number {
            switch self.ball.num {
            case .one:
                return .orange
            case .two:
                return .green
            case .three:
                return .yellow
            case .four:
                return .pink
            case .five:
                return .blue
            case .six:
                return .purple
            case .seven:
                return .red
            }
        } else {
            return .gray
        }
    }
}

struct Ball_Previews: PreviewProvider {
    static var previews: some View {
        Ball().environmentObject(BallModel.ballExample).previewLayout(.fixed(width: ballEdge, height: ballEdge))
    }
}
