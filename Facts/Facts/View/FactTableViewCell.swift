//
//  FactTableViewCell.swift
//  Facts
//
//  Created by 3Embed on 18/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class FactTableViewCell: UITableViewCell {
    // MARK:- Label to show title
    let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .left
        return lbl
    }()
    // MARK:- Label to show description
    let lblDescription: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.textAlignment = .left
        lbl.numberOfLines = AppConstants.NumerOfLines.Zero
        return lbl
    }()
    // MARK:- imageview to show content image
    let imgView: UIImageView = {
        let imageVw = UIImageView()
        imageVw.contentMode = .scaleAspectFill
        imageVw.clipsToBounds = true
        imageVw.image = #imageLiteral(resourceName: "placeholder")
        imageVw.layer.cornerRadius = AppConstants.CornerRadius.ForImage
        imageVw.layer.borderColor = UIColor.lightGray.withAlphaComponent(AppConstants.Alpha.Half).cgColor
        imageVw.layer.borderWidth = AppConstants.BorderWidth.Medium
        return imageVw
    }()

    // MARK:- Cell Init method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(lblTitle)
        self.contentView.addSubview(lblDescription)
        addConstraints()
    }

    // MARK:- PrepareForReuse method to change image at intial state to prevent same image
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = #imageLiteral(resourceName: "placeholder")
    }

    // MARK:- Required init method
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Adding Layout Constraints
    func addConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        // MARK:- ImageView constraints
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        imgView.topAnchor.constraint(greaterThanOrEqualTo: marginGuide.topAnchor).isActive = true
        imgView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: AppConstants.HeightConstants.Small).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: AppConstants.HeightConstants.Small).isActive = true
        // MARK:- Title Label constraints
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: AppConstants.Padding.Wide).isActive = true
        lblTitle.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lblTitle.font = UIFont.boldSystemFont(ofSize: AppConstants.FontSize.Regular)
        lblTitle.numberOfLines = AppConstants.NumerOfLines.Zero
        // MARK:- Description Label constraints
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: AppConstants.Padding.Wide).isActive = true
        lblDescription.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        lblDescription.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: AppConstants.Padding.Low).isActive = true
        lblDescription.font = UIFont.systemFont(ofSize: AppConstants.FontSize.Small)
        lblDescription.numberOfLines = AppConstants.NumerOfLines.Zero
    }
}
