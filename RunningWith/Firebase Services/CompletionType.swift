//
//  CompletionType.swift
//  RunningWith
//
//  Created by DELCROS Jean-baptiste on 14/11/2020.
//  Copyright © 2020 DELCROS Jean-baptiste. All rights reserved.
//

import Foundation


typealias UserCompletion = (_ user: User?) -> Void
typealias UsersCompletion = (_ user: [User]?) -> Void
typealias RunCompletion = (_ run: Run?) -> Void
typealias RunsCompletion = (_ run: [Run]?) -> Void
typealias SuccessCompletion = (_ success: Bool?, _ string: String?) -> Void
