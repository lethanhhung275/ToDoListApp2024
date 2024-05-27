//
//  TodoCell.swift
//  ToDoListApp2024
//
//  Created by Lê Hưng on 26/5/24.
//

import UIKit

class TodoCell: UITableViewCell {
    // Properties
    @IBOutlet weak var todoTitle: UILabel!
    @IBOutlet weak var todoDescription: UILabel!
    @IBOutlet weak var todoTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
