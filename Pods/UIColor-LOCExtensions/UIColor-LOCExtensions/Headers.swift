//
//  Header.swift
//  UIColor+LOCExtensions
//
//  Created by Jose Fernandez on 15/03/2016.
//  Copyright © 2016 locassa. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    typealias LOCColor = UIColor
#else
    import Cocoa
    typealias LOCColor = NSColor
#endif

