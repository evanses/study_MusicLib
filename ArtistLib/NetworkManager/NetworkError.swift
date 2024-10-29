//
//  NetworkError.swift
//  ArtistLib
//
//  Created by eva on 29.10.2024.
//

enum NetworkError: Error {
    case urlNotValid
    case noData
    case parsingError
    case notInternet
    case responseError
    case smthWentWrong
    
    var description: String {
        switch self {
        case .urlNotValid:
            return "Неверный URL изображения"
        case .noData:
            return "Нет данных"
        case .parsingError:
            return "Ошиюка парсинга данных"
        case .notInternet:
            return "Нет интернета"
        case .responseError:
            return "Неверный ответ сервера"
        case .smthWentWrong:
            return "Что-то пошло не так"
        }
        
    }
}
