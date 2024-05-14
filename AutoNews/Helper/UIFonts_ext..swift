//
//  UIFonts_ext..swift
//  AutoNews
//
//  Created by Александр Кудряшов on 13.05.2024.
//

import UIKit

extension UIFont {

    enum Regular {
        static var small = UIFont.systemFont(ofSize: 13, weight: .regular)
        static var medium = UIFont.systemFont(ofSize: 15, weight: .regular)
        static var large = UIFont.systemFont(ofSize: 17, weight: .regular)
    }

    enum Medium {
        static var small = UIFont.systemFont(ofSize: 13, weight: .medium)
    }

    enum Bold {
        static var small = UIFont.systemFont(ofSize: 13, weight: .bold)
        static var medium = UIFont.systemFont(ofSize: 15, weight: .bold)
        static var large = UIFont.systemFont(ofSize: 17, weight: .bold)
        static var extraLarge = UIFont.systemFont(ofSize: 24, weight: .bold)
    }

}
