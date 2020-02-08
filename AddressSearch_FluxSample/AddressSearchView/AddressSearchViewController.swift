//
//  AddressSearchViewController.swift
//  AddressSearch_FluxSample
//
//  Created by shintykt on 2020/02/08.
//  Copyright © 2020 Takaya Shinto. All rights reserved.
//

import CoreLocation
import UIKit

final class AddressSearchViewController: UIViewController {
    @IBOutlet private weak var addressView: UITextView!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    
    private let store: AddressSearchStore
    private let actionCreator: AddressSearchActionCreator
    private var subscription: Subscription!
    
    private var inputPlace: String?
    
    init(store: AddressSearchStore = .shared, actionCreator: AddressSearchActionCreator = .init()) {
        self.store = store
        self.actionCreator = actionCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        setUpUI()
        setUpSubscription()
        setUpNotification()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Storeを購読
    private func setUpSubscription() {
        subscription = store.addObserver { [weak self] in
            DispatchQueue.main.async {
                self?.addressView.text = self?.store.address
            }
        }
    }
}

// MARK: - UI設定

private extension AddressSearchViewController {
    func setUpDelegate() {
        store.locationManager.delegate = self
        inputField.delegate = self
    }
    
    func setUpUI() {
        setUpBackView()
        setUpAddressView()
        setUpInputField()
        setUpSearchButton()
    }
    
    func setUpBackView() {
        view.backgroundColor = .yellow
    }
    
    func setUpAddressView() {
        addressView.font = Const.bigBoldFont
        addressView.createBorder()
        addressView.createShadow()
        addressView.isEditable = false
    }
    
    func setUpInputField() {
        inputField.createBorder()
        inputField.createShadow()
        inputField.clearButtonMode = .always
        inputField.placeholder = "住所を知りたい場所を入力"
    }
    
    func setUpSearchButton() {
        searchButton.backgroundColor = .brown
        searchButton.tintColor = .white
        searchButton.titleLabel?.font = Const.smallBoldFont
        searchButton.createBorder()
        searchButton.createShadow()
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
    }
}

// MARK: - ボタンアクション

private extension AddressSearchViewController {
    @objc func didTapSearch() {
        guard let inputPlace = self.inputPlace else { return }
        actionCreator.fetchAddress(for: inputPlace)
    }
}

// MARK: - 位置情報管理

extension AddressSearchViewController: CLLocationManagerDelegate {
    // 位置情報の使用権限に応じた処理
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        actionCreator.handleLocationAuth(with: status)
    }
}

// MARK: - 場所名入力管理

extension AddressSearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        actionCreator.clearAddress()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let inputPlace = textField.text else { return }
        self.inputPlace = inputPlace
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - キーボード管理

private extension AddressSearchViewController {
    func setUpNotification() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // キーボード表示で画面を上へスライド
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
        }
    }
    
    // キーボード非表示で画面を下へスライド
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
}
