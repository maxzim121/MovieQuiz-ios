//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Maksim Zimens on 23.03.2023.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    let completion: ()->Void
}
