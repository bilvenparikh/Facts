//
//  FactsViewController.swift
//  Facts
//
//  Created by 3Embed on 18/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class FactsViewController: UIViewController ,UITableViewDataSource {
    // MARK:- UI elements
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView.init()
        tableView.register(FactTableViewCell.self, forCellReuseIdentifier: AppConstants.CellIdentifiers.FactsTableViewCell)
        tableView.accessibilityIdentifier = AppConstants.AccessibilityIdentifiers.FactsTableView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getFacts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    // MARK:- ImageLoader Object
    let imageLoader = ImageLoader()
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.refreshControl?.beginRefreshing()
        FactsViewModel.shared.getJsonData()
        
        addConstraints()
        addObservers()
    }
    
    // MARK:- UIRefreshcontrol Method
    @objc func getFacts(){
        FactsViewModel.shared.getJsonData()
    }
    
    // MARK:- Adding RxObservers for DataModel
    func addObservers(){
        FactsViewModel.shared.didUpdate = { [weak self] in
            DispatchQueue.main.async {
                if let weakSelf = self{
                    weakSelf.title = FactsViewModel.shared.getTitle()
                    weakSelf.tableView.reloadData()
                    weakSelf.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    // MARK:- TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FactsViewModel.shared.numberOfFacts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FactTableViewCell = tableView.dequeueReusableCell(withIdentifier: AppConstants.CellIdentifiers.FactsTableViewCell) as! FactTableViewCell
        cell.accessibilityIdentifier = AppConstants.AccessibilityIdentifiers.FactsTableViewCell
        cell.selectionStyle = .none
        let object = FactsViewModel.shared.getFactAtIndex(indexPath.row)
        cell.lblTitle.text = object.title
        cell.lblDescription.text = object.descriptionField
        if let imageUrl = object.imageHref{
            imageLoader.obtainImageWithPath(imagePath: imageUrl) { (image) in
                if let updateCell = tableView.cellForRow(at: indexPath) as? FactTableViewCell {
                    updateCell.imgView.image = image
                }
            }
        }else{
            cell.imgView.image = #imageLiteral(resourceName: "placeholder")
        }
        return cell
    }
    
    // MARK:- Adding Constraints
    func addConstraints() {
        NSLayoutConstraint.activate([
          tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
          tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
          tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

