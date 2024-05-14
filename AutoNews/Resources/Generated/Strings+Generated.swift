// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L {
  public enum Main {
    /// Новостей пока нет
    public static let empty = L.tr("Localizable", "main.empty", fallback: "Новостей пока нет")
    /// Новости
    public static let news = L.tr("Localizable", "main.news", fallback: "Новости")
  }
  public enum NetworkError {
    /// Ошибка запроса, код ошибки
    public static let httpStatusCode = L.tr("Localizable", "networkError.httpStatusCode", fallback: "Ошибка запроса, код ошибки")
    /// Нет соединения с интернетом
    public static let notConnect = L.tr("Localizable", "networkError.notConnect", fallback: "Нет соединения с интернетом")
    /// Не правильный запрос
    public static let notCorrectRequest = L.tr("Localizable", "networkError.notCorrectRequest", fallback: "Не правильный запрос")
    /// Ошибка парсинга
    public static let parsing = L.tr("Localizable", "networkError.parsing", fallback: "Ошибка парсинга")
  }
  public enum News {
    /// Открыть полную новость на сайте
    public static let openFullURL = L.tr("Localizable", "news.openFullURL", fallback: "Открыть полную новость на сайте")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
