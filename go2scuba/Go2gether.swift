//
//  Go2gether.swift
//  go2scuba
//
//  Created by zauin on 2018. 5. 8..
//  Copyright © 2018년 go2gether. All rights reserved.
//

import UIKit

let apiKey = "411c1902b10bed4c6d2c6d6455a82833"

class Go2gether {
    
    let processingQueue = OperationQueue()
    
    func searchFlickrForTerm(_ searchTerm: String, completion : @escaping (_ results: Go2SearchResults?, _ error : NSError?) -> Void){
        
        guard let searchURL = flickrSearchURLForSearchTerm(searchTerm) else {
            let APIError = NSError(domain: "Go2Search", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
            completion(nil, APIError)
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: searchRequest, completionHandler: { (data, response, error) in
            
            if let _ = error {
                let APIError = NSError(domain: "Go2Search", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                OperationQueue.main.addOperation({
                    completion(nil, APIError)
                })
                return
            }
            
            // 응답이 왔는지 확인
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                    let APIError = NSError(domain: "Go2Search", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
            }
            
            do {
                
                // API 응답이 제대로 왔는지 확인
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    
                    let APIError = NSError(domain: "Go2Search", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response 3"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
                }
                
                /*
                guard
                    let resultsDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject],
                    let stat = resultsDictionary["items"] as? String else {
                        
                        let APIError = NSError(domain: "Go2Search", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response 3"])
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                        return
                }
                
                switch (stat) {
                case "ok":
                    print("Results processed OK")
                case "fail":
                    if let message = resultsDictionary["message"] {
                        
                        let APIError = NSError(domain: "Go2Search", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:message])
                        
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                    }
                    
                    let APIError = NSError(domain: "Go2Search", code: 0, userInfo: nil)
                    
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    
                    return
                default:
                    let APIError = NSError(domain: "Go2Search", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
                }
                */
                // JSON의 이미지가 제대로 있는지 확인후 객체로 임시 저장
                guard let photosReceived = resultsDictionary["items"] as? [[String: AnyObject]] else {
                    
                    let APIError = NSError(domain: "Go2Search", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
                }
                
                var go2Lists = [Go2List]()
                
                // JSON 결과를 객체에 저장
                for item in photosReceived {
                    guard let wr_id = item["wr_id"] as? String,
                        let wr_subject = item["wr_subject"] as? String else {
                            break
                    }
                    
                    let wr_name = item["wr_name"] as? String
                    var wr_content = item["wr_content"] as? String
                    
                    let wr_sdate = item["wr_1"] as? String
                    let wr_edate = item["wr_2"] as? String
                    let wr_country = item["wr_3"] as? String
                    let wr_location = item["wr_4"] as? String
                    
                    let wr_date_array = item["wr_datetime"]?.components(separatedBy: " ")
                    let wr_date = wr_date_array![0]
                    let wr_time = wr_date_array![1]
                    
                    // HTML 제거
                    wr_content = Functions.removeHtmlFromString(inPutString: wr_content!)
                    // 내용 길이가 40자보다 크면 글자를 자른다.
                    if (wr_content?.count)! > 40 {
                        wr_content = Functions.subString(orgString: wr_content!, startIndex: 0, endIndex: 60)
                    }
                    
                    let go2List = Go2List(wr_id: wr_id, wr_subject: wr_subject, wr_name: wr_name, wr_content: wr_content, wr_date: wr_date, wr_time: wr_time, wr_sdate: wr_sdate, wr_edate: wr_edate, wr_country: wr_country, wr_location: wr_location)
                    
                    let thumb = item["thumb"] as? String
                    let gPhotoURL = "\(String(describing: thumb!))"
                    var thumbImage:UIImage = UIImage()
                    let url = URL(string: gPhotoURL)
                    let data = try? Data(contentsOf: url!)
                    thumbImage = UIImage(data: data!)!
                    go2List.wr_thumb = thumbImage
                    
                    go2Lists.append(go2List)
                    
                }
                
                dump(go2Lists)
                
                OperationQueue.main.addOperation({
                    completion(Go2SearchResults(searchTerm: searchTerm, searchResults: go2Lists), nil)
                })
                
            } catch _ {
                completion(nil, nil)
                return
            }
            
            
        }) .resume()
    }
    
    fileprivate func flickrSearchURLForSearchTerm(_ searchTerm:String) -> URL? {
        
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
//        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        
        let URLString = "http://go2gether.me/bbs/api.php?bo_table=go2gether&stx=\(escapedTerm)"
        
        guard let url = URL(string:URLString) else {
            return nil
        }
        
        return url
    }
}
