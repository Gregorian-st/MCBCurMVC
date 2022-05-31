//
//  MainViewController.swift
//  MCBCurMVC
//
//  Created by Grigory Stolyarov on 29.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private var exchangeRates: ExchangeRateResult?
    private var selectedExchangeRate: ExchangeRate?
    private let networkService = NetworkService()
    private let cellRateReuseID = "rateCell"
    private let showDetailSegueReuseID = "showDetail"
    private let rowHeight: CGFloat = 62
    private var refreshControl = UIRefreshControl()
    
    // MARK: - Outlets

    @IBOutlet weak var ratesTableView: UITableView!
    
    // MARK: - Actions
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        
        getExchangeRates()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupTableView()
        getExchangeRates()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showDetailSegueReuseID {
            guard let detailViewController = segue.destination as? DetailViewController
            else { return }
            if let exchangeRate = selectedExchangeRate {
                detailViewController.exchangeRate = exchangeRate
            }
        }
    }
    
    // MARK: - Program Logic
    
    private func setupTableView() {
        
        ratesTableView.register(UINib(nibName: "RatesTableViewCell", bundle: nil),
                                forCellReuseIdentifier: cellRateReuseID)
        ratesTableView.cellLayoutMarginsFollowReadableWidth = true
        ratesTableView.separatorStyle = .none
        
        refreshControl.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        ratesTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       
        getExchangeRates()
    }

    private func getExchangeRates() {
        
        networkService.getExchangeRates { [weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let rateResult):
                self.exchangeRates = rateResult
                DispatchQueue.main.async {
                    self.updateTitle()
                    self.ratesTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    if let alertMessage = self.exchangeRates?.message,
                       alertMessage != "" {
                        self.showAlert(alertMessage: alertMessage)
                        self.forceHideRefreshControl()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.showAlert(alertMessage: error.localizedDescription)
                    self.forceHideRefreshControl()
                }
            }
        }
    }
    
    private func forceHideRefreshControl() {
        
        if ratesTableView.contentOffset.y < 0 {
            ratesTableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    private func updateTitle() {
        
        if let ratesDate = self.exchangeRates?.ratesDate {
            navigationItem.title = ratesDate
        } else {
            navigationItem.title = "Currencies"
        }
    }
    
    private func showAlert(alertMessage: String) {
        
        let alertController = UIAlertController(title: "MCB Currency App",
                                                message: alertMessage,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok",
                                                style: UIAlertAction.Style.default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        exchangeRates?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellRateReuseID, for: indexPath) as! RatesTableViewCell
        if let exchangeRate = exchangeRates?.rates[indexPath.row] {
            cell.exchangeRate = exchangeRate
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedExchangeRate = exchangeRates?.rates[indexPath.row]
        self.performSegue(withIdentifier: showDetailSegueReuseID, sender: nil)
    }
}
