//
//  HabbitModel.swift
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/20/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//

import Foundation

struct HabitModel {
    
    private enum Constants {
        static let defaultText = "None"
    }
    
    var name: String
    var type: Int16
    var motivation: String
    var dates: [String]
    
    init(withHabitDB value: HabitDB) {
        name = value.habitNameDB ?? Constants.defaultText
        type = value.habitTypeDB
        dates = value.datesDB ?? []
        motivation = value.habitsMotivationDB ?? Constants.defaultText
    }
    
    init(name: String?, type: Int16, motivation: String?, dates: [String]?) {
        self.name = name ?? Constants.defaultText
        self.type = type
        self.dates = dates ?? []
        self.motivation = motivation ?? Constants.defaultText
    }
}
