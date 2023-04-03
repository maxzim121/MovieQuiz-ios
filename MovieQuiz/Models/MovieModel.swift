//
//  MovieModel.swift
//  MovieQuiz
//
//  Created by Maksim Zimens on 28.03.2023.
//

import Foundation

public struct Actor {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}
public struct Movie {
    let id: String
    let title: String
    let year: Int
    let image: String
    let releaseDate: String
    let runtimeMins: Int
    let directors: String
    let actorList: [Actor]
}
