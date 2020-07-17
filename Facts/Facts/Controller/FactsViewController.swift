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
        tableView.register(FactTableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        return tableView
    }()
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FactsViewModel.shared.getJsonData()
        view.backgroundColor = .white
        view.addSubview(tableView)
        addConstraints()
        FactsViewModel.shared.didUpdate = {
            DispatchQueue.main.async {
                self.title = FactsViewModel.shared.getTitle()
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FactTableViewCell{
            let object = FactsViewModel.shared.getFactAtIndex(indexPath.row)
            if let imageHref = object.imageHref{
                FactsViewModel.shared.loadImageFrom(link: imageHref) { (image) in
                    cell.imgView.image = image
                }
            }
        }
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

