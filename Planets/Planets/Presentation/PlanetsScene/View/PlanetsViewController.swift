//
//  PlanetsViewController.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 23/04/23.
//

import UIKit

final class PlanetsViewController: UIViewController, Alertable {
    
    // a property to hold the tableView
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // set the delegate
        view.delegate = self
        // set the dataSource
        view.dataSource = self
        view.register(PlanetCell.self, forCellReuseIdentifier: "PlanetCell")
        return view
    }()
    
    
    private var vm: PlanetsViewModel!
    private var planets = [PlanetItemModel]()
    
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: PlanetsViewModel) -> PlanetsViewController {
        let view = PlanetsViewController()
        view.vm = viewModel
        view.navigationController?.isNavigationBarHidden = true
        return view
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        self.bind(to: vm)
        self.vm.onViewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func setUpViews() {
        
        self.title = vm.screenTitle
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.Background.white
        view.backgroundColor = UIColor.Background.white
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func bind(to viewModel: PlanetsViewModel) {
        vm.planets.observe(on: self) { [weak self] _ in
            self?.updateData()
        }
        
        viewModel.loading.observe(on: self) { [weak self] in
            self?.updateLoading($0)
        }
        
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        
    }
    
    private func updateData() {
        self.planets = self.vm.planets.value
        DispatchQueue.main.async { [weak self] in
            //  self?.activityIndicator.stop()
            self?.tableView.reloadData()
        }
    }
    
    private func updateLoading(_ status: PlanetsViewModelLoading?) {
        if status == .requesting {
            self.displayAnimatedActivityIndicatorView()
        } else {
            self.hideAnimatedActivityIndicatorView()
        }
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: vm.errorTitle, message: error)
    }
    
}

// MARK: - TableView Delegates
extension PlanetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanetCell.reuseIdentifier) as! PlanetCell
        cell.bind(to: planets[indexPath.item].name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets.count
    }
}

extension PlanetsViewController: UITableViewDelegate {
    
}


