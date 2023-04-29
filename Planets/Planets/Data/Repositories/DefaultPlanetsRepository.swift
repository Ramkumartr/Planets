//
//  DefaultPlanetsRepository.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

// **Note**: DTOs structs are mapped into Domains here, and Repository protocols does not contain DTOs

import Foundation

final class DefaultPlanetsRepository {
    
    private let dataTransferService: DataTransferService
    private let cache: PlanetsResponseStorage
    
    init(dataTransferService: DataTransferService, cache: PlanetsResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultPlanetsRepository: PlanetsRepository {
    
    public func fetchPlanets(query: PlanetsQueryModel,
                             cached: @escaping (PlanetsPage) -> Void,
                             completion: @escaping (Result<PlanetsPage, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = PlanetsRequestDTO(page: query.page)
        let task = RepositoryTask()
        
        cache.getResponse(for: requestDTO) { result in
            
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
            guard !task.isCancelled else { return }
            
            let endpoint = APIEndpoints.getPlanetsList(with: requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    self.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
