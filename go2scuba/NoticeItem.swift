//
//  NoticeItem.swift
//  HouseCare
//
//  Created by zauin on 2018. 3. 9..
//  Copyright © 2018년 zauin. All rights reserved.
//

import UIKit

class NoticeItem: NSObject {
    
    var wr_id: String
    var wr_subject: String?
    var wr_name: String?
    var wr_content: String?
    var wr_date: String?
    var wr_time: String?
    var wr_thumb: UIImage?
    
    init(wr_id: String, wr_subject: String?, wr_name: String?, wr_content: String?, wr_date:String?, wr_time:String?, wr_thumb:UIImage?) {
        self.wr_id = wr_id
        self.wr_subject = wr_subject
        self.wr_name = wr_name
        self.wr_content = wr_content
        self.wr_date = wr_date
        self.wr_time = wr_time
        self.wr_thumb = wr_thumb
    }
    
}
