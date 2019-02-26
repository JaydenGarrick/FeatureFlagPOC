//
//  FeatureFlagManager.swift
//  FeatureFlagPOC
//
//  Created by Jayden Garrick on 2/20/19.
//  Copyright © 2019 Jayden Garrick. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

enum FeatureFlagKey {
    static let defaults = "FeatureFlagUserDefaults"
}

enum FeatureFlagNames {
    static let backgroundColorYellow = "background_color_yellow"
    static let isSnellRoundhand = "is_snell_roundhand"
    static let textColorWhite = "text_color_white"
    static let isBabyDeer = "is_baby_deer"
}

enum FeatureFlagManager {

    // MARK: - Properties
    static private var flagStatuses: [String: FeatureFlag] = {
        guard let data = UserDefaults.standard.value(forKey: FeatureFlagKey.defaults) as? Data,
            let flagStatuses = try? PropertyListDecoder().decode([String: FeatureFlag].self, from: data) else { return [:] }
        return flagStatuses
        }() {
        didSet {
            NotificationCenter.default.post(name: .featureFlagsUpdated, object: flagStatuses, userInfo: flagStatuses)
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(flagStatuses), forKey: FeatureFlagKey.defaults)
        }
    }

    // MARK: - Keys
    enum FeatureFlagManagerKeys {
        static let featureFlag = "FeatureFlags"
    }

    // Firebase Reference
    private static let databaseReference = Firestore.firestore().collection(FeatureFlagManagerKeys.featureFlag)

    // MARK: - Methods
    // Dev facing methods
    static func fetchFeatureFlagRemoteValues(completion: @escaping ([String: FeatureFlag]?) -> Void) {
        databaseReference.getDocuments(source: .server) { (document, error) in
            if let error = error {
                print("❌ Error fetching remote values: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let document = document else { completion(nil) ; return }

            var featureFlags = [String: FeatureFlag]()
            for document in document.documents {
                let name = document.documentID
                guard let flag = FeatureFlag(document.data()),
                flag.minimumVersion < UIApplication.appBuild() else { continue }

                featureFlags[name] = flag
            }

            self.flagStatuses = featureFlags
            completion(featureFlags)
        }
    }

    static func dictionaryRepresentation() -> [String: FeatureFlag] {
        return flagStatuses
    }

    static func valueFor(flagName: String) -> Bool {
        return flagStatuses[flagName]?.activated ?? false
    }

    static func locallyToggleFlag(_ flagName: String, to value: Bool) {
        flagStatuses[flagName]?.toggle(to: value)
    }

}
