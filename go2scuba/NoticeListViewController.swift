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

class NoticeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - 아웃렛
    @IBOutlet weak var noticeTable: UITableView!

    // MARK: - 변수
    var arrItems = [[String:AnyObject]]() //Array of dictionary
    var noticeitems: [NoticeItem]? = []
    
    // MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNoticeData()
        
        noticeTable.dataSource = self
        noticeTable.delegate = self
        
        // 스와이프로 뒤로 가기
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
       
    }
    
    // MARK: - 테이블뷰
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell") as! NoticeCell
        let wr_content = self.noticeitems![indexPath.row].wr_content!
        
        cell.noticeLabel.text = self.noticeitems![indexPath.row].wr_subject
        cell.contentsLabel.text = wr_content
        cell.dateLabel.text = "\(String(describing: self.noticeitems![indexPath.row].wr_date!)) \(String(describing: self.noticeitems![indexPath.row].wr_time!))"
        cell.thumbImageView.image = self.noticeitems![indexPath.row].wr_thumb
        
        cell.periodLabel.text = "\(self.noticeitems![indexPath.row].wr_sdate ?? "") ~ \(self.noticeitems![indexPath.row].wr_edate ?? " ")"
        cell.locationLabel.text = "\(self.noticeitems![indexPath.row].wr_country ?? "") \(self.noticeitems![indexPath.row].wr_location ?? "") "
        
        return cell
    }
    
    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 176;
    }
    // 테이블 섹션 헤더
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     // 테이블 Row 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.noticeitems?.count)!
    }
    
    // MARK: - 데이터 가져오기
    func getNoticeData() {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 5
        
        Alamofire.request("http://go2gether.me/bbs/api.php?bo_table=go2gether").responseJSON { response in
            
            if response.result.isSuccess {

                if let json_value = response.result.value {
                    
                    let swiftyJsonVar = JSON(json_value)
                    
//                    debugPrint(json_value)
//                    debugPrint(swiftyJsonVar)
                    
                    if let items = swiftyJsonVar["items"].arrayObject {
                        
                        self.arrItems = items as! [[String:AnyObject]]
                        
                        for item in self.arrItems {
                            
                            var wr_date_array = item["wr_datetime"]?.components(separatedBy: " ")
                            var wr_date:String
                            var wr_time:String
                            var wr_sdate:String?
                            var wr_edate:String?
                            var wr_country:String?
                            var wr_location:String?
                            
                            
                            wr_date = wr_date_array![0]
                            wr_time = wr_date_array![1]
                            
                            
                            wr_sdate = item["wr_1"] as? String
                            wr_edate = item["wr_2"] as? String
                            wr_country = item["wr_3"] as? String
                            wr_location = item["wr_4"] as? String
                            
                            // HTML 제거
                            var wr_content = Functions.removeHtmlFromString(inPutString: item["wr_content"] as! String)
                            // 내용 길이가 40자보다 크면 글자를 자른다.
                            if wr_content.count > 40 {
                                wr_content = Functions.subString(orgString: wr_content, startIndex: 0, endIndex: 60)
                            }
                            
                            let thumb = item["thumb"] as? String
                            let gPhotoURL = "\(String(describing: thumb!))"
                            var thumbImage:UIImage = UIImage()
                            let url = URL(string: gPhotoURL)
                            let data = try? Data(contentsOf: url!)
                            thumbImage = UIImage(data: data!)!
                            
                            self.noticeitems?.append(
                                NoticeItem(
                                    wr_id: (item["wr_id"] as! String),
                                    wr_subject: (item["wr_subject"] as? String),
                                    wr_name: (item["wr_name"] as? String),
                                    wr_content: wr_content,
                                    wr_date: (wr_date),
                                    wr_time: (wr_time),
                                    wr_thumb: (thumbImage),
                                    wr_sdate : wr_sdate,
                                    wr_edate : wr_edate,
                                    wr_country : wr_country,
                                    wr_location : wr_location
                                )
                            )
                            
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.noticeTable.reloadData()
                    }
                }
            } else {
                debugPrint(response.result.error as Any)
                let errorMessage = "General Error"
                Toast(text: errorMessage).show()
            }
            
        }
    }
    

}

