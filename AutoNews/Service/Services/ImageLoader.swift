//
//  ImageLoader.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 14.05.2024.
//

import UIKit
import Combine

final class ImageLoader {
    
    private(set) var image: CurrentValueSubject<UIImage?,Never>
    private(set) var isLoading: CurrentValueSubject<Bool, Never>
    private var cancellable: AnyCancellable?
    
    private static let imageCache = NSCache<NSURL, UIImage>()
    
    init() {
        self.image = CurrentValueSubject(nil)
        self.isLoading = CurrentValueSubject(false)
    }

    func loadImage(from url: URL?) {
        guard let url else { return }
        
        if let cachedImage = ImageLoader.imageCache.object(forKey: url as NSURL) {
            self.image.send(cachedImage)
            return
        }
        
        isLoading.send(true)
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading.send(false)
            }, receiveValue: { [weak self] image in
                guard let self else { return }
                if let image = image {
                    ImageLoader.imageCache.setObject(image, forKey: url as NSURL)
                    self.image.send(image)
                    self.isLoading.send(false)
                }
            })
    }
    
    func cancelLoading() {
        cancellable?.cancel()
        isLoading.send(false)
        image.send(nil)
    }

}
