//
//  FactTableViewCell.swift
//  Facts
//
//  Created by 3Embed on 18/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class FactTableViewCell: UITableViewCell {
    let lblTitle : UILabel = {
       let lbl = UILabel()
       lbl.textColor = .black
       lbl.textAlignment = .left
       return lbl
    }()
    let lblDescription : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    let imgView : UIImageView = {
        let imageVw = UIImageView()
        imageVw.contentMode = .scaleAspectFit
        imageVw.clipsToBounds = true
        return imageVw
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(lblTitle)
        self.contentView.addSubview(lblDescription)
        addConstraints()
    }
    
    override func prepareForReuse() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        imgView.topAnchor.constraint(greaterThanOrEqualTo: marginGuide.topAnchor).isActive = true
        imgView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
        lblTitle.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.numberOfLines = 0

        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
        lblDescription.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        lblDescription.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive = true
        lblDescription.numberOfLines = 0
        
        contentView.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
