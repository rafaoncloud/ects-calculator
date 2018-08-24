//
//  SemesterTableViewCell.swift
//  ects-calculator
//
//  Created by Rafael Henriques on 24/08/2018.
//  Copyright © 2018 rafaoncloud. All rights reserved.
//

import UIKit

class SemesterTableViewCell: UITableViewCell {

    static let cellReuseIdentifier: String = "semesterCell"
    
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var semesterLbl: UILabel!
    @IBOutlet weak var ectsLbl: UILabel!
    @IBOutlet weak var averageLbl: UILabel!
    
    @IBOutlet weak var yearValueLbl: UILabel!
    @IBOutlet weak var semesterValueLbl: UILabel!
    @IBOutlet weak var ectsValueLbl: UILabel!
    @IBOutlet weak var averageValueLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillCell(yearValue: String, semesterValue: String, ectsValue: String, averageValue: String) {
        self.yearValueLbl?.text = yearValue
        self.semesterValueLbl?.text = semesterValue
        self.ectsValueLbl?.text = ectsValue
        self.averageValueLbl?.text = averageValue
    }
}
