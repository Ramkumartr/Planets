//
//  AppDIContainer.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    private(set) lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    func makePlanetsSceneDIContainer() -> PlanetsSceneDIContainer {
        let dependencies = PlanetsSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return PlanetsSceneDIContainer(dependencies: dependencies)
    }
}
