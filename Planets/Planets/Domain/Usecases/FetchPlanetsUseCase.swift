//
//  FetchPlanetsUseCase.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation

protocol FetchPlanetsUseCase {
    func execute(requestValue: FetchPlanetsUseCaseRequestValue,
                 cached: @escaping (PlanetsPage) -> Void,
                 completion: @escaping (Result<PlanetsPage, Error>) -> Void) -> Cancellable?
}

final class DefaultFetchPlanetsUseCase: FetchPlanetsUseCase {
    
    private let planetsRepository: PlanetsRepository
    
    init(planetsRepository: PlanetsRepository) {
        
        self.planetsRepository = planetsRepository
    }
    
    func execute(requestValue: FetchPlanetsUseCaseRequestValue, cached: @escaping (PlanetsPage) -> Void,
                 completion: @escaping (Result<PlanetsPage, Error>) -> Void) -> Cancellable? {
        
        return planetsRepository.fetchPlanets(query: requestValue.query, cached: cached,
                                              completion: { result in
            completion(result)
        })
    }
}

struct FetchPlanetsUseCaseRequestValue {
    let query: PlanetsQueryModel
}
