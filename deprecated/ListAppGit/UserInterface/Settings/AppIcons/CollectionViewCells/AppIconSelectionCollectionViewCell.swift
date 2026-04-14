//
//  AppIconSelectionCollectionViewCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-12-27.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct changeIconCollectionViewCellViewModel {
    var colourName: String

    init(colourName: String) {
        self.colourName = colourName
    }
}

final class changeIconCollectionViewCell: UICollectionViewCell {

    var viewModel: changeIconCollectionViewCellViewModel? {
        didSet {
            setImage()
            setLabel()
        }
    }

    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setUpTheming()
        setUpFont()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension changeIconCollectionViewCell {
    func setup() {

        contentView.backgroundColor = .clear

        contentView.addSubview(imageView)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setImage() {
        let imageName = viewModel!.colourName + "Icon@3x"
        imageView.image = UIImage(named: imageName)
    }

    func setLabel() {
        label.text = viewModel!.colourName
    }
}

extension changeIconCollectionViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        label.textColor = theme.textColor
    }
}

extension changeIconCollectionViewCell: FontProtocol {
    func applyFont(_ font: AppFont) {
        label.font = font.fontValue().withSize(label.font?.pointSize ?? 17)
    }
}

