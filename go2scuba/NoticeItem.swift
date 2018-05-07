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
    var wr_sdate: String? // wr_1 nullable
    var wr_edate: String? // wr_2 nullable
    var wr_country: String? // wr_3
    var wr_location: String? // wr_4
    
    
    init(wr_id: String, wr_subject: String?, wr_name: String?, wr_content: String?, wr_date:String?, wr_time:String?, wr_thumb:UIImage?, wr_sdate: String?, wr_edate: String?, wr_country: String?, wr_location: String?
        ) {
        self.wr_id = wr_id
        self.wr_subject = wr_subject
        self.wr_name = wr_name
        self.wr_content = wr_content
        self.wr_date = wr_date
        self.wr_time = wr_time
        self.wr_thumb = wr_thumb
        self.wr_sdate = wr_sdate
        self.wr_edate = wr_edate
        self.wr_country = wr_country
        self.wr_location = wr_location
    }
    
}
