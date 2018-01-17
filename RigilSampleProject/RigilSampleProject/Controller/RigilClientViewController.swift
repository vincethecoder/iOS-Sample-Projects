//
//  ViewController.swift
//  RigilSampleProject
//
//  Created by Kobe Sam on 1/9/18.
//  Copyright © 2018 vincethecoder. All rights reserved.
//

import UIKit

class RigilClientViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var enterButon: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    var viewModel: RigilClientViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RigilClientViewModel()
        
        /// Brief: This will reload table whenever a new name is entered
        viewModel?.reloadLoadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        title = NSLocalizedString("Rigil Client Name System", comment: "Title Text for Rigil Client Name System")
        
        /// Format table view
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        
        /// Format button
        enterButon.backgroundColor = .clear
        enterButon.layer.cornerRadius = 5
        enterButon.layer.borderWidth = 1
        enterButon.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func enterButtonTapped(_ sender: UIButton) {
        let newClient = RigilClient(name: nameTextField.text ?? "")
        viewModel?.clientEntered(newClient)
    }
}

extension RigilClientViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rigilClientTableViewCellID = "rigilClientTableViewCellID"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: rigilClientTableViewCellID), let vm = viewModel else {
            fatalError("Cell with identifier \(rigilClientTableViewCellID) does not exist in storyboard")
        }

        cell.textLabel?.text = vm.getClientNameChar(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let vm = viewModel {
            return vm.numberOfCells
        }
        
        return 0 // Empty cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

