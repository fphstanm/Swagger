//
//  TableViewCell.swift
//  Swagger
//
//  Created by Philip on 14.01.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var characterLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    
    
    func setup(withCharacter character: Character, number: Int) {
        characterLabel.text = String(character)
        numberLabel.text = String(number)
    }
}
