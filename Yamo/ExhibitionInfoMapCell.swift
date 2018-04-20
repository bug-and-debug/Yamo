//
//  ExhibitionInfoMapCell.swift
//  Yamo
//
//  Created by Hungju Lu on 24/05/2016.
//  Copyright © 2016 Locassa. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

let ExhibitionInfoMapCellNibName = "ExhibitionInfoMapCell"
let ExhibitionInfoMapCellDefaultHeight: CGFloat = 250.0

class ExhibitionInfoMapCell: ExhibitionInfoCell {

    @IBOutlet weak var mapView: MKMapView!
    
    private var viewConfigured: Bool = false
    
    private var coordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var takeMeThereButton: UIButton!
    
    @IBOutlet weak var takeMeThereButtonHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mapView.userInteractionEnabled = false
        
        let attributes = [NSFontAttributeName: UIFont.preferredFontForStyle(.GraphikRegular, size: 14.0),
                          NSKernAttributeName: NSNumber.kernValueWithStyle(.Regular, fontSize: 14.0),
                          NSForegroundColorAttributeName: UIColor.yamoDarkGray()]
        let takeMeThereButtonTitle = NSAttributedString(string: NSLocalizedString("Take me there", comment: ""), attributes: attributes)

        self.takeMeThereButton.setAttributedTitle(takeMeThereButtonTitle, forState: .Normal)
        self.takeMeThereButton.clipsToBounds = true
        
        self.takeMeThereButtonHeightConstraint.constant = 0.0
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ExhibitionInfoMapCell.mapTapped(_:)))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - View Configuration
    
    func configureView(dataUpdated dataUpdated: Bool, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        if !self.viewConfigured || dataUpdated {
            
            let currentAnnotations = self.mapView.annotations
            if let annotation = currentAnnotations.first as? MKPointAnnotation {
                annotation.coordinate = coordinate
            } else {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                self.mapView.addAnnotation(annotation)
            }
            
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.region = region
        
            self.viewConfigured = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func routeButtonPressed(sender: UIButton) {
        self.delegate?.exhibitionInfoCellDidRequireRoute?(self)
    }
    
    func mapTapped(gesture: UITapGestureRecognizer) {
        self.delegate?.exhibitionInfoCellDidRequireRoute?(self)
        
    }
}
