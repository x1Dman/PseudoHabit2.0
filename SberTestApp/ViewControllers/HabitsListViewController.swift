//
//  HabitsListViewController.swift
//  SberTestApp
//
//  Created by Nikita Khusnutdinov on 7/14/20.
//  Copyright © 2020 Nikita Khusnutdinov. All rights reserved.
//

import UIKit


final class HabitsListViewController: UIViewController, HabitsViewControllerDelegate {
    
    private enum Constants {
        static let appTitle = "Pseudo's Habits"
        static let habitCell = "HabitCell"
        
        static let heightNavBar: CGFloat = 50
        static let rowHeight: CGFloat = 100
        static let navBarX: CGFloat = 0
        static let navBarY: CGFloat = 50
    }
    
    let habitsTableView = UITableView()
    let navBar = UINavigationBar(frame: CGRect(x: Constants.navBarX, y: Constants.navBarY, width: UIScreen.main.bounds.width, height: Constants.heightNavBar))
    let addButton = UIButton(type: .roundedRect)
    var habits: [HabitDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareHabitsDataForUsage()
        setupUI()
    }
    
    func updateHabitsOrder() {
        habits.sort {
            (habit1, habit2) -> Bool in
            return habit1.habitTypeDB > habit2.habitTypeDB
        }
    }
    
    func prepareHabitsDataForUsage() {
        habits = fillArrayFromDB()
        updateHabitsOrder()
    }
    
    func fillArrayFromDB() -> [HabitDB] {
        guard let habitDB = CoreDataHabitsManager.instance.fetchHabits() else { return [] }
        return habitDB
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHabitsOrder()
        habitsTableView.reloadData()
    }
    
    func setupView() {
        title = Constants.appTitle
        view.backgroundColor = .white
        setupNavBar()
        setupHabitsTableView()
    }
    
    func setupUI() {
        setupView()
        setHabitsTableViewConstraints()
    }
    
    func setupNavBar() {
        view.addSubview(navBar)
        navBar.backgroundColor = .white
        navBar.delegate = self as? UINavigationBarDelegate
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(goToNextView)
        )
    }
    
    @objc private func goToNextView() {
        let destinationViewController = HabitViewController()
        destinationViewController.modalPresentationStyle = .fullScreen
        destinationViewController.delegate = self
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func addNewHabitInList(habit: HabitDB) {
        habits.append(habit)
    }
    
    func addedNewHabitInList(controller: HabitViewController) {
        guard let habitName = controller.habitNameTextField.text else {
            return
        }
        // added new habbit
        if habits.contains(where: {$0.habitNameDB == habitName}) {
            return
        }
        let habitType = controller.habitType
        let motivationText = controller.habitMotivationTextField.text
        let dates: [String] = []
        let habitModel = HabitModel(
            name: habitName,
            type: habitType.rawValue,
            motivation: motivationText,
            dates: dates
        )
        // Mark: Added to DB and list
        guard let habit = CoreDataHabitsManager.instance.createHabit(
            withHabitModel: habitModel
        ) else {
            controller.navigationController?.popViewController(animated: true)
            return
        }
        // means that habit was added into DB and we can easily add it to list
        addNewHabitInList(habit: habit)
        controller.navigationController?.popViewController(animated: true)
    }
    
    func setupHabitsTableView() {
        view.addSubview(habitsTableView)
        // set delegates
        habitsTableView.delegate = self
        habitsTableView.dataSource = self
        // cell height
        // TODO DYNAMIC CELLS
        habitsTableView.rowHeight = Constants.rowHeight
        habitsTableView.register(HabitCell.self, forCellReuseIdentifier: Constants.habitCell)
    }
    
    
    func setHabitsTableViewConstraints() {
        habitsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            habitsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}


extension HabitsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let habitCell = tableView.dequeueReusableCell(withIdentifier: Constants.habitCell) as? HabitCell else { return UITableViewCell() }
        let habit = habits[indexPath.row]
        habitCell.set(habit: habit)
        return habitCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habitInfoVC = HabitInfoViewController()
        habitInfoVC.habit = habits[indexPath.row]
        navigationController?.pushViewController(habitInfoVC, animated: true)
    }
    
    // DELETE DATA FROM SOURCE ARRAY
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // delete phase
        let habit = habits[indexPath.row]
        habits.remove(at: indexPath.row)
        habitsTableView.deleteRows(at: [indexPath], with: .fade)
        CoreDataHabitsManager.instance.deleteHabit(habit: habit)
    }
}
