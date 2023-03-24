//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Maksim Zimens on 23.03.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func presentAlert(alert: UIAlertController?)
}
