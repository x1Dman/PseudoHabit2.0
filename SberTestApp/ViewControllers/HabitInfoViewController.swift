//
//  HabitInfoViewController.swift
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/15/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//

import FSCalendar
import UIKit

final class HabitInfoViewController: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    enum Constants {
        static let buttonTitle = "Accept Habit"
        static let calendarSize: CGFloat = 200
        static let fontSize: CGFloat = 20
        static let height: CGFloat = 4
        static let alpha: CGFloat = 0.5
        static let buttonHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 200
        static let buttonMult: CGFloat = 1.25
    }
    
    let habitInfoView = UIView()
    let habitsMotivation = UITextView()
    let habitsName = UITextView()
    let acceptHabitButton = UIButton()
    let calendar = FSCalendar()
    let dateFormatter = ObjCDateFormatter()
    
    var habit = HabitDB()
    var viewColor = UIColor()
    var dates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        setupDateFormatter()
        setupViewData()
        setupTextView()
        setupCalendar()
        
        setTextViewConstraints()
        setCalendarConstraints()
    }
    
    func setupDateFormatter() {
        dateFormatter.setFormat(DateFormatConst.dateFormat)
    }
    
    func setupUI() {
        view.backgroundColor = .white
    }
    
    func setupViewData() {
        habitsName.text = habit.habitNameDB
        habitsMotivation.text = habit.habitsMotivationDB
        viewColor = HabitsType(rawValue: habit.habitTypeDB).color
        dates = habit.datesDB ?? []
    }
    
    func setupTextView() {
        habitsName.backgroundColor = viewColor.withAlphaComponent(Constants.alpha)
        habitsName.textAlignment = .center
        habitsName.font = UIFont(name: Fonts.titleHabitFont, size: Constants.fontSize)
        
        habitsMotivation.backgroundColor = viewColor.withAlphaComponent(Constants.alpha)
        habitsMotivation.textAlignment = .center
        habitsMotivation.font = UIFont(name: Fonts.motivationHabitFont, size: Constants.fontSize)
        
        setupAcceptButton()
        view.addSubview(habitsMotivation)
        view.addSubview(habitsName)
        view.addSubview(acceptHabitButton)
    }
    
    func setupAcceptButton() {
        acceptHabitButton.frame.size.width = Constants.buttonWidth
        acceptHabitButton.frame.size.height = Constants.buttonHeight
        acceptHabitButton.setTitle(Constants.buttonTitle, for: .normal)
        acceptHabitButton.addTarget(self, action: #selector(acceptClicked), for: .touchUpInside)
        acceptHabitButton.center.x = view.frame.midX
        acceptHabitButton.center.y = view.frame.midY * Constants.buttonMult
    }
    
    @objc private func acceptClicked() {
        let habitListVC = HabitsListViewController()
        let currentDate = Date()
        guard let acceptedDate = dateFormatter.getDateString(from: currentDate) else { return }
        
        // adding a new date
        dates.append(acceptedDate)
        habit.datesDB = dates
        
        // update dates in main habit array
        for habitElement in habitListVC.habits where habitElement.habitNameDB == habit.habitNameDB {
                habit.datesDB = dates
        }
        
        CoreDataHabitsManager.instance.updateHabit(habit: habit)
        navigationController?.popViewController(animated: true)
    }
    
    func setupCalendar() {
        calendar.delegate = self
        // turn off the possible swipes
        calendar.isUserInteractionEnabled = false
        
        let calendarX: CGFloat = 0
        let calendarY: CGFloat = 0
        
        calendar.frame = CGRect(x: calendarX, y: calendarY, width: Constants.calendarSize, height: Constants.calendarSize)
        view.addSubview(calendar)
    }
    
    func setViewConstraints() {
        habitInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitInfoView.widthAnchor.constraint(equalTo: view.widthAnchor),
            habitInfoView.heightAnchor.constraint(equalToConstant: view.frame.size.height / Constants.height)
        ])
    }
    
    func setTextViewConstraints() {
        habitsName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitsName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitsName.widthAnchor.constraint(equalTo: view.widthAnchor),
            habitsName.heightAnchor.constraint(equalToConstant: view.frame.size.height / Constants.height)
        ])
        
        
        habitsMotivation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitsMotivation.topAnchor.constraint(greaterThanOrEqualTo: habitsName.bottomAnchor),
            habitsMotivation.widthAnchor.constraint(equalTo: view.widthAnchor),
            habitsMotivation.heightAnchor.constraint(equalToConstant: view.frame.size.height / Constants.height)
        ])
    }
    
    func setCalendarConstraints() {
        calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: habitsMotivation.bottomAnchor),
            calendar.widthAnchor.constraint(equalTo: view.widthAnchor),
            calendar.heightAnchor.constraint(equalToConstant: view.frame.size.height / Constants.height)
        ])
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let currentDate = Date()
        
        guard let currentDayString = dateFormatter.getDateString(from: date),
            let cellDayString = dateFormatter.getDateString(from: currentDate),
            currentDayString == cellDayString else {
                return
        }
        cell.shapeLayer.backgroundColor = viewColor.withAlphaComponent(Constants.alpha).cgColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        guard let cellDay = dateFormatter.getDateString(from: date), dates.contains(cellDay) else {
            return .clear
        }
        return .purple
    }
}
