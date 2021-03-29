//
//  TrainingViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 27.03.2021.
//
import CoreData
import UIKit

class TrainingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var training: TrainingTemplate? = nil
    var container: NSPersistentContainer!
    
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var addExerciseButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func onSaveClick(_ sender: Any) {
        training!.name = nameTextField.text
        saveContext(container: container)
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if training?.name == nil {
            training?.name = "Тренировка"
        }
        saveContext(container: container)
    }
    
    
    @IBAction func onAddExerciseClick(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "ExerciseViewController") as ExerciseViewController
        let newExercise = ExerciseTemplate(context: container.viewContext)
        newExercise.trainingTemplate = training
        training!.exercisesTemplates.adding(newExercise)
        print("Got \(training!.allExercisesTemplates.count) exercises")
        saveContext(container: container)
        controller.exercise = newExercise
        //self.present(controller, animated: true, completion: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func viewDidLoad() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteTraining))
        
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        //self.exercisesTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        nameTextField.text = training?.name ?? ""
        print("\(training!.allExercisesTemplates.count)")
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func deleteTraining() {
        let viewContext = container.viewContext
        viewContext.delete(training!)
        try? viewContext.save()
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return training!.allExercisesTemplates.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        
        
        let exercise = training!.allExercisesTemplates[indexPath.row]
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                    IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "ExerciseViewController") as ExerciseViewController
        print("Got \(training!.allExercisesTemplates.count) exercises")
        print(indexPath.row)
        controller.exercise = training!.allExercisesTemplates[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveContext(container: container)
        exercisesTableView.reloadData()
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
