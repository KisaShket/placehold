//
//  TableViewController.swift
//  TestExcApp
//
//  Created by Kisa Shket on 17.01.2021.
//

import UIKit

class TableViewController: UITableViewController {
    let cacher = DataCacher()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        downloadImage(withIndex: indexPath.row, forCell: cell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if cacher.isImgExist(index: indexPath.row) {
        let detailStoryBoard = UIStoryboard.init(name: "DetailView", bundle: nil)
        let detailViewController = detailStoryBoard.instantiateViewController(identifier: "Detail", creator: nil) as DetailViewController
        detailViewController.index = indexPath.row
        navigationController?.pushViewController(detailViewController, animated: true)
        }
        else{
        downloadImage(withIndex: indexPath.row, forCell: cell)
        }
    }
    
    func downloadImage(withIndex index: Int, forCell cell: UITableViewCell) {
        guard let cell = cell as? TableViewCell else { return }
        cell.textLabel?.text = "Downloading"
        cell.isUserInteractionEnabled = false
        cell.imageViewContainer.image = nil
        NetworkService.shared.request(withIndex: index + 1) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let img):
                    cell.isUserInteractionEnabled = true
                    cell.textLabel?.text = nil
                    cell.imageViewContainer.image = img
                    
                case .failure(let err):
                    cell.isUserInteractionEnabled = true
                    print(err.localizedDescription)
                }
            }
        }
    }
    
}
