//
//  Functions.swift
//  HouseCare
//
//  Created by zauin on 2018. 3. 8..
//  Copyright © 2018년 zauin. All rights reserved.
//

import Foundation
import UIKit
import DatePickerDialog
import SwiftyJSON
import Alamofire
import SCLAlertView
import MapKit

class Functions {
    
    
    // 초기 데이터 가져오기
    static func appInit() {
        
        var mainInfo = JSON()
        
        let api = Globals.sharedInstance.apiInfo.Init
        let url = "\(Globals.sharedInstance.apiInfo.Host)\(api)"

        Alamofire.request( url,
                           method: .get,
                           encoding: URLEncoding.default,
                           headers: Globals.sharedInstance.apiInfo.headers ).responseJSON { response in
                            
                            if response.result.isFailure {
                                //In case of failure
                                print("Network Response Fail")
                                
                                SCLAlertView(appearance: Globals.sharedInstance.appearance).showCustom("Error", subTitle: "Network Failure", color: Functions.uiColorFromString(color: "FA526E"), icon: UIImage(), animationStyle: .noAnimation)
                                
                            } else {
                                //in case of success
                                print("API 통신 성공")
                                
                                if let json_value = response.result.value {
                                    let json = JSON(json_value)
                                    let reason = json["reason"].string!
                                    let code = json["code"].string!
                                    
                                    if code == "0000" {
                                        // 결과도 성공
                                        mainInfo = json["data"]
                                        
                                        // 도시 코드 목록 저장
                                        if let cityCodeList = mainInfo["open_job_search"]["city_code_list"].arrayObject {
                                            let cityCodeLists = cityCodeList as! [[String:AnyObject]]
                                            Globals.sharedInstance.cityCodeData  = cityCodeLists
                                        }
                                        
                                        // Price 코드 목록 저장
                                        if let priceCodeList = mainInfo["open_job_search"]["price_code_list"].arrayObject {
                                            let priceCodeLists = priceCodeList as! [[String:AnyObject]]
                                            Globals.sharedInstance.priceCodeData  = priceCodeLists
                                        }
                                        
                                        // Level 코드 목록 저장
                                        if let levelCodeList = mainInfo["open_job_search"]["level_code_list"].arrayObject {
                                            let levelCodeLists = levelCodeList as! [[String:AnyObject]]
                                            Globals.sharedInstance.levelCodeData  = levelCodeLists
                                        }
                                        
                                        // Time 코드 목록 저장
                                        if let timeCodeList = mainInfo["open_job_search"]["time_code_list"].arrayObject {
                                            let timeCodeLists = timeCodeList as! [[String:AnyObject]]
                                            Globals.sharedInstance.timeCodeData  = timeCodeLists
                                        }
                                        
                                        // debugPrint(Globals.sharedInstance.cityCodeData[0])
                                        
//                                        for i in 0...(Globals.sharedInstance.cityCodeData.count-1) {
//                                            debugPrint(Globals.sharedInstance.cityCodeData[i]["code"] as! String)
//                                        }
                                        
                                    } else {
                                        
                                        Functions.showError(reason)
                                        
                                    }
                                }
                            }
        } // --> Alamofire
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // 컬러 코드를 UIColor 로 변환
    static func uiColorFromString(color:String)->UIColor {
        
        let rgbValue = UInt32(color.replacingOccurrences(of: "#", with: ""), radix: 16)!
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    // Dimmed Layer 추가
    static func addDimmedLayer(selfView:UIView) -> UIView {
        let viewSize: CGRect = selfView.frame
        let dimmedLayer = UIView(frame: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        dimmedLayer.alpha = 0.6
        dimmedLayer.backgroundColor = UIColor.black
        
        return dimmedLayer
    }
    
    // 날짜 관련 함수 : 현재 시각 구하기 "yyyy-MM-dd HH:mm:ss"
    static func getNow() -> Date {
        // current day & time
        let now = Date()
        // 데이터 포맷터
        let dateFormatter = DateFormatter()
        // Locale
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.string(from: now)
        
        return now
    }
    
    // 날짜 : zDateFormatter
    static func zDateFormatter(pDate: Date, pFormat: String) -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate(pFormat)
        return df.string(from: pDate)
    }
    
    static func getCurrentDate()-> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = NSTimeZone.local
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    // 다음달, 이전달 구하기
    static func getMonthToGo(offset: Int, baseDate:Date)-> Date {
        var dateComponent = DateComponents()
        dateComponent.month = offset
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: baseDate)
        print(futureDate!)
        return futureDate!
    }
    
    // Indicator 보이기
    static func showIndicator(selfView:UIView) {
        // Dimmed Layer
        print("Show Indicator")
        let screenRect = UIScreen.main.bounds
        Globals.sharedInstance.dimmedLayer = UIView(frame: screenRect)
        Globals.sharedInstance.dimmedLayer.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        selfView.addSubview(Globals.sharedInstance.dimmedLayer)
        
        // Add Indicator
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = Functions.uiColorFromString(color: "4DB6AC")
        activityView.hidesWhenStopped = true
        activityView.center = Globals.sharedInstance.dimmedLayer.center
        activityView.startAnimating()
        Globals.sharedInstance.dimmedLayer.addSubview(activityView)
        
    }
    
    // Indicator 감추기
    static func hideIndicator() {
        // Dimmed Layer
        print("Hide Indicator")
        Globals.sharedInstance.dimmedLayer.removeFromSuperview()
    }
    
    // HTML 제거
    static func removeHtmlFromString(inPutString: String) -> String{
        var resultString = inPutString.replacingOccurrences(of: "<[^>]+>|&nbsp;", with: "", options: .regularExpression, range: nil)
        resultString = resultString.replacingOccurrences(of: "  ", with: " ", options: .regularExpression, range: nil)
        return resultString
    }
    
    // SubString
    static func subString(orgString: String, startIndex: Int, endIndex: Int) -> String {
        let end = (endIndex - orgString.count) + 1
        let indexStartOfText = orgString.index(orgString.startIndex, offsetBy: startIndex)
        let indexEndOfText = orgString.index(orgString.endIndex, offsetBy: end)
        let substring = orgString[indexStartOfText..<indexEndOfText]
        return String(substring)
    }
    
    // DatePicker for Text Field
    static func datePickerTapped(textField: UITextField) {
        var defaultDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if textField.text != "" {
            defaultDate = formatter.date(from: textField.text!)!
        }
        
        let prefferedLanguage = Locale.preferredLanguages[0] as String
        
        let datePicker = DatePickerDialog(textColor: .darkGray,
                                          buttonColor: .darkGray,
                                          font: UIFont.boldSystemFont(ofSize: 14),
                                          locale: Locale(identifier: prefferedLanguage),
                                          showCancelButton: true
        )
        
        datePicker.show("Select Date", doneButtonTitle: "OK", cancelButtonTitle: "Cancel",
                        //                        minimumDate: threeMonthAgo,
            //                        maximumDate: currentDate,
            defaultDate: defaultDate,
            datePickerMode: .date) { (date) in
                if let dt = date {
                    textField.text = formatter.string(from: dt)
                }
        }
    }
    // Email 형식 체크
    static func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // Save JSON type to defaults
    static func saveJSON(json: JSON, key:String){
        let defaults = UserDefaults.standard
        let jsonString = json.rawString()!
        defaults.setValue(jsonString, forKey: key)
        defaults.synchronize()
    }
    // User Defaults에서 Json 구하기
    static func getJSON(_ key: String)->JSON {
        let defaults = UserDefaults.standard
        var p = ""
        if let buildNumber = defaults.value(forKey: key) as? String {
            p = buildNumber
        }else {
            p = ""
        }
        if  p != "" {
            if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                return try! JSON(data: json)
            } else {
                return JSON("nil")
            }
        } else {
            return JSON("nil")
        }
    }
    
    // Show Error Pop up
    static func showError(_ msg: String) {
        SCLAlertView(appearance: Globals.sharedInstance.appearance).showCustom(
            "Error",
            subTitle: msg,
            color: self.uiColorFromString(color: "FA526E"),
            icon: UIImage(),
            animationStyle: .noAnimation)
    }
    
    // 지도보이기
    static func showMap(mapView: MKMapView, location: CLLocationCoordinate2D, artwork: Artwork) {
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(artwork)
    }
    
    
    
//    static func updateTimer(seconds: Int) -> String {
//        var sec = seconds
//        var timer = Timer()
//        if sec < 1 {
//            timer.invalidate()
//            return ""
//        } else {
//            sec = sec - 1
//            return timeString(time: TimeInterval(sec))
//        }
//    }
//    
    static func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
//
//    static func runTimer(seconds: Int) {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
//                                     selector: Selector(updateTimer(seconds: seconds)),
//                                     userInfo: nil, repeats: true)
//    }
}

