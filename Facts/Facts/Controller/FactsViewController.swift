//
//  FactsViewController.swift
//  Facts
//
//  Created by 3Embed on 18/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class FactsViewController: UIViewController, UITableViewDataSource {
    let factsVM = FactsViewModel()
    // MARK:- UITableView to display Data
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = AppConstants.HeightConstants.EstimatedHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView.init()
        tableView.register(FactTableViewCell.self, forCellReuseIdentifier: AppConstants.CellIdentifiers.FactsTableViewCell)
        tableView.accessibilityIdentifier = AppConstants.AccessibilityIdentifiers.FactsTableView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getFacts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    // MARK:- Label to show when there are no records
    lazy var lblNoData : UILabel = {
        let lblNoData = UILabel.init(frame: self.view.bounds)
        lblNoData.text = AppConstants.Messages.NoRecords
        lblNoData.font = UIFont.systemFont(ofSize: AppConstants.FontSize.Regular)
        lblNoData.center = self.view.center
        lblNoData.textAlignment = .center
        return lblNoData
    }()

    // MARK:- ImageLoader Object
    let imageLoader = ImageLoader()

    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(lblNoData)
        // MARK:- Adding Observers
        addObservers()
        //MARK:- Refreshing refreshControll on loading data
        tableView.refreshControl?.beginRefreshing()
        // MARK:- Getting JSON Data
        factsVM.getJsonData()
        // MARK:- Adding constraints
        addConstraints()
    }

    // MARK:- UIRefreshcontrol Method
    @objc func getFacts() {
        factsVM.getJsonData()
    }

    // MARK:- Adding RxObservers for DataModel
    func addObservers() {
        factsVM.didUpdate = { [weak self] in
            DispatchQueue.main.async {
                if let weakSelf = self {
                    weakSelf.title = weakSelf.factsVM.getTitle()
                    weakSelf.tableView.reloadData()
                    weakSelf.tableView.refreshControl?.endRefreshing()
                    weakSelf.tableView.isHidden = weakSelf.factsVM.numberOfFacts == 0
                    weakSelf.lblNoData.isHidden = weakSelf.factsVM.numberOfFacts > 0
                }
            }
        }
    }

    // MARK:- TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factsVM.numberOfFacts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: FactTableViewCell = tableView.dequeueReusableCell(withIdentifier: AppConstants.CellIdentifiers.FactsTableViewCell) as? FactTableViewCell else {return UITableViewCell()}
        cell.accessibilityIdentifier = AppConstants.AccessibilityIdentifiers.FactsTableViewCell
        cell.selectionStyle = .none
        let object = factsVM.getFactAtIndex(indexPath.row)
        cell.lblTitle.text = object.title
        cell.lblDescription.text = object.descriptionField
        if let imageUrl = object.imageHref {
            imageLoader.obtainImageWithPath(imagePath: imageUrl) { (image) in
                if let updateCell = tableView.cellForRow(at: indexPath) as? FactTableViewCell {
                    updateCell.imgView.image = image
                }
            }
        } else {
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

