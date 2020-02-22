//
//  ViewController.swift
//  MapKit-NYC-Schools-Lab
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    private let locationSession = CoreLocationSession()
    
    private var schools = [School]() {
        didSet {
            dump(schools)
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        loadSchools()
        loadMapView()
    }

    private func loadSchools() {
        NYCSchoolsAPIClient.getSchools { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print(appError)
            case .success(let schools):
                self?.schools = schools
                DispatchQueue.main.async {
                    self?.loadMapView()
                }
            }
        }
    }
    
    private func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for school in schools {
            
            guard let latitude = Double(school.latitude), let longitude = Double(school.longitude) else {
                break
            }

            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = school.school_name
            annotations.append(annotation)
        }
        dump(annotations)
        return annotations
    }
    
    private func loadMapView() {
        let annotations = makeAnnotations()
        mapView.addAnnotations(annotations)
        
        mapView.showAnnotations(annotations, animated: true)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("did select")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let identifier = "locationAnnotation"
        var annotationView: MKPinAnnotationView
        
        if let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView = dequeView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
}
