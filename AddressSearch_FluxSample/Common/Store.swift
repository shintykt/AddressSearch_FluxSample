//
//  Store.swift
//  AddressSearch_FluxSample
//
//  Created by shintykt on 2020/02/08.
//  Copyright © 2020 Takaya Shinto. All rights reserved.
//

import Foundation

typealias Subscription = NSObjectProtocol

class Store {
    private let dispatcher: Dispatcher
    private var dispatchId: DispatchId!
    
    private let notificationCenter: NotificationCenter
    private let notificationName = "store-changed"
    private enum NotificationName {
        static let storeChanged = Notification.Name("store-changed")
    }
    
    init(dispatcher: Dispatcher = .shared) {
        self.dispatcher = dispatcher
        notificationCenter = NotificationCenter()
        dispatchAction()
    }
    
    deinit {
        dispatcher.unregisterAction(forID: dispatchId)
    }
    
    private func dispatchAction() {
        dispatchId = dispatcher.registerAction { [weak self] action in
            self?.executeAction(action)
        }
    }
    
    func executeAction(_ action: Action) {}
    
    final func notifyChanges() {
        notificationCenter.post(name: NotificationName.storeChanged, object: nil)
    }
    
    final func addObserver(callback: @escaping () -> Void) -> Subscription {
        return notificationCenter.addObserver(forName: NotificationName.storeChanged, object: nil, queue: nil) { (notification) in
            guard notification.name == NotificationName.storeChanged else { return }
            callback()
        }
    }
    
    final func removeObserver(for subscription: Subscription) {
        notificationCenter.removeObserver(subscription)
    }
}
