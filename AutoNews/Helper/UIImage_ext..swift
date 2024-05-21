//
//  UIImage_ext..swift
//  AutoNews
//
//  Created by Александр Кудряшов on 20.05.2024.
//

import UIKit

extension UIImage {
    
    func downSample(to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let currrentSize = self.size
        let newScale = min(pointSize.width, pointSize.height) / min(currrentSize.height, currrentSize.width)
        let newSize = CGSize(width: currrentSize.width * newScale, height: currrentSize.height * newScale)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        self.draw(in: CGRect(origin: .zero, size: newSize))
        guard let downscaledImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        return downscaledImage
    }
}
