//
//  TaskListViewController.swift
//  DailyDiary
//
//  Created by Рома Баранов on 18.05.2023.
//

import UIKit

class TaskListViewController: UITableViewController {

    private let cellID = "cell"
    private var taskList = ["hello", "Привет"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .black
        setupTabBarController()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
//        let task = taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "Hello"
        content.textProperties.color = .white
        content.textProperties.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        cell.backgroundColor = .black
        cell.contentConfiguration = content
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(withTitle: "hi", andMessage: "hi")
    }
    
    
    @objc private func addTask() {
        showAlert(withTitle: "New Task", andMessage: "What do you want to do?")
    }
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save Task", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            save()
        }
        saveAction.setValue(UIColor(named: "buttonGreen"), forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Cansel", style: .destructive)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor") // так красный ярче)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { text in
            text.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func save() {
        
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
