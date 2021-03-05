//
//  TaskViewController.swift
//  TaskApp
//
//  Created by Владимир Моторкин on 05.03.2021.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    var task: Task? = nil

    var container: NSPersistentContainer!
    
    let statuses = ["New", "In progress", "Completed"]
    
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        statusPicker.delegate = self
        statusPicker.dataSource = self
        statusPicker.selectRow(1, inComponent: 0, animated: false)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTask))
        let index = statuses.firstIndex(of: task!.status!)
        if (index != nil) {
            statusPicker.selectRow(index!, inComponent: 0, animated: false)
        }
        datePicker.date = task!.date ?? Date()
        titleTextField.text = task!.title
        descriptionTextView.text = task!.taskDescription
    }
    
    // Сохранить изменённую задачу.
    @objc func saveTask() {
        task!.date = datePicker.date
        task!.title = titleTextField.text ?? ""
        task!.taskDescription = descriptionTextView.text
        task!.status = statuses[statusPicker.selectedRow(inComponent: 0)]
        saveContext(container: container)
        navigationController?.popViewController(animated: true)
        
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statuses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statuses[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
