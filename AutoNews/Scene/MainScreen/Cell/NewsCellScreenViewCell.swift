//
//  NewsCellScreenViewCollectionViewCell.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//

import UIKit

final class NewsCellScreenViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    static let identifier = "NewsCellScreenViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .placeholder)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .Regular.large
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .anBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecicle
    override init(frame: CGRect) {
        super .init(frame: frame)
        layotSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func configure(title: String, imageURL: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private methods
    private func layotSetting() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10)
        ])
    }
    
    // MARK: - Constants

}
