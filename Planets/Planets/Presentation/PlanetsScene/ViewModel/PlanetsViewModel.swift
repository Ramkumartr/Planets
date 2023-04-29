//
//  PlanetsViewModel.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import Foundation

struct PlanetsViewModelActions {
    let showPlanetDetails: (Planet) -> Void
}

enum PlanetsViewModelLoading {
    case requesting
}

protocol PlanetsViewModelInput {
    func onViewDidLoad()
}

protocol PlanetsViewModelOutput {
    var planets: Observable<[PlanetItemModel]> { get }
    var loading: Observable<PlanetsViewModelLoading?> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
}

protocol PlanetsViewModel: PlanetsViewModelInput, PlanetsViewModelOutput {}

final class DefaultPlanetsViewModel: PlanetsViewModel {
    
    private let fetchPlanetsUseCase: FetchPlanetsUseCase
    private let actions: PlanetsViewModelActions?
    
    let currentPage: Int = 1
    private var pages: [PlanetsPage] = []
    private var planetsLoadTask: Cancellable? { willSet { planetsLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    
    let planets: Observable<[PlanetItemModel]> = Observable([])
    let loading: Observable<PlanetsViewModelLoading?> = Observable(.none)
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return planets.value.isEmpty }
    let screenTitle = NSLocalizedString("Planets", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    
    // MARK: - Init
    
    init(fetchPlanetsUseCase: FetchPlanetsUseCase,
         actions: PlanetsViewModelActions? = nil) {
        self.fetchPlanetsUseCase = fetchPlanetsUseCase
        self.actions = actions
    }
    
    // MARK: - Private
    
    private func appendPage(_ planetsPage: PlanetsPage) {
        pages = pages
            .filter { $0.next != planetsPage.next }
        + [planetsPage]
        
        planets.value = pages.planets.map(PlanetItemModel.init).sorted(by: {$0.name ?? "" < $1.name ?? ""})
    }
    
    private func load(planestQuery: PlanetsQueryModel, loading: PlanetsViewModelLoading) {
        self.loading.value = .requesting
        
        planetsLoadTask = fetchPlanetsUseCase.execute(
            requestValue: .init(query: planestQuery),
            cached: appendPage,
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                self.loading.value = .none
            })
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
        NSLocalizedString("No internet connection", comment: "") :
        NSLocalizedString("Failed loading planets from network", comment: "")
    }
    
}

// MARK: - INPUT. View event methods

extension DefaultPlanetsViewModel {
    
    func onViewDidLoad() {
        load(planestQuery: .init(page: String(currentPage)), loading: .requesting)
    }
}

// MARK: - Private

private extension Array where Element == PlanetsPage {
    var planets: [Planet] { flatMap { $0.results } }
}
