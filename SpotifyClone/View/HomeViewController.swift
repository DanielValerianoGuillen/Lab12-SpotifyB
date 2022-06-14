//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by MAC17 on 13/06/22.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    let searchViewModel = SearchViewModel()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var textDidChangeSave: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearch()
        setUpTable()
        Task {
            await setUpData()
        }
    }
    
    func setUpSearch() {
        searchBar.delegate = self
    }
    
    func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpData() async {
        await searchViewModel.getSearchMusic(name: "rock")
        tableView.reloadData()
    }

}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textDidChangeSave = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(textDidChangeSave)
        self.view.endEditing(true)
        Task {
            await searchViewModel.getSearchMusic(name: textDidChangeSave)
            tableView.reloadData()
        }
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.searchResult?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemSearchTableViewCell
        
        let row = searchViewModel.searchResult?.items[indexPath.row].album
        
        cell.lblTitle.text = row?.name
        cell.lblDescription.text = row?.artists[0].name
        cell.converImage.sd_setImage(with: URL(string: row?.images[0].url ?? ""))
        
        return cell
    }
}
