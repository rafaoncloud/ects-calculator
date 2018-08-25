//
//  SemesterGradesTableViewController.swift
//  ects-calculator
//
//  Created by Rafael Henriques on 23/08/2018.
//  Copyright © 2018 rafaoncloud. All rights reserved.
//

import UIKit
import CoreData

class SubjectsTableViewController: UITableViewController {

    var subjects = [Subject]()
    var semester: Semester!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.loadFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadFromCoreData(){
        self.subjects = SubjectsTableViewController.fetchSubjectsBySemester(semester: semester)
        self.tableView.reloadData()
    }
    
    public static func fetchSubjectsBySemester(semester: Semester) -> [Subject]{
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        
        // Only fetch subjects witch belong to the given semester
        let predicate = NSPredicate(format: "semester == %@", semester)
        fetchRequest.predicate = predicate
        
        // Load semesters
        do{
            let subjects = try PersistenceService.context.fetch(fetchRequest)
            return subjects
        }catch {
            print("Error fetching Subjects by Semester")
        }
        return []
    }
    
    @IBAction func AddSubject(_ sender: UIBarButtonItem) {
        // Create a Alert Dialog
        let alert = UIAlertController(title: "Add Subject", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Abbreviation"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Full Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "ECTS"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Grade"
            textField.keyboardType = .numberPad
        }
        // Add the Add Button
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            
            // Get values from the alert Text Fields
            let abbreviation = alert.textFields![0].text!
            let fullName = alert.textFields![1].text!
            let ectsText = alert.textFields![2].text!
            let gradeText = alert.textFields![3].text!
            
            // The person creating is refused if age is not a number or the personname is empty
            if(!self.isStringAnInt(string: ectsText) || !self.isStringAnInt(string: gradeText) || abbreviation.isEmpty || fullName.isEmpty){
                return;
            }
            
            // Cast string to int
            let ects = Int16(ectsText)!
            let grade = Int16(gradeText)!
            
            // Check values 1<=ECTS<=1000 && 10<=grade<=20
            if(ects < 1 || ects > 1000 || grade < 10 || grade > 20){
                return;
            }
            
            // Create a Subject object from an Entity Model
            let subject = Subject(context: PersistenceService.context)
            subject.abbreviation = abbreviation
            subject.fullName = fullName
            subject.ects = ects
            subject.grade = grade
            
            // Add relationship
            self.semester.addToSubjects(subject)
            subject.semester = self.semester
            
            // Update This Table
            PersistenceService.saveContext()
            self.subjects.append(subject)
            self.tableView.reloadData()
            print("Subject Added")
        }
        // Add the cancel Button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("Add Subject Canceled")
        })
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTableViewCell.cellReuseIdentifier, for: indexPath) as! SubjectTableViewCell
        
        // Configure the cell...
        let subject = subjects[indexPath.row]
        
        cell.abbreviationLbl?.text = subject.abbreviation
        cell.fullNameLbl?.text = subject.fullName
        cell.ectsValueLbl?.text = String(subject.ects)
        cell.gradeValueLbl?.text = String(subject.grade)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "semesterSubjects") {
            let semester = sender as! Semester
            print("Semester: \(semester.year) \(semester.semester)")
        }
        print("SubjectsTableViewController prepare()")
    }
 

}
