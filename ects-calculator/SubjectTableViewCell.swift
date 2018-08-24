//
//  SubjectTableViewCell.swift
//  ects-calculator
//
//  Created by Rafael Henriques on 24/08/2018.
//  Copyright © 2018 rafaoncloud. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {

    static let cellReuseIdentifier: String = "subjectCell"
    
    @IBOutlet weak var abbreviationLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var ectsLbl: UILabel!
    @IBOutlet weak var gradeLbl: UILabel!
    
    @IBOutlet weak var ectsValueLbl: UILabel!
    @IBOutlet weak var gradeValueLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
