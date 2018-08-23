//
//  Semester.swift
//  ects-calculator
//
//  Created by Rafael Henriques on 23/08/2018.
//  Copyright © 2018 rafaoncloud. All rights reserved.
//

import Foundation

class Semester {
    
    let id: Int;
    let year: Int;
    let semester: Int;
    var subjects: [Subject]
    
    convenience init(year: Int, semester: Int) {
        self.init(id: -1, year: year, semester: semester, subjects: [])
    }
    
    init(id: Int, year: Int, semester: Int, subjects:[Subject]) {
        self.id = id
        self.year = year
        self.semester = semester
        self.subjects = subjects
    }
}
