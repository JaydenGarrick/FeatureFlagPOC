//
//  ViewController.swift
//  FeatureFlagPOC
//
//  Created by Jayden Garrick on 2/20/19.
//  Copyright © 2019 Jayden Garrick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!


    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .featureFlagsUpdated, object: nil)
        updateViews()
    }

    // MARK: - Setup
    @objc func updateViews() {
        view.backgroundColor = FeatureFlagManager.valueFor(flagName: FeatureFlagNames.backgroundColorYellow) ? ThemeConstants.yellow : ThemeConstants.blue
        topLabel.font = FeatureFlagManager.valueFor(flagName: FeatureFlagNames.isSnellRoundhand) ? ThemeConstants.snellRoundHand : ThemeConstants.zapfino
        topLabel.textColor = FeatureFlagManager.valueFor(flagName: FeatureFlagNames.textColorWhite) ? .white : .black
        animalImageView.image = FeatureFlagManager.valueFor(flagName: FeatureFlagNames.isBabyDeer) ? ThemeConstants.babyDeer : ThemeConstants.babyPug
    }

    // MARK: - Actions
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let debugViewController = UIStoryboard(name: "FeatureFlagDebugger", bundle: nil).instantiateInitialViewController() as! UINavigationController
            present(debugViewController, animated: true)
        }
    }

}


