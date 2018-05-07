//
//  NoticeCell.swift
//  HouseCare
//
//  Created by zauin on 2018. 3. 13..
//  Copyright © 2018년 zauin. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {
    
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var tableViewController: UITableViewController!
    
    var isSub = false
    
    var rowNum: Int!
    
    var isComplete = false
    
}
