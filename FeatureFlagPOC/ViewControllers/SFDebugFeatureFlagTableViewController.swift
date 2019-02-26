//
//  SFDebugFeatureFlagTableViewController.swift
//  mobile
//
//  Created by Jayden Garrick on 2/19/19.
//  Copyright © 2019 sofi. All rights reserved.
//

import UIKit

final class SFDebugFeatureFlagTableViewController: UITableViewController {

    // MARK: - Properties
    var flags = FeatureFlagManager.dictionaryRepresentation() {
        didSet {
            print(flags)
        }
    }
    private let reuseIdentifier = "SFDebugFeatureFlagTableViewController"

    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SFDebugFeatureFlagTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        if FeatureFlagManager.dictionaryRepresentation().isEmpty {
            FeatureFlagManager.fetchFeatureFlagRemoteValues { [weak self] (_) in
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Actions
    @IBAction func syncWithServerButtonTapped(_ sender: Any) {
        presentSyncAlert()
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Table view data source and delegate
extension SFDebugFeatureFlagTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SFDebugFeatureFlagTableViewCell
        cell.flag = (name: Array(flags.keys)[indexPath.row], value: Array(flags.values)[indexPath.row])
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}

// MARK: - SFDebugFeatureFlagTableViewCellDelegate
extension SFDebugFeatureFlagTableViewController: SFDebugFeatureFlagTableViewCellDelegate {
    func flagToggled(name: String, value: Bool) { 
        FeatureFlagManager.locallyToggleFlag(name, to: value)
    }
}

// MARK: - Alerts
extension SFDebugFeatureFlagTableViewController {
    func presentSyncAlert() {
        let alertController = UIAlertController(title: "Warning:", message: "You're about to reset all feature flags to the default values on the firebase backend. Are you sure you want to do this?", preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            FeatureFlagManager.fetchFeatureFlagRemoteValues(completion: { (_) in
                self.flags = FeatureFlagManager.dictionaryRepresentation()
                self.tableView.reloadData()
            })

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

}

