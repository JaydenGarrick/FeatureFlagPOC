//
//  FeatureFlag.swift
//  FeatureFlagPOC
//
//  Created by Jayden Garrick on 2/25/19.
//  Copyright © 2019 Jayden Garrick. All rights reserved.
//

import Foundation

struct FeatureFlag: Codable {

    // MARK: - Properties
    var activated: Bool
    var description: String?
    let minimumVersion: Int

    // MARK: - Keys
    enum FFKeys {
        static let activated = "activated"
        static let description = "description"
        static let minimumVersion = "min_version"
    }

    // MARK: - Initialization
    init?(_ dictionary: [String: Any]?) {
        guard let dictionary = dictionary,
            let iosDictionary = dictionary["iOS"] as? [String: Any],
            let activated = iosDictionary[FFKeys.activated] as? Bool,
            let minimumVersion = iosDictionary[FFKeys.minimumVersion] as? Int else {
                return nil
        }
        let description = dictionary["description"] as? String

        self.description = description
        self.activated = activated
        self.minimumVersion = minimumVersion
    }

    mutating func toggle(to value: Bool) {
        self.activated = value
    }
}
