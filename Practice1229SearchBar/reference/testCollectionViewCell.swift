//
//  testCollectionViewCell.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/8.
//  Copyright © 2020 cm0521. All rights reserved.
//

import UIKit

class testCollectionViewCell: UICollectionViewCell {
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 4
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.container)
        self.container.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.container.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.container.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true

        self.container.addSubview(self.colorView)
        self.colorView.centerXAnchor.constraint(equalTo: self.container.centerXAnchor).isActive = true
        self.colorView.centerYAnchor.constraint(equalTo: self.container.centerYAnchor).isActive = true
        self.colorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.colorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
