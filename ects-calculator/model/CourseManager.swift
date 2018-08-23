//
//  CourseManager.swift
//  ects-calculator
//
//  Created by Rafael Henriques on 23/08/2018.
//  Copyright © 2018 rafaoncloud. All rights reserved.
//

import Foundation

class CourseManager {
    
    var semesters: [Semester] = []
    var subjects: [Subject] = []
    
    init(semesters: [Semester], subjects: [Subject]) {
        self.semesters = semesters
        self.subjects = subjects
    }
}
