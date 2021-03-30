//
//  LobbyView.swift
//  ChalkSeven
//
//  Created by jack on 2021/3/30.
//  Copyright © 2021 jack. All rights reserved.
//

import SwiftUI

struct LobbyView: View {
    @ObservedObject var lobby = LobbyViewModel()
    @State var showGame = false
    @State var showRecords = false
    @State var isNavigationBarHidden: Bool = true
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: ChalkSevenView().environmentObject(Chessboard()),
                    isActive: $showGame,
                    label: {
                        Text("")
                    }).frame(width: 0, height: 0)
                    .hidden()
                
                NavigationLink(
                    destination: RecordView().environmentObject(RecordList.shared),
                    isActive: $showRecords,
                    label: {
                        Text("")
                    }).frame(width: 0, height: 0)
                    .hidden()
                
                Spacer().frame(maxHeight:20)
                Image("logo").resizable()
                    .scaledToFit()
                    .padding(60)
                    .frame(width: 9 * 44)
                Spacer().frame(maxHeight:20)
                HStack {
                    Spacer()
                    Button(action: {
                        showGame = true
                    }){
                        Image("start_game")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 120)
                    }.offset(x: lobby.startButton_OffsetX)
                    Spacer()
                }.frame(width: 8 * 44)
                HStack {
                    Spacer()
                    Button(action: {
                        showRecords = true
                    }){
                        Image("records")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 100)
                    }.offset(x: lobby.recordsButton_OffsetX)
                    Spacer()
                }.frame(width: 8 * 44)
                Spacer().frame(maxHeight:10)
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }){
                        Image("setting")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 110)
                    }.offset(x:lobby.settingButton_OffsetX)
                    Spacer()
                }.frame(width: 8 * 44)
                Spacer()
            }.background(Image("chalkball_bg")
                            .resizable()
                            .disabled(true))
            .padding(.top,44)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response:0.8,blendDuration:1.0)) {
                        lobby.startButton_OffsetX = -40.0
                        lobby.recordsButton_OffsetX = 40.0
                        lobby.settingButton_OffsetX = -40.0
                    }
                }
            }
            .onDisappear {
                lobby.startButton_OffsetX = 1000.0
                lobby.recordsButton_OffsetX = -1000.0
                lobby.settingButton_OffsetX = 1000.0
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(isNavigationBarHidden)
            .navigationBarBackButtonHidden(isNavigationBarHidden)
            .edgesIgnoringSafeArea(.bottom)
        }.navigationViewStyle(StackNavigationViewStyle())
        
        .onAppear{
            isNavigationBarHidden = true
        }
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView()
    }
}
