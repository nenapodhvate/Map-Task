//
//  ViewController.swift
//  MapTask
//
//  Created by Akari Cloud on 08.09.20.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    //MARK: - lets,vars
    let mapView: MKMapView =  {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let addAdress: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "address"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let goTo: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "goto"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
        
    }()
    
    let reset: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reset"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
        
    }()
    
    var annotationsArray = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setConstraints()
        addAdress.addTarget(self, action: #selector(addAdressTapped), for: .touchUpInside)
        goTo.addTarget(self, action: #selector(goToTapped), for: .touchUpInside)
        reset.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
    }
    //MARK: - Methods
    @objc func addAdressTapped() {
        alertAddAddress(title: "Enter address", placeholder: "address") { [self] text in
            setupPlacemark(adressPlace: text)
        }
    }
    
    @objc func goToTapped() {
        
        for index in 0...annotationsArray.count - 2 {
            createDirectionRequest(startCoordinate: annotationsArray[index].coordinate, destonationCoordinate: annotationsArray[index+1].coordinate)
        }
        
        mapView.showAnnotations(annotationsArray, animated: true)
    }

    @objc func resetTapped() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray = [MKPointAnnotation]()
        goTo.isHidden = true
        reset.isHidden = true
    }
    
    private func setupPlacemark(adressPlace: String) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adressPlace) { [self]  (placemarks, error) in
            
            if let error = error {
                print(error)
                alertError(title: "ERROR", message: "Something went wrong. Try again!")
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = "\(adressPlace)"
            guard let placemarkLocation = placemark?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            annotationsArray.append(annotation)
            if annotationsArray.count > 2 {
                goTo.isHidden = false
                reset.isHidden = false
            }
            
            mapView.showAnnotations(annotationsArray, animated: true)
        }
    }
    
    private func createDirectionRequest(startCoordinate: CLLocationCoordinate2D, destonationCoordinate: CLLocationCoordinate2D) {
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destonationLocation = MKPlacemark(coordinate: destonationCoordinate)
        let requset = MKDirections.Request()
        requset.source = MKMapItem(placemark: startLocation)
        requset.destination = MKMapItem(placemark: destonationLocation)
        requset.transportType = .walking
        requset.requestsAlternateRoutes = true
        
        let derection = MKDirections(request: requset)
        derection.calculate { responce, error in
            
            if let error = error {
                print(error)
                return
            }
            guard let responce = responce else {
                self.alertError(title: "ERROR", message: "Route not available. Try again!")
                return
            }
            var minRoute = responce.routes[0]
            for route in responce.routes {
                minRoute = (route.distance < minRoute.distance) ? route : minRoute
            }
            self.mapView.addOverlay(minRoute.polyline)
        }
    }
}


//MARK: - Extensions

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .black
        return render
    }
}

extension MapVC {
    
    func setConstraints() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor,constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0)
            
        ])
        
        mapView.addSubview(addAdress)
        NSLayoutConstraint.activate([
            addAdress.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            addAdress.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            addAdress.heightAnchor.constraint(equalToConstant: 70),
            addAdress.widthAnchor.constraint(equalToConstant: 70)
            
        ])
        mapView.addSubview(goTo)
        NSLayoutConstraint.activate([
            goTo.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            goTo.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            goTo.heightAnchor.constraint(equalToConstant: 50),
            goTo.widthAnchor.constraint(equalToConstant: 100)
            
        ])
        mapView.addSubview(reset)
        NSLayoutConstraint.activate([
            reset.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            reset.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            reset.heightAnchor.constraint(equalToConstant: 50),
            reset.widthAnchor.constraint(equalToConstant: 100)
            
        ])
    }
}
