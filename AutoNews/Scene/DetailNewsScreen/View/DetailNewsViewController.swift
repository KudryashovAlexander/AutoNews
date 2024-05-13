//
//  DetailNewsViewController.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//

import UIKit

final class DetailNewsViewController: UIViewController {
        
    // MARK: - Private properties
    private var viewModel: DetailNewsViewModelProtocol
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.model.title
        label.font = .Bold.extraLarge
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .anBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.model.publishedDate.description
        label.font = .Regular.small
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .anGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.model.categoryType
        label.font = .Regular.small
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .anGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.model.description
        label.font = .Regular.medium
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .anBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .placeholder)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var fullNewsButton: UIButton = {
        let button = UIButton()
        button.setTitle(L.News.openFullURL, for: .normal)
        button.setTitleColor(.anBlue, for: .normal)
        button.titleLabel?.font = .Regular.medium
        button.titleLabel?.textAlignment = .left
        button.addTarget(self, action: #selector(openURLAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - Lifecicle
    init(viewModel: DetailNewsViewModelProtocol) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .anWhite
        layoutSupport()
    }
    
    // MARK: - Private methods
    private func layoutSupport() {
        [titleLabel,
         dateLabel,
         categoryLabel,
         descriptionLabel,
         imageView,
         fullNewsButton].forEach { view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            
            categoryLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            
            fullNewsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -16),
            fullNewsButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
        ])
    }
    
    // MARK: - Private button actions
    @objc
    private func openURLAction() {
        // открыть вебвью
    }
    
    // MARK: - Constants
    
}
