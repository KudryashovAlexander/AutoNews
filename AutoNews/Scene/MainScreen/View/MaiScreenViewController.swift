//
//  MaiScreenViewController.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//
import Combine
import UIKit

final class MaiScreenViewController: UIViewController {
    
    // MARK: - Private properties
    private let viewModel: MainScreenViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        binding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bindingOff()
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    private func layoutSettings() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func binding() {
        viewModel.news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.currentNews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in
                self?.goToFullNews(news)
            }.store(in: &subscriptions)
    }
    
    private func bindingOff() {
        subscriptions.removeAll()
    }
    
    
    private func goToFullNews(_ news: NewsUIModel) {
        let detailVM = DetailNewsViewModel(model: news)
        let detailVC = DetailNewsViewController(viewModel: detailVM)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource
extension MaiScreenViewController: UICollectionViewDataSource {
    
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
extension MaiScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.presentFullNews(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 300)
    }
}
