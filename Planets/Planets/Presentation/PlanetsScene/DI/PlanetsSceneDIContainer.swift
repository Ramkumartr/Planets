//
//  PlanetsSceneDIContainer.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import UIKit

final class PlanetsSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    private(set)  lazy var planetsResponseStorage: PlanetsResponseStorage = CoreDataPlanetsResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeFetchPlanetsUseCase() -> FetchPlanetsUseCase {
        return DefaultFetchPlanetsUseCase(planetsRepository: makePlanetsRepository())
    }
    
    
    // MARK: - Repositories
    func makePlanetsRepository() -> PlanetsRepository {
        return DefaultPlanetsRepository(dataTransferService: dependencies.apiDataTransferService, cache: planetsResponseStorage)
    }
    
    
    // MARK: - Planet List
    func makePlanetsViewController(actions: PlanetsViewModelActions) -> PlanetsViewController {
        return PlanetsViewController.create(with: makePlanetsViewModel(actions: actions))
    }
    
    func makePlanetsViewModel(actions: PlanetsViewModelActions) -> PlanetsViewModel {
        return DefaultPlanetsViewModel(fetchPlanetsUseCase: makeFetchPlanetsUseCase(),
                                       actions: actions)
    }
    
    // MARK: - Flow Coordinators
    func makePlanetsFlowCoordinator(router: Router) -> PlanetsFlowCoordinator {
        return PlanetsFlowCoordinator(router: router,
                                      dependencies: self)
    }
}

extension PlanetsSceneDIContainer: PlanetsFlowCoordinatorDependencies {}
