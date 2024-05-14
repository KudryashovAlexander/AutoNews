//
//  NewsCellScreenViewCollectionViewCell.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//
import Combine
import UIKit

final class NewsCellScreenViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    static let identifier = "NewsCellScreenViewCell"
    
    // MARK: - Private methods
    private let imageLoader = ImageLoader()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Private layout properties
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
        label.textColor = .anWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .gradient)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    func configure(title: String, imageURL: URL?) {
        titleLabel.text = title
        if imageURL != nil {
            imageLoader.loadImage(from: imageURL, size: CGSize(width: contentView.frame.width, height: contentView.frame.height))
            binding()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        imageLoader.cancelLoading()
        self.imageView.image = UIImage(resource: .placeholder)
    }
    
    // MARK: - Private methods
    private func layotSetting() {
        
        [imageView,
         gradientImageView,
         titleLabel].forEach { contentView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            gradientImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientImageView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func binding() {
        imageLoader.image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                if let image = image {
                    self?.imageView.image = image
                }
            }.store(in: &subscriptions)
    }
    
}
