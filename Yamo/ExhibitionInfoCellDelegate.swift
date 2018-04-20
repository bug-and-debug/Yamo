//
//  ExhibitionInfoCellDelegate.swift
//  Yamo
//
//  Created by Hungju Lu on 23/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import CoreLocation

@objc protocol ExhibitionInfoCellDelegate: class {
    optional func exhibitionInfoCellDidRequireCacheState(cell: ExhibitionInfoCell)
    optional func exhibitionInfoCell(cell: ExhibitionInfoCell, didChangedContentSize size: CGSize)
    optional func exhibitionInfoCell(cell: ExhibitionInfoCell, didChangedFavorited favorited: Bool)
    optional func exhibitionInfoCellDidRequireRoute(cell: ExhibitionInfoCell)
    optional func shareExhibitionInfo()
}
