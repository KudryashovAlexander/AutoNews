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
    private var currentURL: URL?
    
    // MARK: - Private layout properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .placeholder)
        imageView.clipsToBounds = true
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .anDarkBlue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
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
        currentURL = imageURL
        
        imageLoader.cancelLoading()
        subscriptions.removeAll()
        
        if let imageURL = imageURL {
            imageLoader.loadImage(from: imageURL)
            binding()
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoader.cancelLoading()
        subscriptions.removeAll()
        imageView.image = UIImage(named: "placeholder")
        currentURL = nil
    }
    
    // MARK: - Private methods
    private func layotSetting() {
        
        [imageView,
         gradientImageView,
         titleLabel, activityIndicator].forEach { contentView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            gradientImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientImageView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func binding() {
        imageLoader.image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                if let image = image {
                    self.imageView.image = image.downSample(to: CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height))
                } else {
                    self.imageView.image = UIImage(named: "placeholder")
                }
            }.store(in: &subscriptions)
        
        imageLoader.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }.store(in: &subscriptions)
        
    }
    
    
}
