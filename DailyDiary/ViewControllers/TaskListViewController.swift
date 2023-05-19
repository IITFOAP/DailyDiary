//
//  TaskListViewController.swift
//  DailyDiary
//
//  Created by Рома Баранов on 18.05.2023.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {

    private let cellID = "cell"
    private var taskList: [Task] = []
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .black
        setupTabBarController()
        fetchTasks()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
    
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        content.textProperties.color = .white
        content.textProperties.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        cell.backgroundColor = .black
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        showAlert(withTitle: "Редактирование", message: "Внесите изменения", indexPath: indexPath, task: task)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.deleteTask(index: indexPath.row)
        }
    }
}

// MARK: SetupUI
private extension TaskListViewController {
    func setupTabBarController() {
        title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .black
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationController?.navigationBar.tintColor = UIColor(named: "buttonGreen")
    }
}

// MARK: Private methods TaskListViewController
private extension TaskListViewController {
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save Task", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            save(taskName: task)
        }
        let cancelAction = UIAlertAction(title: "Cansel", style: .destructive)
        
        saveAction.setValue(UIColor(named: "buttonGreen"), forKey: "titleTextColor")
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor") // так красный ярче)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    func save(taskName: String) {
        taskList.append(storageManager.createTask(title: taskName))
        
        let indexPath = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        dismiss(animated: true)
    }
    
    func fetchTasks() {
        taskList = storageManager.fetchTasks()
    }
    
    func updateTask() {
        
    }
    
    @objc func addTask() {
        showAlert(withTitle: "New Task", andMessage: "What do you want to do?")
    }
    
    func showAlert(withTitle title: String, message: String, indexPath: IndexPath, task: Task) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let textField = alert.textFields?.first?.text else { return }
            storageManager.updateTask(task: task, title: textField)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "Cansel", style: .destructive)
        
        saveAction.setValue(UIColor(named: "buttonGreen"), forKey: "titleTextColor")
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Task name"
            textField.text = task.title
        }
        present(alert, animated: true, completion: nil)
    }

}
