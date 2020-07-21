//
//  HabitViewController.swift
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/15/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//
// Add a new Habit

import UIKit

protocol HabitsViewControllerDelegate: class {
    func addedNewHabitInList(controller: HabitViewController)
}

final class HabitViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: HabitsListViewController?
    
    // consts
    private enum Constants {
        static let acceptButtonText = "Accept"
        static let initHabitNameText = "Type there your hobby"
        static let initHabitMotivationText = "Here is motivation text"
        static let segmentItems = ["Chill", "Sport", "Intelligence", "Health"]
        
        static let initHabitTypeValue: HabitsType = .sporty
        static let constraint: CGFloat = 200
    }
    
    //  let
    let segmentTypeControl = UISegmentedControl(items: Constants.segmentItems)
    let acceptButton = UIButton(type: .roundedRect)
    let habitNameTextField = UITextField()
    let habitTypeView = UIView()
    let habitMotivationTextField = UITextField()
    //var habit: HabitDB!
    var habitType: HabitsType = Constants.initHabitTypeValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setHabitNameTextField()
        setHabitMotivationTextField()
        setAcceptButton()
        setSegmentControl()
        setHabitTypeView()
        
        setNameTextFieldConstraints()
        setMotivationTextFieldConstraints()
        setTypeViewConstraints()
        setAcceptButtonConstraints()
        setSegmentedControlConstraints()
    }
    
    
    func setSegmentControl() {
        let segmentX: CGFloat = 20
        let segmentY: CGFloat = 20
        let segmentHeight: CGFloat = 30
        let segmentIndex = 1
        
        segmentTypeControl.frame = CGRect(x: segmentX, y: segmentY, width: habitTypeView.frame.width, height: segmentHeight)
        segmentTypeControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        segmentTypeControl.selectedSegmentIndex = segmentIndex
        habitTypeView.addSubview(segmentTypeControl)
    }
    
    func setAcceptButton() {
        acceptButton.setTitle(Constants.acceptButtonText, for: .normal)
        acceptButton.addTarget(self, action: #selector(acceptClicked), for: .touchUpInside)
        habitTypeView.addSubview(acceptButton)
    }
    
    func setHabitTypeView() {
        view.addSubview(habitTypeView)
        habitTypeView.backgroundColor = .blue
    }
    
    func setHabitNameTextField() {
        view.addSubview(habitNameTextField)
        habitNameTextField.text = Constants.initHabitNameText
        habitNameTextField.textAlignment = .center
        habitNameTextField.layer.borderColor = UIColor.black.cgColor
        habitNameTextField.borderStyle = .roundedRect
        habitNameTextField.backgroundColor = .white
    }
    
    func setHabitMotivationTextField() {
        view.addSubview(habitMotivationTextField)
        habitMotivationTextField.backgroundColor = .yellow
        habitMotivationTextField.text = Constants.initHabitMotivationText
        habitMotivationTextField.textAlignment = .center
        habitNameTextField.borderStyle = .roundedRect
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
        navigationController?.popViewController(animated: true)
        delegate?.addedNewHabitInList(controller: self)
    }
    
    
    // constraints
    func setNameTextFieldConstraints () {
        habitNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                habitNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                habitNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                habitNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                habitNameTextField.heightAnchor.constraint(equalToConstant: Constants.constraint),
                habitNameTextField.bottomAnchor.constraint(equalTo: habitMotivationTextField.topAnchor)
            ]
        )
    }
    
    func setMotivationTextFieldConstraints() {
        habitMotivationTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitMotivationTextField.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor),
            habitMotivationTextField.widthAnchor.constraint(equalTo: view.widthAnchor),
            habitMotivationTextField.bottomAnchor.constraint(equalTo: habitTypeView.topAnchor),
            habitMotivationTextField.heightAnchor.constraint(equalToConstant: Constants.constraint)
        ])
    }
    
    func setTypeViewConstraints() {
        habitTypeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitTypeView.topAnchor.constraint(equalTo: habitMotivationTextField.bottomAnchor),
            habitTypeView.widthAnchor.constraint(equalTo: view.widthAnchor),
            habitTypeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setAcceptButtonConstraints() {
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acceptButton.bottomAnchor.constraint(equalTo: habitTypeView.safeAreaLayoutGuide.bottomAnchor),
            acceptButton.widthAnchor.constraint(equalTo: habitTypeView.widthAnchor),
            acceptButton.topAnchor.constraint(equalTo: habitTypeView.topAnchor, constant: Constants.constraint)
        ])
    }
    
    func setSegmentedControlConstraints() {
        let topAnchorConst: CGFloat = 50
        let botAnchorConst: CGFloat = 20
        
        segmentTypeControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentTypeControl.bottomAnchor.constraint(lessThanOrEqualTo: acceptButton.topAnchor, constant: botAnchorConst),
            segmentTypeControl.widthAnchor.constraint(equalTo: habitTypeView.widthAnchor),
            segmentTypeControl.topAnchor.constraint(equalTo: habitTypeView.topAnchor, constant: topAnchorConst)
        ])
    }
    
}
