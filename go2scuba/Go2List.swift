//
//  Go2List.swift
//  go2scuba
//
//  Created by zauin on 2018. 5. 8..
//  Copyright © 2018년 go2gether. All rights reserved.
//


import UIKit

class Go2List : Equatable {
    /*
    var thumbnail : UIImage?
    var largeImage : UIImage?
    let photoID : String
    let farm : Int
    let server : String
    let secret : String
    
    init (photoID:String,farm:Int, server:String, secret:String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
    }
    */
    
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
    
    
    init(wr_id: String, wr_subject: String?, wr_name: String?, wr_content: String?, wr_date:String?, wr_time:String?, wr_sdate: String?, wr_edate: String?, wr_country: String?, wr_location: String?
        ) {
        self.wr_id = wr_id
        self.wr_subject = wr_subject
        self.wr_name = wr_name
        self.wr_content = wr_content
        self.wr_date = wr_date
        self.wr_time = wr_time 
        self.wr_sdate = wr_sdate
        self.wr_edate = wr_edate
        self.wr_country = wr_country
        self.wr_location = wr_location
    }
    
    
    func sizeToFillWidthOfSize(_ size:CGSize) -> CGSize {
        
        guard let thumbnail = wr_thumb else {
            return size
        }
        
        let imageSize = thumbnail.size
        var returnSize = size
        
        let aspectRatio = imageSize.width / imageSize.height
        
        returnSize.height = returnSize.width / aspectRatio
        
        if returnSize.height > size.height {
            returnSize.height = size.height
            returnSize.width = size.height * aspectRatio
        }
        
        return returnSize
    }
    
}

func == (lhs: Go2List, rhs: Go2List) -> Bool {
    return lhs.wr_id == rhs.wr_id
}
