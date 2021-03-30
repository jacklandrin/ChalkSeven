//
//  LobbyViewModel.swift
//  ChalkSeven
//
//  Created by jack on 2021/3/30.
//  Copyright © 2021 jack. All rights reserved.
//

import Foundation
import UIKit

class LobbyViewModel: ObservableObject {
    @Published var startButton_OffsetX :CGFloat = 1000.0
    @Published var recordsButton_OffsetX :CGFloat = -1000.0
    @Published var settingButton_OffsetX :CGFloat = 1000.0
}
