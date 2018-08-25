//
//  SemestersTableViewController.swift
//  ects-calculator
//
//  Created by Rafael Henriques on 23/08/2018.
//  Copyright © 2018 rafaoncloud. All rights reserved.
//

import UIKit
import CoreData // Add CoreData library

class SemestersTableViewController: UITableViewController {

    var semesters = [Semester]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Register the costum cells
        //self.tableView.register(SemesterTableViewCell.self, forCellReuseIdentifier: SemesterTableViewCell.cellReuseIdentifier)
        
        // Load Semesters
        self.loadFromCoreData()
        
        // Setup pull-to-refresh
        self.setupRefreshControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshTable), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
    }
    
    // Awakened event/action when refresh control is clicked
    @objc private func refreshTable(_ sender: Any) {
        // Refresh Data
        self.loadFromCoreData()
        
        // Stop refresh control
        self.refreshControl?.endRefreshing()
    }
    
    func loadFromCoreData(){
        let fetchRequest: NSFetchRequest<Semester> = Semester.fetchRequest()
        
        // Sort Semesters by Year and Semester after get from db
        let sortDescriptor = NSSortDescriptor(key: "year", ascending: true)
        let sortDescriptor1 = NSSortDescriptor(key: "semester", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor,sortDescriptor1]
        
        // Load semesters
        do{
            let semesters = try PersistenceService.context.fetch(fetchRequest)
            self.semesters = semesters
            self.tableView.reloadData()
        }catch {}
    }
    
    @IBAction func AddSemester(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Subject", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Semester"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Year"
            textField.keyboardType = .numberPad
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            
            // Get values from the alert Text Fields
            let semesterText = alert.textFields![0].text!
            let yearText = alert.textFields![1].text!
            
            // The semester creating is refused if year is not a number or empty
            if(!self.isStringAnInt(string: semesterText) || !self.isStringAnInt(string: yearText) || semesterText.isEmpty || yearText.isEmpty){
                return;
            }
            
            // Cast string to int
            let semester = Int16(semesterText)!
            let year = Int16(yearText)!
            
            // Check values 1<=year<=99 && 1<=semester<=99
            if(semester < 1 || semester > 2 || year < 1 || year > 10){
                return;
            }
            
            // Create a Subject object from an Entity Model
            let semesterObj = Semester(context: PersistenceService.context)
            semesterObj.year = year
            semesterObj.semester = semester
            
            // Update This Table
            PersistenceService.saveContext()
            self.semesters.append(semesterObj)
            self.tableView.reloadData()
            print("Semester Added")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("Add Semester Canceled")
        })
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    // Return ECTS and Average for the current semester
    func semesterECTSandAverage(semester: Semester) -> (Int, Float){
        // Fetch Subjects
        let subjects: [Subject] = SubjectsTableViewController.fetchSubjectsBySemester(semester: semester)
        
        var totalEcts: Int = 0
        var sum: Float = 0
        
        for subject in subjects {
            let ects = Int(subject.ects)
            let grade = Float(subject.grade)
            
            totalEcts += ects
            
            let total: Float = Float(ects) * grade
            
            sum += total
        }
        
        if(totalEcts == 0){
            return (0,0)
        }
        
        // Proceed final calculation
        
        let average: Float = sum / Float(totalEcts)
        
        return (totalEcts, average)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return semesters.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let semester: Semester = semesters[indexPath.row]
        
        // Add the cast to the specific cell representation -> Semester
        // Also indicate the Identifier -> semesterCell described in Interface Builder
        let cell: SemesterTableViewCell = tableView.dequeueReusableCell(withIdentifier: SemesterTableViewCell.cellReuseIdentifier, for: indexPath) as! SemesterTableViewCell
        
        let (ects, average) = semesterECTSandAverage(semester: semester)
        
        // No Values to show
        if(ects <= 0 || average < 10){
            // Configure the cell...
            cell.fillCell(yearValue: String(semester.year), semesterValue: String(semester.semester), ectsValue: String(" "), averageValue: String(" "))
        }else{
            // Configure the cell...
            cell.fillCell(yearValue: String(semester.year), semesterValue: String(semester.semester), ectsValue: String(ects), averageValue: String(format: "%.2f", average))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let subjectsTVC = storyBoard.instantiateViewController(withIdentifier: "SubjectsTableViewController") as! SubjectsTableViewController;
        
        // Assign Value
        subjectsTVC.semester = semesters[indexPath.row]
        
        
        self.navigationController?.pushViewController(subjectsTVC, animated: true)
        
        // Go to other ControllerView and send the semester to get the associated subjects
        //self.performSegue(withIdentifier: "semesterSubjects", sender: semester)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            // Delete a semester giving the cell row
            let semester = semesters[indexPath.row]
            PersistenceService.context.delete(semester)
            PersistenceService.saveContext()
            
            // Load updated persons entity and reload table content
            self.loadFromCoreData()

            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
