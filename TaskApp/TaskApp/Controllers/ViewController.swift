//
//  ViewController.swift
//  TaskApp
//
//  Created by Владимир Моторкин on 05.03.2021.
//

import CoreData
import UIKit

class ViewController: UITableViewController {
    var taskPredicate: NSPredicate?
    var container: NSPersistentContainer!
    var tasks = [Task]()
    override func viewDidLoad() {
        
        // Использовал, когда засорилось.
        //DeleteAllData(entity: "Task")
        super.viewDidLoad()
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewItem))
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy =
                NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    // Добавление стандартного элемента.
    @objc func addNewItem() {
        let newTask = Task(context: container.viewContext)
        newTask.title = "Title"
        newTask.date = Date()
        newTask.status = "New"
        tasks.append(newTask)
        saveContext(container: container)
        let path = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [path], with: .fade)
        
        // Можно добавить сразу вхождение в TaskView.
    }
    
    // Применение фильтра.
    @objc func changeFilter() {
        let ac = UIAlertController(title: "Filter tasks...", message: nil,
                                   preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Show new", style: .default)
        { [unowned self] _ in
            self.taskPredicate = NSPredicate(format: "status == 'New'")
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Show in process", style: .default)
        { [unowned self] _ in
            self.taskPredicate = NSPredicate(format: "status == 'In progress'")
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Show completed", style: .default)
        { [unowned self] _ in
            self.taskPredicate = NSPredicate(format: "status == 'Completed'")
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Show all", style: .default)
        { [unowned self] _ in
            self.taskPredicate = nil
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    // Переводит дату в строку.
    func toDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    // Загрузка сохранённых задач.
    func loadSavedData() {
        let request = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = taskPredicate
        do {
            tasks = try container.viewContext.fetch(request)
            print("Got \(tasks.count) tasks")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteTask(with: tasks.remove(at: indexPath.row))
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // Удаление задачи.
    func deleteTask(with name: Task) {
        let viewContext = container.viewContext
        viewContext.delete(name)
        try? viewContext.save()
    }
    
    // Для обновления таблицы.
    override func viewWillAppear(_ animated: Bool) {
        loadSavedData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
                                section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
                                IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for:
                                                    indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel!.text = task.title
        if let date = task.date {
            cell.detailTextLabel?.text = toDay(date: date)
        } else {
            cell.detailTextLabel?.text = "No date"
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                                IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier:
                                                            "Detail") as? TaskViewController {
            vc.task = tasks[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Удалить всю CoreData для заданного Entity.
    func DeleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do
    {
        let results = try managedContext.fetch(fetchRequest)
        for managedObject in results
        {
            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
            managedContext.delete(managedObjectData)
        }
    } catch let error as NSError {
        print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
    }
        
    }
}

