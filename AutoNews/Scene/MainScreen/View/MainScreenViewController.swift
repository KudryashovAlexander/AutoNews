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
    private let collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
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
        let detailVM = DetailNewsViewModel(model: news)
        let detailVC = DetailNewsViewController(viewModel: detailVM)
        self.navigationController?.pushViewController(detailVC, animated: true)
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
extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsModel = viewModel.getNews(indexPath.row)
        goToFullNews(newsModel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.getNewsCount() {
            viewModel.addNews()
        }
    }
}
