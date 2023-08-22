//
//  String+Additions.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-22.
//

import Foundation

extension String {
    
    func onlyLettersAndNumbers() -> String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
    }
    
}
