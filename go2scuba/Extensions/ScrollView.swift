//
//  ScrollView.swift
//  HouseCare
//
//  Created by zauin on 2018. 3. 16..
//  Copyright © 2018년 zauin. All rights reserved.
//

import UIKit


extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            
            contentRect = contentRect.union(view.frame)
            
        }
        
        self.contentSize = contentRect.size
        
    }
    
}
