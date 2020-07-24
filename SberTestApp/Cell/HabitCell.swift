//
//  HabitCell.swift
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/14/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//

import UIKit

final class HabitCell: UITableViewCell {
    
    private enum Constants {
        static let heightAnchor: CGFloat = 80
        static let leadingAnchor: CGFloat = 50
    }
    
    private let habitTitleLabel = UILabel()
    private let habitTypeView = UIView()
    private let circle = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupHabitTypeView()
        setupHabitTitleLabel()
        setHabitTypeViewConstaints()
        setHabitTitleLabelConstaints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubview(habitTitleLabel)
        addSubview(habitTypeView)
    }
    
    func set(habit: HabitDB){
        let habitType = HabitsType(rawValue: habit.habitTypeDB)
        let color = habitType.color
        
        circle.backgroundColor = color
        habitTitleLabel.text = habit.habitNameDB
    }
    
    private func setupHabitTitleLabel() {
        habitTitleLabel.numberOfLines = 0
        habitTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupHabitTypeView() {
        
        circle.layer.cornerRadius = circle.frame.height / 2.0
        circle.layer.masksToBounds = true
        
        habitTypeView.addSubview(circle)
    }
    
    private func setHabitTypeViewConstaints() {
        habitTypeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitTypeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            habitTypeView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingAnchor),
            habitTypeView.heightAnchor.constraint(equalToConstant: Constants.heightAnchor),
            habitTypeView.widthAnchor.constraint(equalToConstant: frame.size.width / 2.0)
        ])
    }
    
    private func setHabitTitleLabelConstaints(){
        habitTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            habitTitleLabel.heightAnchor.constraint(equalToConstant: Constants.heightAnchor),
            habitTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            habitTitleLabel.widthAnchor.constraint(equalToConstant: frame.size.width / 2.0)
        ])
    }
    
}
