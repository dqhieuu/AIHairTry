//
//  Utils.swift
//  AIHairTry
//
//  Created by Hieu on 3/22/23.
//

import Foundation

func getRandomFileName() -> String {
    let timestamp = NSDate().timeIntervalSince1970.rounded()
    return "\(timestamp)_\(UUID().uuidString)"
}
