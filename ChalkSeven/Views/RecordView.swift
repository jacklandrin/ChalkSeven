//
//  RecordView.swift
//  ChalkSeven
//
//  Created by jack on 2020/4/13.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

let testRecord = [Record(score: 1254, date: "2020/1/30 14:23")]


struct RecordView: View {
    var body: some View {
        List(RecordList.shared.records){ record in
            HStack {
                Image(systemName: "star.circle.fill")
                Text("\(record.score)")
                Spacer()
                Text(record.date)
            }
        }.navigationBarTitle(Text("Record List"))
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
