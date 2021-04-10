//
//  ButtonType.swift
//  Example
//
//  Created by Pavel Moslienko on 10.04.2021.
//  Copyright © 2021 moslienko. All rights reserved.
//

import Foundation

enum ButtonType: CaseIterable {
    case date, time, darkThemeDate, fruit, miltiItem
    
    var title: String {
        switch self {
        case .date:
            return "Select date"
        case .time:
            return "Select time"
        case .darkThemeDate:
            return "Select date (Dark theme)"
        case .fruit:
            return "Select fruit"
        case .miltiItem:
            return "Select multi rows"
        }
    }
}
