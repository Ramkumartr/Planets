//
//  NetworkSessionManagerMock.swift
//  PlanetsTests
//
//  Created by Ramkumar Thiyyakat on 01/05/23.
//

import Foundation

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data, response, error)
        return URLSessionDataTask()
     //   return URLSessionTask()
    }
}
