//
//  AddressSearchStore.swift
//  AddressSearch_FluxSample
//
//  Created by shintykt on 2020/02/08.
//  Copyright © 2020 Takaya Shinto. All rights reserved.
//

import CoreLocation
import Foundation

final class AddressSearchStore: Store {
    static let shared = AddressSearchStore()
    
    var address = "" {
        didSet { notifyChanges() }
    }
    let locationManager = CLLocationManager()
    
    override func executeAction(_ action: Action) {
        guard let action = action as? AddressSearchAction else { return }
        switch action {
        case .handleLocationAuth(with: let status): handleLocationAuth(with: status)
        case .fetchAddress(for: let place): fetchAddress(for: place)
        case .clearAddress: clearAddress()
        }
    }
}

private extension AddressSearchStore {
    // 位置情報の使用権限に応じた処理
    func handleLocationAuth(with status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: return
        case .restricted, .denied, .notDetermined: locationManager.requestWhenInUseAuthorization()
        default: fatalError()
        }
    }
    
    func fetchAddress(for place: String) {
        guard CLLocationManager.locationServicesEnabled() else { return }
        // 位置情報の更新を開始
        locationManager.startUpdatingLocation()
        
        let geocoder = CLGeocoder()
        // 場所名から緯度・経度を取得
        geocoder.geocodeAddressString(place) { [weak self] (placemarks, _) in
            guard let location = placemarks?.last?.location else { self?.locationManager.stopUpdatingLocation(); return }
            // 緯度・経度から住所を取得
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, _) in
                guard let placemark = placemarks?.last else { self?.locationManager.stopUpdatingLocation(); return }
                self?.address = self?.createAddress(from: placemark) ?? ""
                // 位置情報の更新を停止
                self?.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func createAddress(from placemark: CLPlacemark) -> String {
        return """
        〒 \(placemark.postalCode ?? "")
        \(placemark.administrativeArea ?? "")\(placemark.locality ?? "")
        \(placemark.thoroughfare ?? "")\(placemark.subThoroughfare ?? "")
        """
    }
    
    func clearAddress() {
        address = ""
    }
}
