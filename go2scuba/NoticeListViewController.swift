//
//  NoticeListViewController.swift
//  HouseCare
//
//  Created by zauin on 2018. 3. 13..
//  Copyright © 2018년 zauin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toaster


// Alamofire 사용법
// https://outofbedlam.github.io/swift/2016/02/04/Alamofire/

class NoticeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var noticeTable: UITableView!

    var arrItems = [[String:AnyObject]]() //Array of dictionary
    var noticeitems: [NoticeItem]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNoticeData()
        
        // 스와이프로 뒤로 가기
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
       
    }
    // 셀 정의 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell") as! NoticeCell
        let wr_content = self.noticeitems![indexPath.row].wr_content!
        
        cell.noticeLabel.text = self.noticeitems![indexPath.row].wr_subject
        cell.contentsLabel.text = wr_content
        cell.dateLabel.text = "\(String(describing: self.noticeitems![indexPath.row].wr_date!)) \(String(describing: self.noticeitems![indexPath.row].wr_time!))"
        cell.thumbImageView.image = self.noticeitems![indexPath.row].wr_thumb
        print(wr_content )
        
        return cell
    }
    
    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0;
    }
    // 테이블 섹션 헤더
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     // 테이블 Row 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.noticeitems?.count)!
    }
    
    
    func getNoticeData() {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 5
        
        Alamofire.request("http://go2gether.me/bbs/api.php?bo_table=go2gether").responseJSON { response in
            
            if response.result.isSuccess {

                if let json_value = response.result.value {
                    
                    let swiftyJsonVar = JSON(json_value)
                    
                    debugPrint(json_value)
//                    debugPrint(swiftyJsonVar)
                    
                    if let items = swiftyJsonVar["items"].arrayObject {
                        
                        self.arrItems = items as! [[String:AnyObject]]
                        
                        for item in self.arrItems {
                            
                            var wr_date_array = item["wr_datetime"]?.components(separatedBy: " ")
                            
                            var wr_date:String
                            var wr_time:String
                            
                            wr_date = wr_date_array![0]
                            wr_time = wr_date_array![1]
//
//                            self.noticeitems = [
//                                NoticeItem(
//                                    wr_id: (item["wr_id"] as! String),
//                                    wr_subject: (item["wr_subject"] as? String),
//                                    wr_name: (item["wr_name"] as? String),
//                                    wr_content: (item["wr_content"] as? String),
//                                    wr_date: (wr_date),
//                                    wr_time: (wr_time)
//                                )
//                            ]
//
                            // HTML 제거
                            var wr_content = Functions.removeHtmlFromString(inPutString: item["wr_content"] as! String)
                            // 내용 길이가 40자보다 크면 글자를 자른다.
                            if wr_content.count > 40 {
                                wr_content = Functions.subString(orgString: wr_content, startIndex: 0, endIndex: 40)
                            }
                            
                            let gPhotoURL = item["thumb"] as? String
                            var thumbImage:UIImage = UIImage()
                            if let photoURL = gPhotoURL {
                                let url = URL(string: photoURL)
                                let data = try? Data(contentsOf: url!)
                                thumbImage = UIImage(data: data!)!
                            }
                            
                            self.noticeitems?.append(
                                NoticeItem(
                                    wr_id: (item["wr_id"] as! String),
                                    wr_subject: (item["wr_subject"] as? String),
                                    wr_name: (item["wr_name"] as? String),
                                    wr_content: wr_content,
                                    wr_date: (wr_date),
                                    wr_time: (wr_time),
                                    wr_thumb: (thumbImage)
                                )
                            )
                            
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.noticeTable.reloadData()
                    }
                }
            } else {
                debugPrint(response.result.error)
                var errorMessage = "General Error"
                Toast(text: errorMessage).show()
            }
            
        }
    }
    

}

