//
//  TaskListViewController.swift
//  DailyDiary
//
//  Created by Рома Баранов on 18.05.2023.
//

import UIKit

final class TaskListViewController: UITableViewController {
    // MARK: - Private Properties
    private let cellID = "cell"
    private var taskList: [Task] = []
    private let storageManager = StorageManager.shared
    
    // MARK: - View Life Sycle
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
        cell.accessoryType = .detailDisclosureButton
        cell.tintColor = UIColor.white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.deleteTask(index: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        showAlert(withTitle: "Task Changes", message: "What do you want to change", indexPath: indexPath, task: task)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    func showAlert(withTitle title: String, message: String, indexPath: IndexPath? = nil, task: Task? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let textField = alert.textFields?.first?.text else { return }
            if let task = task {
                save(task: task, title: textField)
                tableView.reloadRows(at: [indexPath ?? IndexPath(row: 0, section: 0) ], with: .automatic)
            } else {
                save(taskName: textField)
            }
        }
        let cancelAction = UIAlertAction(title: "Cansel", style: .destructive)
        
        saveAction.setValue(UIColor(named: "buttonGreen"), forKey: "titleTextColor")
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Task name"
            textField.text = task?.title
        }
        present(alert, animated: true, completion: nil)
    }

    
    func save(taskName: String? = nil, task: Task? = nil, title: String? = nil ) {
        if let taskName = taskName {
            taskList.append(storageManager.createTask(title: taskName))
            let indexPath = IndexPath(row: taskList.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else if let task = task {
            storageManager.updateTask(task: task, title: title ?? "")
        }
        
        dismiss(animated: true)
    }
    
    func fetchTasks() {
        taskList = storageManager.fetchTasks()
    }
    
    @objc func addTask() {
        showAlert(withTitle: "New Task", message: "What do you want to do?")
    }
}
