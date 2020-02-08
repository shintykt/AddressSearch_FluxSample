//
//  AddressSearchActionCreator.swift
//  AddressSearch_FluxSample
//
//  Created by shintykt on 2020/02/08.
//  Copyright © 2020 Takaya Shinto. All rights reserved.
//

import CoreLocation
import Foundation

final class AddressSearchActionCreator {
    private let dispatcher: Dispatcher
    
    init(dispatcher: Dispatcher = .shared) {
        self.dispatcher = dispatcher
    }
    
    func handleLocationAuth(with status: CLAuthorizationStatus) {
        dispatcher.dispatch(AddressSearchAction.handleLocationAuth(with: status))
    }
    
    func fetchAddress(for place: String) {
        dispatcher.dispatch(AddressSearchAction.fetchAddress(for: place))
    }
    
    func clearAddress() {
        dispatcher.dispatch(AddressSearchAction.clearAddress)
    }
}
