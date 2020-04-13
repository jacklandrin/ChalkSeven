//
//  RecordView.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/13.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI


struct RecordView: View {
    @EnvironmentObject var recordList: RecordList
    var body: some View {
        List{
            ForEach (recordList.records.indices) { index in
                HStack {
                    Image(systemName: "star.circle.fill").foregroundColor(self.recordList.championIndex == index ? .red : nil)
                    Text("\(self.recordList.records[index].score)")
                    Text("(\(self.recordList.records[index].level))").opacity(0.90)
                    Spacer()
                    Text(self.recordList.records[index].date)
                }
            }
        }.navigationBarTitle(Text("Record List"))
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView().environmentObject(RecordList.shared)
    }
}
