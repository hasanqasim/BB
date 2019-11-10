//
//  VisitListViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit

class VisitListViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    var visits = [FirebaseReading]()
    var filteredVisits = [FirebaseReading]()
    
    var time = Date()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name"
        
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    
}



extension VisitListViewController: DatabaseListener{
    func onFirebaseReadingListChange(change: DatabaseChange, firebaseReading: [FirebaseReading]) {
        if firebaseReading.count > 0 {
            visits = firebaseReading.sorted(by: { $0.timestamp > $1.timestamp })
            filteredVisits = visits
            tableView.reloadData()
        }
    }
    
    
}

// for the tableview delegate methods

extension VisitListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVisits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let visit = filteredVisits[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitListTableViewCell") as! VisitListTableViewCell
        cell.setValue(visit)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = UIStoryboard(name: "DetailView", bundle: nil).instantiateInitialViewController() as! DetailViewController
        viewController.visit = filteredVisits[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //used this only for animating the tableviews
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if time.timeIntervalSinceNow < -2 {
            cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
            cell.alpha = 0
            UIView.animate(withDuration: 0.75){
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1
            }
        }
    }
    
}

// for search bar delegate methods

extension VisitListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredVisits = visits.filter({ (visit: FirebaseReading) -> Bool in
                return visit.name.lowercased().contains(searchText.lowercased())
            })
        }
        else{
            filteredVisits = visits
        }
        tableView.reloadData()
        
    }
}
