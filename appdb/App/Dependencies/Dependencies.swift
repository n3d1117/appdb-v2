//
//  Dependencies.swift
//  appdb-v2
//
//  Created by ned on 08/01/23.
//

import Factory

typealias Dependencies = Container

extension Dependencies {
    static let apiService = Factory(scope: .shared) { APIService() }
}
