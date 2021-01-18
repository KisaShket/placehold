//
//  DetailViewController.swift
//  TestExcApp
//
//  Created by Kisa Shket on 18.01.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let cacher = DataCacher()
    var index: Int? 
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = index {
            detailImage.image = cacher.loadImageFromDiskWith(index: index)
        }
        
    }
    
}
