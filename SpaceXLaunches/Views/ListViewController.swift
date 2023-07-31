//
//  ListViewController.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    private let vm = LaunchesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
}

private extension ListViewController {
    
    func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Launches"
        self.view.backgroundColor = .white
    }
    
}
