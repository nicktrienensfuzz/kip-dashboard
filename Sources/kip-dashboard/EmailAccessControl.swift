//
//  EmailAccessControl.swift
//
//
//  Created by Nicholas Trienens on 7/3/23.
//

import Foundation
/*
 Function to check if the provided email is allowed based on the array of email access controls.

 - Parameters:
     - email: The email address to be checked.

 - Returns: A boolean value indicating whether the email is allowed or not.
 

*/

enum EmailAccessControl {
    case domain(String)
    case email(String)
}

extension Array where Element == EmailAccessControl {
    func emailAllowed(_ email: String) -> Bool {
        contains { control in
            switch control {
            case let .domain(value):
                return email.contains(value)
            case let .email(value):
                return email.contains(value)
            }
        }
    }
}
