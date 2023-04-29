//
//  PlanetsRepository.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation

protocol PlanetsRepository {
    @discardableResult
    func fetchPlanets(query: PlanetsQueryModel,
                      cached: @escaping (PlanetsPage) -> Void,
                      completion: @escaping (Result<PlanetsPage, Error>) -> Void) -> Cancellable?
}
