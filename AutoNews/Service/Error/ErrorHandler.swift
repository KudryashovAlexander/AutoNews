//
//  ErrorHandler.swift
//  AutoNews
//
//  Created by Александр Кудряшов on 14.05.2024.
//

import UIKit

enum AppError: Error, Equatable {
    case customError(String)
    case getNewsError
    case networkError
    case parsingError
    case statucCodeError(code: Int)
}

final class ErrorHandler {
    static func handle(error: AppError, handler: (() -> Void)? = nil) {
        showAlert(title: "Error",
                  message: message(for: error),
                  handler: handler)
    }

    private static func message(for error: AppError) -> String {
        switch error {
        case .customError(let message):
            return message
        case .getNewsError:
            return L.NetworkError.notCorrectRequest
        case .networkError:
            return L.NetworkError.notConnect
        case .parsingError:
            return L.NetworkError.parsing
        case .statucCodeError(let code):
            return L.NetworkError.httpStatusCode + " \(code)"
        }
    }

    private static func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                if let handler = handler {
                    handler()
                }
            }))

            UIViewController.topMostViewController()?.present(alert, animated: true)
        }
    }
}

