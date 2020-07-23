//
//  HabitViewController.swift
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/15/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//
// Add a new Habit

import UIKit

protocol HabitsProtocol {
    var habitName: String? { get }
    var habitMotivation: String? { get }
    var habitType: HabitsType { get }
}

protocol HabitsViewControllerDelegate: AnyObject {
    func addedNewHabitInList(controller: HabitViewController)
}

final class HabitViewController: UIViewController, UITextFieldDelegate, HabitsProtocol {
    
    // consts
    private enum Constants {
        static let acceptButtonText = "Accept"
        static let initHabitNameText = "Type there your hobby"
        static let initHabitMotivationText = "Here is motivation text"
        static let segmentItems = ["Chill", "Sport", "Intelligence", "Health"]
        
        static let initHabitTypeValue: HabitsType = .sporty
        static let constraint: CGFloat = 200
        static let segmentX: CGFloat = 20
        static let segmentY: CGFloat = 20
        static let segmentHeight: CGFloat = 30
        static let segmentIndex = 1
        static let segmentTopAnchor: CGFloat = 50
        static let segmentBotAnchor: CGFloat = 20
    }
    
    weak var delegate: HabitsViewControllerDelegate?
    
    private let segmentTypeControl = UISegmentedControl(items: Constants.segmentItems)
    private let acceptButton = UIButton(type: .roundedRect)
    private let habitNameTextField = UITextField()
    private let habitTypeView = UIView()
    private let habitMotivationTextField = UITextField()
    
    var habitType: HabitsType = Constants.initHabitTypeValue
    var habitName: String?
    var habitMotivation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        setupHabitNameTextField()
        setupHabitMotivationTextField()
        setupAcceptButton()
        setupSegmentControl()
        setupHabitTypeView()
    }
    
    private func setConstraints() {
        setNameTextFieldConstraints()
        setMotivationTextFieldConstraints()
        setTypeViewConstraints()
        setAcceptButtonConstraints()
        setSegmentedControlConstraints()
    }
    
    private func setupSegmentControl() {
        segmentTypeControl.frame = CGRect(x: Constants.segmentX, y: Constants.segmentY, width: habitTypeView.frame.width, height: Constants.segmentHeight)
        segmentTypeControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        segmentTypeControl.selectedSegmentIndex = Constants.segmentIndex
        habitTypeView.addSubview(segmentTypeControl)
    }
    
    private func setupAcceptButton() {
        acceptButton.setTitle(Constants.acceptButtonText, for: .normal)
        acceptButton.addTarget(self, action: #selector(acceptClicked), for: .touchUpInside)
        habitTypeView.addSubview(acceptButton)
    }
    
    private func setupHabitTypeView() {
        habitTypeView.backgroundColor = .blue
        view.addSubview(habitTypeView)
    }
    
    private func setupHabitNameTextField() {
        habitNameTextField.text = Constants.initHabitNameText
        habitNameTextField.textAlignment = .center
        habitNameTextField.layer.borderColor = UIColor.black.cgColor
        habitNameTextField.borderStyle = .roundedRect
        habitNameTextField.backgroundColor = Constants.initHabitTypeValue.color
        
        view.addSubview(habitNameTextField)
    }
    
    private func setupHabitMotivationTextField() {
        habitMotivationTextField.backgroundColor = .yellow
        habitMotivationTextField.text = Constants.initHabitMotivationText
        habitMotivationTextField.textAlignment = .center
        habitNameTextField.borderStyle = .roundedRect
        
        habitMotivation = habitMotivationTextField.text
        view.addSubview(habitMotivationTextField)
    }
    
    @objc private func segmentAction() {
        switch (segmentTypeControl.selectedSegmentIndex){
            case 0:
                habitNameTextField.backgroundColor = .green
                habitType = .relaxing
            case 1:
                habitNameTextField.backgroundColor = .red
                habitType = .sporty
            case 2:
                habitNameTextField.backgroundColor = .blue
                habitType = .intelligently
            case 3:
                habitNameTextField.backgroundColor = .yellow
                habitType = .healthy
            default:
                break
        }
    }
    
    @objc private func acceptClicked() {
        habitName = habitNameTextField.text
        habitMotivation = habitMotivationTextField.text
        
        navigationController?.popViewController(animated: true)
        delegate?.addedNewHabitInList(controller: self)
    }
    
    
    // constraints
    private func setNameTextFieldConstraints () {
        habitNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habitNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitNameTextField.heightAnchor.constraint(equalToConstant: Constants.constraint),
            habitNameTextField.bottomAnchor.constraint(equalTo: habitMotivationTextField.topAnchor)
        ])
    }
    
    private func setMotivationTextFieldConstraints() {
        habitMotivationTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitMotivationTextField.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor),
            habitMotivationTextField.widthAnchor.constraint(equalTo: view.widthAnchor),
            habitMotivationTextField.bottomAnchor.constraint(equalTo: habitTypeView.topAnchor),
            habitMotivationTextField.heightAnchor.constraint(equalToConstant: Constants.constraint)
        ])
    }
    
    private func setTypeViewConstraints() {
        habitTypeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitTypeView.topAnchor.constraint(equalTo: habitMotivationTextField.bottomAnchor),
            habitTypeView.widthAnchor.constraint(equalTo: view.widthAnchor),
            habitTypeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setAcceptButtonConstraints() {
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acceptButton.bottomAnchor.constraint(equalTo: habitTypeView.safeAreaLayoutGuide.bottomAnchor),
            acceptButton.widthAnchor.constraint(equalTo: habitTypeView.widthAnchor),
            acceptButton.topAnchor.constraint(equalTo: habitTypeView.topAnchor, constant: Constants.constraint)
        ])
    }
    
    private func setSegmentedControlConstraints() {
        segmentTypeControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentTypeControl.bottomAnchor.constraint(lessThanOrEqualTo: acceptButton.topAnchor, constant: Constants.segmentBotAnchor),
            segmentTypeControl.widthAnchor.constraint(equalTo: habitTypeView.widthAnchor),
            segmentTypeControl.topAnchor.constraint(equalTo: habitTypeView.topAnchor, constant: Constants.segmentTopAnchor)
        ])
    }
    
}
