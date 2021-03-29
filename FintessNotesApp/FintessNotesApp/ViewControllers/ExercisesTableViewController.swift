//
//  ExercisesTableViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 25.03.2021.
//

import UIKit
import CoreData


private func parseDate(_ str : String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    return dateFormat.date(from: str)!
}


class ExercisesTableViewController: UITableViewController, HeaderViewDelegate, CustomCellDelegate {
    
    var trainingPredicate: NSPredicate?
    
    var appDelegate : AppDelegate?
    var managedContext : NSManagedObjectContext?
    
    func expandedSection(button: UIButton) {
        let section = button.tag
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "TrainingViewController") as TrainingViewController
        controller.training = trainingTemplates[section]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func doExercise(button: UIButton) {
        let section = button.tag
        print(section)
        if section > exercises.count - 1 {
            let newTraining = createByTemplate(template: exercisesTemplates[section].trainingTemplate!)
            exercises.append(contentsOf: newTraining.allExercises)
            let nbutton = UIButton()
            nbutton.tag = section
            doExercise(button: nbutton)
        } else {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controller = story.instantiateViewController(identifier: "DoneExerciseViewController") as DoneExerciseViewController
            controller.exercise = exercises[section]
            navigationController?.pushViewController(controller, animated: true)
        }
        
        
    }
    
    
    var container: NSPersistentContainer!
    
    var trainingTemplates = [TrainingTemplate]()
    
    var exercisesTemplates = [ExerciseTemplate]()
    
    var trainings = [Training]()
    
    var exercises = [Exercise]()
    
    
    var roundButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Использовал, когда засорилось.
        DeleteAllData(entity: "TrainingTemplate")
        DeleteAllData(entity: "ExerciseTemplate")
        DeleteAllData(entity: "Exercise")
        DeleteAllData(entity: "Training")
        
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let headerNib = UINib.init(nibName: "CustomHeaderView", bundle: Bundle.main)
        let customCellNib = UINib.init(nibName: "ExerciseTableViewCell", bundle: Bundle.main)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "CustomHeader")
        self.tableView.register(customCellNib, forCellReuseIdentifier: "Cell")
        
        initButton()
        
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy =
                NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        loadSavedTemplates()
        //loadSavedData()
        
        getLastTrainings()
        
    }
    
    
    func loadSavedTemplates() {
        let request = TrainingTemplate.createFetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = trainingPredicate
        do {
            trainingTemplates = try container.viewContext.fetch(request)
            print("Got \(trainingTemplates.count) trainingTemplates")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
        for template in trainingTemplates {
            exercisesTemplates.append(contentsOf: template.allExercisesTemplates)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //loadSavedData()
        loadSavedTemplates()
        getLastTrainings()
        print(exercisesTemplates.count)
        print(trainingTemplates.count)
        tableView.reloadData()
        
    }
    
    
    override func viewWillLayoutSubviews() {
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        //roundButton.backgroundColor = UIColor.lightGray
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"plus"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -3),
                                        roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
                                        roundButton.widthAnchor.constraint(equalToConstant: 50),
                                        roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    // Действие при добавлении.
    @IBAction func ButtonClick(_ sender: UIButton){
        
        let newTrainingTemplate = TrainingTemplate(context: container.viewContext)
        trainingTemplates.append(newTrainingTemplate)
        newTrainingTemplate.exercisesTemplates = NSSet()
        
        //newTraining.exercises = [NSSet]()
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "TrainingViewController") as TrainingViewController
        controller.training = newTrainingTemplate
        navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return trainingTemplates.count
        //return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let exercises = trainings[section].valueForKey("exercises")
        return trainingTemplates[section].exercisesTemplates.count
        //return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ExerciseTableViewCell
        cellView.editButton.tag = indexPath.row
        if indexPath.section > trainings.count - 1  {
            let training = trainingTemplates[indexPath.section]
            let exercise = training.allExercisesTemplates[indexPath.row]
            cellView.delegate = self
            cellView.titleExercise.text = exercise.name
            cellView.countDone.text = "0"
            cellView.countOfReps.text = "30"
        } else {
            let training = trainings[indexPath.section]
            let exercise = training.allExercises[indexPath.row]
            cellView.delegate = self
            cellView.titleExercise.text = exercise.name
            cellView.countDone.text = String(exercise.numberOfReps)
            cellView.countOfReps.text = "30"
        }
        //print(exercisesTemplates.count)
        //print(trainingTemplates.count)
        
        return cellView
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! CustomHeaderView
        
        print(trainings.count)
        headerView.titleLabel.text = trainingTemplates[section].name
        headerView.delegate = self
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteExercise(with: exercisesTemplates.remove(at: indexPath.row))
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    func deleteExercise(with name: ExerciseTemplate) {
        let viewContext = container.viewContext
        viewContext.delete(name)
        try? viewContext.save()
    }
    
    
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
    
    func initButton() {
        //create a button or any UIView and add to subview
        roundButton = UIButton(type: .custom)
        roundButton.setTitle("+", for: .normal)
        roundButton.setTitleColor(UIColor.orange, for: .normal)
        roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(roundButton)
        
        //set constrains
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            roundButton.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
            roundButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        } else {
            roundButton.rightAnchor.constraint(equalTo: tableView.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
            roundButton.bottomAnchor.constraint(equalTo: tableView.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        }
    }
    
    func getLastTrainings() {
        if trainingTemplates.count > 0 {
            for training in trainingTemplates {
                if training.name == nil {
                    break
                }
                let predicate = NSPredicate(format: "name = %@", training.name!)
                let request = Training.createFetchRequest()
                let sort = NSSortDescriptor(key: "date", ascending: true)
                request.sortDescriptors = [sort]
                request.predicate = predicate
                do {
                    let allTrainings = try container.viewContext.fetch(request)
                    if allTrainings.count > 0 {
                        trainings.append(allTrainings[0])
                    }
                    
                } catch {
                    print("Fetch failed")
                }
            }
            for tr in trainings {
                exercises.append(contentsOf: tr.allExercises)
            }
            tableView.reloadData()
        }
        
    }
    
    func createByTemplate (template: TrainingTemplate) -> Training {
        let training = Training(context: container.viewContext)
        training.date = Date()
        training.name = template.name
        for ex in template.allExercisesTemplates {
            let exer = Exercise(context: container.viewContext)
            exer.name = ex.name
            exer.weight = 0
            if ex.isWeight {
                exer.weight = 10
            }
            exer.numberOfReps = 0
            training.addToExercises(exer)
        }
        return training
    }
    
    
}


/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
