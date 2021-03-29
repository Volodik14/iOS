//
//  ExerciseViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 29.03.2021.
//
import CoreData
import UIKit

class ExerciseViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    var exercise: ExerciseTemplate? = nil
    var container: NSPersistentContainer!
    @IBOutlet weak var switchValue: UISwitch!
    
    @IBAction func onSaveExerciseClick(_ sender: Any) {
        exercise!.name = nameTextField.text
        exercise?.isWeight = switchValue.isOn
        //print("Got \(exercise?.name) exercise")
        saveContext(container: container)
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        nameTextField.text = exercise?.name
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if exercise?.name == nil {
            exercise?.name = "Упражнение"
        }
        exercise?.isWeight = switchValue.isOn
        saveContext(container: container)
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
