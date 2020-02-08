//
//  AddressSearchAction.swift
//  AddressSearch_FluxSample
//
//  Created by shintykt on 2020/02/08.
//  Copyright © 2020 Takaya Shinto. All rights reserved.
//

import CoreLocation
import Foundation

enum AddressSearchAction: Action {
    case handleLocationAuth(with: CLAuthorizationStatus)
    case fetchAddress(for: String)
    case clearAddress
}
