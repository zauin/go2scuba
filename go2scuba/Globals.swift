//
//  Globals.swift
//  HouseCare
//
//  Created by zauin on 2018. 3. 21..
//  Copyright © 2018년 zauin. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SCLAlertView

class Globals {
    static let sharedInstance = Globals()
    
    var startViewController:String = "FirstViewController"
    var userInfo:JSON = ""
    
    var dimmedLayer = UIView()
    
    // Networking: communicating server
    func network() {
        // get everything
    }
    
    private init() {
        
    }
    
    var apiInfo = (
        Host: "http://13.125.86.238:3000"
        , headers: ["User-Agent": "HouseCare/1.0 (iOS 10.3.3; iPhone 6;)"]
        , Agent: "HouseCare/1.0 (iOS 10.3.3; iPhone 6;)"
        , Init: "/v1/common/init.php"
        , Main: "/v1/common/main.php"                       // Main페이지 데이터 가져오기
        , IsAvalilable: "/v1/user/sign/is_available.php"    // 이메일 중복 여부
        , FindPassword: "/v1/user/find_password.php"        // 비밀번호 찾기
        , Signup: " /v1/user/signup.php"                    // 회원가입
        , Login: "/v1/user/login.php"                       // 로그인
        , CurrentCost: "/v1/my/current_cost.php"            // Current Cost
        , Completed: "/v1/my/completed_job.php"             // Completed Job
        , Reserved: "/v1/my/reserved_job.php"               // Reserved Job
        , Recommend: "/v1/job/recommend.php"                // Recommended Job
        , Schedule: "/v1/job/schedule.php"                  // 스케줄 캘린더
        , JobInfo: "/v1/job/info.php"                       // Job Info
        , Profile: "/v1/my/profile.php"                     // 프로필
        , Salary: "/v1/my/salary.php"                       // Salary
        , JobStart: "/v1/job/start.php"                     // Job Start Before, Step 1
        , JobStatus: "/v1/job/status.php"                   // Job Status, Step 2
    )
    
    var signUpInfo = (
        email: "", Password: ""
    )
    
    // parameters
    var signupData = [String:AnyObject]()
    
    let appearance = SCLAlertView.SCLAppearance(showCircularIcon: false)
    
    let imageStore = ImageStore()
    var profileImageExists: Bool = false
    
    var jobBeforePhotoCount = 0
    
}


// <!-- User Defaults 에 Key로 저장하기 위한 프로토콜
protocol KeyNamespaceable {
    func namespaced<T : RawRepresentable>(_ key: T) -> String
}

extension KeyNamespaceable {
    func namespaced<T: RawRepresentable>(_ key: T) -> String {
        return "\(Self.self).\(key.rawValue)"
    }
}

protocol StringDefaultSettable : KeyNamespaceable {
    associatedtype StringKey : RawRepresentable
}

extension StringDefaultSettable where StringKey.RawValue == String {
    func set(_ value: String, forKey key: StringKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    @discardableResult
    func string(forKey key: StringKey) -> String? {
        let key = namespaced(key)
        return UserDefaults.standard.string(forKey: key)
    }
}

extension UserDefaults : StringDefaultSettable {
    enum StringKey : String {
        case userID
        case lastName
        case firstName
        case nickName
        case photoURL
        case authKey
        case userData
    }
}
// User Defaults 에 Key로 저장하기 위한 프로토콜 -->

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension Date {
    
    func nomalString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: self)
    }
    
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    func dayAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd")
        return df.string(from: self)
    }
    
    func yyyymmString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM"
        return df.string(from: self)
    }
     
    
}

extension NSNumber {
    
    func numberString() -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        
        return nf.string(from: self)!
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        print("hideKeyboardWhenTappedAround")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        print("dismissKeyboard")
        view.endEditing(true)
    }
}



extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String, outputFormat:String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}

extension Date {
    
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
}
