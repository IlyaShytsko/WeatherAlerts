//
//  ViewController.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 13.02.24.
//

import UIKit

final class WeatherAlertViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    enum WeatherAlertSections {
        case main
    }
    
    // MARK: - Properties
    
    private var apiClient: ApiClientProtocol = ApiClient()
    private var viewModel: WeatherAlertsViewModel?
    
    private var dataSource: UITableViewDiffableDataSource<WeatherAlertSections, WeatherAlertsModel.AlertProperties>!
    private var shouldEnableRefreshControl = true
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadWeatherAlerts), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    private lazy var placeholderErrorView: PlaceholderErrorView = {
        let view = PlaceholderErrorView.instance()
        view.onRefreshData = { [weak self] in
            self?.loadWeatherAlerts()
        }
        return view
    }()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureDataSource()
        loadWeatherAlerts()
        updateRefreshControl()
    }
    
    // MARK: - Private
    
    private func setupTableView() {
        tableView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        tableView.delegate = self
        placeholderErrorView.isLoading = true
        tableView.backgroundView = placeholderErrorView
    }
    
    @objc private func loadWeatherAlerts() {
        Task {
            do {
                let model: WeatherAlertsModel = try await apiClient.request(.alertRequest)
                viewModel = WeatherAlertsViewModel(alerts: model)
                updateUIForSuccess()
            } catch {
                updateUIForFailure(with: error)
            }
        }
    }
    
    private func updateUIForSuccess() {
        guard let viewModel else { return }
        shouldEnableRefreshControl = true
        placeholderErrorView.isLoading = false
        tableView.backgroundView = nil
        updateRefreshControl()
        viewModel.resetCache()
        performTableUpdate(with: [])
        performTableUpdate(with: viewModel.alerts)
    }
    
    private func updateUIForFailure(with error: Error) {
        shouldEnableRefreshControl = false
        placeholderErrorView.error = error
        tableView.backgroundView = placeholderErrorView
        updateRefreshControl()
        viewModel?.resetCache()
        performTableUpdate(with: [])
    }
    
    private func updateRefreshControl() {
        if shouldEnableRefreshControl {
            if tableView.refreshControl == nil {
                let refreshControl = UIRefreshControl()
                refreshControl.addTarget(self, action: #selector(loadWeatherAlerts), for: .valueChanged)
                tableView.refreshControl = refreshControl
            }
        } else {
            tableView.refreshControl = nil
        }
        if tableView.refreshControl?.isRefreshing == true {
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func obtainImageFromNetwork() async -> UIImage {
        do {
            let image = try await apiClient.fetchRandomImage()
            let resizedImage = await image?.resizedAsync(toWidth: 200)
            return resizedImage ?? UIImage(named: "danger")!
        } catch {
            return UIImage(named: "danger")!
        }
    }
    
    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? WeatherAlertCell, let id = cell.model?.id else { return }
        let cacheKey = NSString(string: id)
        
        if let cachedImage = viewModel?.getImage(forKey: cacheKey) {
            cell.image = cachedImage
        } else {
            Task {
                do {
                    let image = await obtainImageFromNetwork()
                    viewModel?.setImage(forKey: cacheKey, image: image)
                    await MainActor.run {
                        if let currentCell = tableView.cellForRow(at: indexPath) as? WeatherAlertCell, currentCell === cell {
                            cell.image = image
                        }
                    }
                }
            }
        }
    }
}

extension WeatherAlertViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        configureCell(cell, at: indexPath)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<WeatherAlertSections, WeatherAlertsModel.AlertProperties>(tableView: tableView) {
            tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherAlertCell.reuseIdentifier, for: indexPath) as! WeatherAlertCell
            cell.model = model
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    private func performTableUpdate(with model: [WeatherAlertsModel.AlertProperties]) {
        var snapshot = NSDiffableDataSourceSnapshot<WeatherAlertSections, WeatherAlertsModel.AlertProperties>()
        snapshot.appendSections([.main])
        snapshot.appendItems(model)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
