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
}

struct Ball_Previews: PreviewProvider {
    static var previews: some View {
        Ball().environmentObject(BallModel.ballExample).previewLayout(.fixed(width: ballEdge, height: ballEdge))
    }
}
