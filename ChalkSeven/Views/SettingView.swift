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
            Text("Statement")
                .font(.title)
                .foregroundColor(.white)
                .padding(10)
            Text("Thank Anh, mixkit and freesound for effect sounds. The background music created by Anh. The other effect sounds come from these sources:\rhttps://mixkit.co/free-sound-effects/game/?page=2 \rhttps://freesound.org/people/cameronmusic/sounds/138410/\rhttps://freesound.org/people/ash_rez/sounds/518887/\rhttps://freesound.org/people/Mr._Fritz_/sounds/544015/").foregroundColor(.white)
                .padding(.horizontal,26)
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
