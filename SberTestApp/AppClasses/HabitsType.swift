//
//  HabitsType.swift
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/14/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//

import UIKit


enum HabitsType: Int16 {
    case relaxing
    case intelligently
    case sporty
    case healthy
    case nonType
    
    var color: UIColor {
        switch self {
            case .healthy:
                return .yellow
            case .sporty:
                return .red
            case .intelligently:
                return .blue
            case .relaxing:
                return .green
            case .nonType:
                return .black
        }
    }
    
    init(rawValue value: Int16) {
        switch value {
            case 0:
                self = .relaxing
            case 1:
                self = .intelligently
            case 2:
                self = .sporty
            case 3:
                self = .healthy
            default:
                self = .sporty
        }
    }
}
