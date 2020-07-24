//
//  HabitInfoViewController.swift
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/15/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//

import FSCalendar
import UIKit

protocol HabitInfoProtocol {
    var habit: HabitDB { get set }
}

final class HabitInfoViewController: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance, HabitInfoProtocol {
    
    enum Constants {
        static let buttonTitle = "Accept Habit"
        static let calendarSize: CGFloat = 200
        static let fontSize: CGFloat = 20
        static let height: CGFloat = 4
        static let alpha: CGFloat = 0.4
        static let buttonAlpha: CGFloat = 0.8
        static let buttonHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 200
        static let buttonMult: CGFloat = 1.25
        static let calendarX: CGFloat = 0
        static let calendarY: CGFloat = 0
        static let buttonAnchor: CGFloat = -20.0
    }
    
    //private let habitInfoView = UIView()
    private let motivationView = UIView()
    private let nameView = UIView()
    
    private let motivationLabel = UILabel()
    private let nameLabel = UILabel()
    
    private let acceptButton = UIButton()
    private let calendar = FSCalendar()
    private let dateFormatter = ObjCDateFormatter()
    private var viewColor = UIColor()
    
    var habit = HabitDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    private func setupUI() {
        setupView()
        setConstraints()
    }
    
    private func setupDateFormatter() {
        dateFormatter.setFormat(DateFormatConst.dateFormat)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        setupDateFormatter()
        setupViewData()
        setupTextLabel()
        setupCalendar()
    }
    
    private func setConstraints() {
        
        setButtonConstraints()
        setTextViewConstraints()
        setCalendarConstraints()
    }
    
    private func setupViewData() {
        // prepare color
        viewColor = HabitsType(rawValue: habit.habitTypeDB).color.withAlphaComponent(Constants.alpha)
        
        // setup motivaton view
        motivationView.addSubview(motivationLabel)
        motivationView.addSubview(acceptButton)
        motivationView.backgroundColor = viewColor
        // setup nameView
        nameView.addSubview(nameLabel)
        nameView.backgroundColor = viewColor
        // add subviews
        view.addSubview(nameView)
        view.addSubview(motivationView)
        
        setupAcceptButton()
    }
    
    private func setupTextLabel() {
        motivationLabel.text = habit.habitsMotivationDB
        motivationLabel.textAlignment = .center
    
        nameLabel.text = habit.habitNameDB
        nameLabel.textAlignment = .center
    }
    
    private func setupAcceptButton() {
        acceptButton.backgroundColor = UIColor.black.withAlphaComponent(Constants.buttonAlpha)
        // making circle
        acceptButton.layer.cornerRadius = Constants.buttonHeight * 0.5
        
        acceptButton.setTitle(Constants.buttonTitle, for: .normal)
        acceptButton.setTitleColor(viewColor, for: .normal)
        acceptButton.addTarget(self, action: #selector(acceptClicked), for: .touchUpInside)
    }
    
    @objc private func acceptClicked() {
        let habitListVC = HabitsListViewController()
        let currentDate = Date()
        guard let acceptedDate = dateFormatter.getDateString(from: currentDate) else { return }
        
        // fix bug with infinite same dates
        guard let dates = habit.datesDB else {
            navigationController?.popViewController(animated: true)
            return
        }
        if dates.contains(acceptedDate) {
            navigationController?.popViewController(animated: true)
            return
        }
        
        habit.datesDB?.append(acceptedDate)
        //habit.datesDB = dates
        
        for date in dates {
            print(date)
        }
        
        // update dates in main habit array
        for habitEl in habitListVC.habits where habitEl.habitNameDB == habit.habitNameDB {
            habitEl.datesDB = habit.datesDB
        }
        
        CoreDataHabitsManager.instance.update(habit)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupCalendar() {
        calendar.delegate = self
        // turn off the possible swipes
        calendar.isUserInteractionEnabled = false
        
        calendar.frame = CGRect(x: Constants.calendarX, y: Constants.calendarY, width: Constants.calendarSize, height: Constants.calendarSize)
        view.addSubview(calendar)
    }
    
    private func setButtonConstraints() {
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acceptButton.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor),
            acceptButton.bottomAnchor.constraint(equalTo: motivationView.bottomAnchor),
            acceptButton.trailingAnchor.constraint(equalTo: motivationView.safeAreaLayoutGuide.trailingAnchor, constant: Constants.buttonAnchor),
            acceptButton.leadingAnchor.constraint(equalTo: motivationView.safeAreaLayoutGuide.leadingAnchor, constant: -Constants.buttonAnchor)
        ])
    }
    
    private func setTextViewConstraints() {
        motivationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            motivationLabel.topAnchor.constraint(equalTo: motivationView.safeAreaLayoutGuide.topAnchor),
            motivationLabel.widthAnchor.constraint(equalTo: motivationView.widthAnchor),
            motivationLabel.heightAnchor.constraint(equalTo: motivationView.heightAnchor, multiplier: 0.5)
        ])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: nameView.safeAreaLayoutGuide.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: nameView.safeAreaLayoutGuide.bottomAnchor),
            nameLabel.widthAnchor.constraint(equalTo: nameView.widthAnchor),
            nameLabel.heightAnchor.constraint(equalTo: nameView.heightAnchor)
        ])
        
        nameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameView.widthAnchor.constraint(equalTo: view.widthAnchor),
            nameView.heightAnchor.constraint(equalToConstant: view.frame.size.height / Constants.height)
        ])
        
        motivationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            motivationView.topAnchor.constraint(greaterThanOrEqualTo: nameView.bottomAnchor),
            motivationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            motivationView.heightAnchor.constraint(equalToConstant: view.frame.size.height / Constants.height)
        ])
    }
    
    private func setCalendarConstraints() {
        calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: motivationView.bottomAnchor),
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
        guard let dates = habit.datesDB, let cellDay = dateFormatter.getDateString(from: date), dates.contains(cellDay) else {
            return .clear
        }
        return .purple
    }
}
