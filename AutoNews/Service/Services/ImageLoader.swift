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
    
    init() {
        self.image = CurrentValueSubject(nil)
        self.isLoading = CurrentValueSubject(false)
    }

    func loadImage(from url: URL?, size: CGSize) {
        guard let url else { return }
        isLoading.send(true)
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading.send(false)
            }, receiveValue: {   [weak self] image in
                guard let self else { return }
                let compactImage = self.downsample(uiImage: image, to: size)
                self.image.send(compactImage)
                self.isLoading.send(false)
            })
    }
    
    func cancelLoading() {
        cancellable?.cancel()
        isLoading.send(false)
    }
    
    // сжимаем изображание под размеры
    private func downsample(uiImage: UIImage?,
                            to pointSize: CGSize,
                            scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        guard let uiImage else { return nil }
        let currrentSize = uiImage.size
        let newScale = min(pointSize.width, pointSize.height) / min(currrentSize.height, currrentSize.width)
        let newSize = CGSize(width: currrentSize.width * newScale, height: currrentSize.height * newScale)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        uiImage.draw(in: CGRect(origin: .zero, size: newSize))
        guard let downscaledImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        return downscaledImage
    }
    
}
