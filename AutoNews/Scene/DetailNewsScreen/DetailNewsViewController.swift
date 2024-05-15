//
//  DetailNewsViewController.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//
import Combine
import UIKit

final class DetailNewsViewController: UIViewController {
        
    // MARK: - Private properties
    private var model: NewsUIModel
    private let imageLoader = ImageLoader()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Private layout properies
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .anWhite
        scrollView.frame = view.bounds
        scrollView.contentSize = contenSize
        scrollView.isHidden = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contenSize
        view.backgroundColor = .anWhite
        return view
    }()
    
    private var contenSize = CGSize()
    private var viewHight = CGFloat()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = model.title
        label.font = .Bold.extraLarge
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .anBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = model.publishedDate.createString()
        label.font = .Regular.small
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .anGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = model.categoryType
        label.font = .Regular.small
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .anGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = model.description
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
        imageView.contentMode = .scaleAspectFit
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
    init(model: NewsUIModel) {
        self.model = model
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHight = view.bounds.height
        view.backgroundColor = .anWhite
        layoutSupport()
        updateContentSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageLoader.loadImage(from: model.titleImageUrl, size: CGSize(width: view.frame.width, height: 500))
        binding()
    }
    
    // MARK: - Private methods
    private func layoutSupport() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [titleLabel,
         dateLabel,
         categoryLabel,
         descriptionLabel,
         imageView,
         fullNewsButton].forEach { contentView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 400),
            
            fullNewsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fullNewsButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
        ])
        
        view.layoutIfNeeded()
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
    
    private func updateContentSize() {
        let heightElements: CGFloat = CGFloat(20 + titleLabel.bounds.height + 16 + dateLabel.bounds.height + 16 + descriptionLabel.bounds.height + 16 + imageView.frame.height + 16 + fullNewsButton.bounds.height + 16)
        let maxView = max(heightElements,viewHight)
        contenSize = CGSize(width: view.frame.width, height: maxView)
        scrollView.contentSize = contenSize
        contentView.frame.size = contenSize
    }
    
    // MARK: - Private button actions
    @objc
    private func openURLAction() {
        let webViewController = WebViewViewController(webViewURL: model.fullUrl)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
