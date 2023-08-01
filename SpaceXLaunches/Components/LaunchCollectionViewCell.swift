//
//  LaunchCollectionViewCell.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import UIKit

class LaunchCollectionViewCell: UICollectionViewCell {
    
    private var vw: LaunchRowView?
    
    var item: Launch? {
        didSet {
            
            guard let name = item?.name,
                  let date = item?.dateUtc,
                  let success = item?.success,
                  let image = item?.links?.patch?.small else {
                return
            }
            
            vw?.set(name: name, date: date, success: success, image: image)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LaunchCollectionViewCell {
    
    func setup() {
        guard vw == nil else { return }
        
        vw = LaunchRowView{}
        
        self.contentView.addSubview(vw!)
        
        NSLayoutConstraint.activate([
            vw!.topAnchor.constraint(equalTo: contentView.topAnchor),
            vw!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vw!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vw!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
