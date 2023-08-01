//
//  ListViewController.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    private let vm = LaunchesViewModel()
    
    private lazy var cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 100)
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(LaunchCollectionViewCell.self, forCellWithReuseIdentifier: "LaunchCollectionViewCell")
        vw.dataSource = self
        
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        vm.onLaunchUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.cv.reloadData()
            }
        }
    }
    
}

private extension ListViewController {
    
    func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Launches"
        
        self.view.backgroundColor = .white
        self.view.addSubview(cv)
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: view.topAnchor),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        cv.delegate = self
    }
    
}

// MARK: - CollectionView functions
extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.allLaunches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = vm.allLaunches[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchCollectionViewCell", for: indexPath) as! LaunchCollectionViewCell
        cell.item = item
        
        return cell
    }
}
