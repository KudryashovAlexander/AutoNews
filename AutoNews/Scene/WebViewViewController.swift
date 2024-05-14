//
//  WebViewViewController.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 14.05.2024.
//

import Combine
import UIKit
import WebKit

final class WebViewViewController: UIViewController {

    // MARK: - Private properties
    private let webViewURL: String
    private let viewState = CurrentValueSubject<ViewState, Never>(.empty)
    private var cancellables = Set<AnyCancellable>()
    private var webViewProgressObservation: NSKeyValueObservation?
    
    // MARK: - Private layout properies
    private lazy var webView = WKWebView()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .anBlack
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .anDarkBlue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    // MARK: - Lifecicle
    init(webViewURL: String) {
        self.webViewURL = webViewURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        observeWebView()
        loadWebView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindingOn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bindingOff()
    }

    // MARK: - Private methods
    private func observeWebView() {
        webViewProgressObservation = webView.observe(\.estimatedProgress,
                                                      options: [.new]) { [weak self] _, change in
            if let newValue = change.newValue {
                self?.updateProgressValue(newValue)
            }
        }
    }

    private func bindingOn() {
        viewState.sink { [weak self] isLoading in
            self?.showIsActivityIndicator(isLoading)
        }.store(in: &cancellables)
    }

    private func bindingOff() {
        cancellables.removeAll()
    }

    private func loadWebView() {
        guard let url = URL(string: webViewURL) else { return }
        let request = URLRequest(url: url)
        webView.load(request)

        // Если через 5 секунд не начинается загрузка, выводим ошибку о проблеме с сетью
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [ weak self ] in
            self?.checkInternet()
        }
    }

    private func checkInternet() {
        if viewState.value == .empty {
            //ErrorHandler.handle(error: AppError.networkError(code: nil))
            // TODO: - Обработчик ошибок
            webView.stopLoading()
        }
    }

    private func updateProgressValue(_ progress: Double) {
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(progress)
            if progress < 1 {
                self.progressView.isHidden = false
            } else {
                self.progressView.isHidden = true
            }
        }
    }

    private func showIsActivityIndicator(_ viewState: ViewState) {
        switch viewState {
        case .loading:
            activityIndicator.startAnimating()
        case .done:
            activityIndicator.stopAnimating()
        case .empty:
            activityIndicator.stopAnimating()
        }
    }

    private func setupView() {
        view.backgroundColor = .anWhite
        webView.navigationDelegate = self
    }

    private func setupConstraints() {
        [progressView,
         webView,
         activityIndicator].forEach { view.addSubview($0) }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            progressView.heightAnchor.constraint(equalToConstant: 2),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])

    }

}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        viewState.send(.loading)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewState.send(.done)
    }

}
