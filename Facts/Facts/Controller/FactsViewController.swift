//
//  FactsViewController.swift
//  Facts
//
//  Created by 3Embed on 18/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class FactsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView.init()
        tableView.register(FactTableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getFacts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    let imageLoader = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.refreshControl?.beginRefreshing()
        FactsViewModel.shared.getJsonData()
        
        addConstraints()
        addObservers()
    }
    
    @objc func getFacts(){
        FactsViewModel.shared.getJsonData()
    }
    
    func addObservers(){
        FactsViewModel.shared.didUpdate = {
            DispatchQueue.main.async {
                self.title = FactsViewModel.shared.getTitle()
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FactsViewModel.shared.numberOfFacts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! FactTableViewCell
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
    
    func addConstraints() {
        NSLayoutConstraint.activate([
          tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
          tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
          tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

