//
//  Dispatcher.swift
//  AddressSearch_FluxSample
//
//  Created by shintykt on 2020/02/08.
//  Copyright © 2020 Takaya Shinto. All rights reserved.
//

import Foundation

typealias DispatchId = String

final class Dispatcher {
    static let shared = Dispatcher()
    
    private var actions: [DispatchId: (Action) -> Void]
    
    private init() {
        actions = [:]
    }
    
    func registerAction(_ action: @escaping (Action) -> Void) -> DispatchId {
        let id = UUID().uuidString
        actions[id] = action
        return id
    }
    
    func unregisterAction(forID id: DispatchId) {
        actions.removeValue(forKey: id)
    }
    
    func dispatch(_ action: Action) {
        actions.forEach { $0.value(action) }
    }
}
