//
//  ChalkView.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/13.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct ChalkView:View {
    @EnvironmentObject var chalk : Chalk
    var body: some View {
        Circle().overlay(
            Circle()
                .stroke(Color.orange,lineWidth: 2)
        )
            .foregroundColor(self.chalk.unused ? .orange : .clear)
            .frame(width:10, height: 10)
    }
}

struct ChalkView_Previews: PreviewProvider {
    static var previews: some View {
        ChalkView().environmentObject(Chalk()).previewLayout(.fixed(width: 10, height: 10))
    }
}
