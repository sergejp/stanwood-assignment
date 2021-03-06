//
//  Result.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/25/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
