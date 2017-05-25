//
//  FieldDatePickerTableViewCell.swift
//  Boomerang
//
//  Created by Felipe perius on 20/05/17.
//  Copyright © 2017 Lab262. All rights reserved.
//

import UIKit

class FieldDatePickerTableViewCell: UITableViewCell {
    static var cellIdentifier = "FieldDatePickerTableViewCell"
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.setDynamicFont()
        self.dateTextField.font = UIFont(name: (self.dateTextField.font?.fontName)!, size: (self.dateTextField.font?.pointSize)!*UIView.widthScaleProportion())!
        // Initialization code
    }
    @IBAction func textFieldEditing(_ sender: Any) {
    
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        //(sender as AnyObject).inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    
    }
    func handleDatePicker(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
