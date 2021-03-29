//
//  DoneExerciseViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 29.03.2021.
//
import CoreData
import UIKit

class DoneExerciseViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    var container: NSPersistentContainer!
    
    @IBOutlet weak var valuePicker: UIPickerView!
    
    var chosenValue: Int16 = 0
    let number = 99
    var exercise: Exercise?
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    @IBAction func onSaveClicked(_ sender: Any) {
        exercise?.numberOfReps += chosenValue
        saveContext(container: container)
        navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        //valuePicker.selectRow(Int(exercise!.numberOfReps), inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenValue = Int16(row + 1)
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
