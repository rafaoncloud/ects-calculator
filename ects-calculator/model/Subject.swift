//
//  Subject.swift
//  ects-calculator
//
//  Created by Rafael Henriques on 23/08/2018.
//  Copyright © 2018 rafaoncloud. All rights reserved.
//

import Foundation

class Subject {
    
    let id: Int
    let semesterId: Int
    let subjectAbbreviation: String
    let subjectFullName: String
    let ects: Int
    let grade: Int
    
    convenience init(semesterId: Int, subjectAbbreviation: String, subjectFullName: String, ects: Int, grade: Int) {
        self.init(id: -1, semesterId: semesterId, subjectAbbreviation: subjectAbbreviation, subjectFullName: subjectFullName, ects: ects, grade: grade)
    }
    
    init(id: Int, semesterId: Int, subjectAbbreviation: String, subjectFullName: String, ects: Int, grade: Int) {
        self.id = id
        self.semesterId = semesterId
        self.subjectAbbreviation = subjectAbbreviation
        self.subjectFullName = subjectFullName
        self.ects = ects
        self.grade = grade
    }
    
}
