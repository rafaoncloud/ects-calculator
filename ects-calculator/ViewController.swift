//
//  ViewController.swift
//  ects-calculator
//
//  Created by Rafael Henriques on 22/08/2018.
//  Copyright © 2018 rafaoncloud. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var ectsValueLbl: UILabel!
    @IBOutlet weak var averageValueLbl: UILabel!
    @IBOutlet weak var averageValueDecimalLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let (ects, average) = semesterECTSandAverage()
        if(ects <= 0 || average < 10){
            self.ectsValueLbl?.text = String("0")
            self.averageValueLbl?.text = String("--")
            self.averageValueDecimalLbl?.text = String(" ")
        }
        
        self.ectsValueLbl?.text = String(ects)
        self.averageValueLbl?.text = String(Int(average.rounded()))
        self.averageValueDecimalLbl?.text = String(format: "%.2f", average)
    }

    override func viewDidAppear(_ animated: Bool) {
        let (ects, average) = semesterECTSandAverage()
        if(ects <= 0 || average < 10){
            self.ectsValueLbl?.text = String("0")
            self.averageValueLbl?.text = String("--")
            self.averageValueDecimalLbl?.text = String(" ")
        }
        
        self.ectsValueLbl?.text = String(ects)
        self.averageValueLbl?.text = String(Int(average.rounded()))
        self.averageValueDecimalLbl?.text = String(format: "%.2f", average)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Return ECTS and Average for all subjects
    func semesterECTSandAverage() -> (Int, Float){
        // Fetch Subjects
        let subjects = fetchAllSubjects()
        
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
    
    // Load All Subjects
    func fetchAllSubjects() -> [Subject] {
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
    
        // Load semesters
        do{
            let subjects = try PersistenceService.context.fetch(fetchRequest)
            return subjects
        }catch {}
        
        return []
    }
    
}

