//
//  CustomHeaderView.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 26.03.2021.
//

import UIKit

protocol HeaderViewDelegate: class {
    func expandedSection(button: UIButton)
}

class CustomHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: HeaderViewDelegate?

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func tapHeader(_ sender: UIButton) {
        delegate?.expandedSection(button: sender)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
