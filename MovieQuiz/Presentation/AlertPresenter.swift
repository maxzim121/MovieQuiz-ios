//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Maksim Zimens on 23.03.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .cancel) { _ in
            model.completion?()
        }
        alert.addAction(action)
        delegate?.presentAlert(alert: alert)
    }
}
