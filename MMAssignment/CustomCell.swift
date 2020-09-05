//
//  CustomCell.swift
//  MMAssignment
//
//  Created by Harshal Dhokate on 05/09/20.
//  Copyright © 2020 Harshal Dhokate. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lblAuthorName: UILabel!
    
    func setData() {
        self.imageView.image = UIImage(named: "abc")
        self.lblAuthorName.text = "My Author"
    }
}
