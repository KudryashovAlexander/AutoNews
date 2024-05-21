//
//  MainScreenViewController.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//
import Combine
import UIKit


final class MainScreenViewController: UIViewController {
    
    // MARK: - Private properties
    private let viewModel: MainScreenViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Private layout properies
    private lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout:  makeLayout())
        collectionView.register(NewsCellScreenViewCell.self,
                                forCellWithReuseIdentifier: NewsCellScreenViewCell.identifier)
        collectionView.backgroundColor = .anWhite
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var emptyCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = L.Main.empty
        label.font = .Regular.medium
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .anBlack
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .anDarkBlue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    // MARK: - Lifecicle
    init(viewModel: MainScreenViewModelProtocol) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .anWhite
        self.title = L.Main.news
        collectionView.dataSource = self
        collectionView.delegate = self
        layoutSettings()
        viewModel.viewDidLoad()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisAppear()
    }
        
    // MARK: - Private methods
    private func layoutSettings() {
        [emptyCollectionLabel,
         collectionView,
         activityIndicator].forEach {view.addSubview($0) }
         
        NSLayoutConstraint.activate([
            emptyCollectionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyCollectionLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    private func binding() {
        viewModel.news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                if self.viewModel.oldCount != self.viewModel.newCount {
                    self.updateCollectionView(oldCount: self.viewModel.oldCount,
                                              newCount: self.viewModel.newCount)
                }
            }.store(in: &subscriptions)
        
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.changeViewState(state)
            }.store(in: &subscriptions)
    }
    
    func updateCollectionView(oldCount: Int, newCount: Int) {
        self.collectionView.performBatchUpdates {
            var indexPatch: [IndexPath] = []
            for i in oldCount..<newCount {
                indexPatch.append(IndexPath(row: i, section: 0))
            }
            collectionView.insertItems(at: indexPatch)
        }
    }
    
    private func goToFullNews(_ news: NewsUIModel) {
        let detailVC = DetailNewsViewController(model: news)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        view.bounds.width > 430 ? createMozaicLayout(size: view.bounds.size) : createSingleLayout()
    }
    
    private func changeViewState(_ viewState: ViewState) {
        switch viewState {
        case .loading:
            activityIndicator.startAnimating()
            collectionView.isHidden = false
            emptyCollectionLabel.isHidden = true
        case .done:
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
            emptyCollectionLabel.isHidden = true
        case .empty:
            activityIndicator.stopAnimating()
            collectionView.isHidden = true
            emptyCollectionLabel.isHidden = false
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension MainScreenViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNewsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCellScreenViewCell.identifier, for: indexPath) as? NewsCellScreenViewCell else {
            return UICollectionViewCell()
        }
        let news = viewModel.getNews(indexPath.row)
        cell.configure(title: news.title, imageURL: news.titleImageUrl)
        return cell
    }

}

//MARK: - UICollectionViewDelegate
extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsModel = viewModel.getNews(indexPath.row)
        goToFullNews(newsModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.getNewsCount() {
            viewModel.addNews()
        }
    }
    
}

// MARK: - UICollectionViewLayout
extension MainScreenViewController {
    private func createSingleLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1/4)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
            in
            return section }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        layout.configuration = config
        return layout
    }
    
    
    private func createMozaicLayout(isLandscape: Bool = false, size: CGSize) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                         heightDimension: .fractionalHeight(1.0))
            let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .fractionalHeight(0.3))
            let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let trailingLeftGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            
            let trailingRightGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            
            let fractionalHeight = isLandscape ? NSCollectionLayoutDimension.fractionalHeight(0.8) : NSCollectionLayoutDimension.fractionalHeight(0.4)
            let groupDimensionHeight: NSCollectionLayoutDimension = fractionalHeight
            
            let rightGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupDimensionHeight),
                subitems: [leadingItem, trailingLeftGroup, trailingRightGroup])
            
            let leftGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupDimensionHeight),
                subitems: [trailingRightGroup, trailingLeftGroup, leadingItem])
            
            let height = isLandscape ? size.height / 0.9 : size.height / 1.25
            let megaGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(height)),
                subitems: [rightGroup, leftGroup])
            
            let section = NSCollectionLayoutSection(group: megaGroup)
            return section
        }
    }
}

extension MainScreenViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let `self` = self else { return }
            let size = context.containerView.bounds.size
            
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                let layout = self.createMozaicLayout(isLandscape: true, size: size)
                self.collectionView.setCollectionViewLayout(layout, animated: true, completion: nil)
                self.collectionView.collectionViewLayout = layout
            case .portrait, .portraitUpsideDown:
                let layout = self.createMozaicLayout(isLandscape: false, size: size)
                self.collectionView.setCollectionViewLayout(layout, animated: true, completion: nil)
            default:
                return
            }
        })
    }
}
