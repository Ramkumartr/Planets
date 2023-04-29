//
//  PlanetsResponseStorage.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import Foundation

protocol PlanetsResponseStorage {
    func getResponse(for request: PlanetsRequestDTO, completion: @escaping (Result<PlanetsResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: PlanetsResponseDTO, for requestDto: PlanetsRequestDTO)
}
