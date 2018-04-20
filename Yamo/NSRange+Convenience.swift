//
//  NSRange+Convenience.swift
//  Yamo
//
//  Created by Mo Moosa on 31/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import Foundation

extension NSRange {
    
    func toRange(string: String) -> Range<String.Index> {
    
        let startIndex = string.startIndex.advancedBy(location)
        let endIndex = string.startIndex.advancedBy(length)
        return startIndex..<endIndex
    }
}