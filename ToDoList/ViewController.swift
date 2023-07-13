//
//  ViewController.swift
//  ToDoList
//
//  Created by Shubhdeep on 2023-07-12.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var models = [ToDoListItem]()
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To-Do List"
        getAllItems()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped(){
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Enter your item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { textField in
                textField.text = item.name
            })
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                if let textField = alert.textFields?.first, let newName = textField.text, !newName.isEmpty {
                    self?.updateItem(item: item, newName: newName)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }))
        
      
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    // MARK: Core Data
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("error")
        }
    }
    
    func createItem(name: String){
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
        } catch {
            // error
        }
        
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
       
        do {
            try context.save()
            getAllItems()
        } catch {
            // error
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String){
        item.name = newName
        do {
            try context.save()
            getAllItems()
        } catch {
            // error
        }
        
    }
}

