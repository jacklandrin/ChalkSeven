//
//  SettingView.swift
//  ChalkSeven
//
//  Created by jack on 2021/3/30.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var musicHelp = MusicHelper.sharedHelper
    var body: some View {
        VStack {
            Spacer().frame(maxHeight:30)
            HStack {
                Spacer().frame(width:50)
                Text("Background sound:")
                    .font(Font.custom("Eraser Dust",size: 24))
                    .foregroundColor(.white)
                Button(action: {
                    musicHelp.canPlayBGM.toggle()
                }){
                    Image(musicHelp.canPlayBGM ? "sound" : "sound_cross")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                Spacer()
            }.frame(width: 9 * 44)
            HStack {
                Spacer().frame(width:50)
                Text("Effect sound:")
                    .font(Font.custom("Eraser Dust",size: 24))
                    .foregroundColor(.white)
                Button(action: {
                    musicHelp.canPlayEM.toggle()
                }){
                    Image(musicHelp.canPlayEM ? "sound" : "sound_cross")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                Spacer()
            }.frame(width: 9 * 44)
            Spacer()
        }.background(Image("chalkball_bg")
                        .resizable()
                        .disabled(true))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
