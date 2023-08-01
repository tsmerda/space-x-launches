//
//  LaunchRowView.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import UIKit
import SDWebImage

class LaunchRowView: UIView {
    
    private lazy var dateLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 15, weight: .semibold)
        return lbl
    }()
    
    private lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        return lbl
    }()
    
    private lazy var successLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private lazy var imageVw: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var launchHStackVw: UIStackView = {
        let vw = UIStackView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.axis = .horizontal
        vw.spacing = 8
        return vw
    }()
    
    private lazy var launchVStackVw: UIStackView = {
        let vw = UIStackView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.axis = .vertical
        vw.spacing = 4
        return vw
    }()
    
    private var action: () -> ()
    
    init(action: @escaping () -> ()) {
        self.action = action
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(name: String, date: String, success: Bool, image: String) {
        nameLbl.text = name
        dateLbl.text = formatDate(date)
        successLbl.text = success ? "Success" : "Failure"
        
        self.imageVw.sd_setImage(with: URL(string: image))
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            dateFormatter.locale = Locale(identifier: "en")
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
}

private extension LaunchRowView {
    
    func setup() {
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let aspectRatioConstraint = imageVw.widthAnchor.constraint(equalTo: imageVw.heightAnchor, multiplier: 1)
        aspectRatioConstraint.priority = .defaultHigh
        aspectRatioConstraint.isActive = true
        
        self.addSubview(launchHStackVw)
        
        launchVStackVw.addArrangedSubview(dateLbl)
        launchVStackVw.addArrangedSubview(nameLbl)
        launchVStackVw.addArrangedSubview(successLbl)
        
        launchHStackVw.addArrangedSubview(launchVStackVw)
        launchHStackVw.addArrangedSubview(spacerView)
        launchHStackVw.addArrangedSubview(imageVw)
        
        NSLayoutConstraint.activate([
            launchHStackVw.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            launchHStackVw.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            launchHStackVw.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            launchHStackVw.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
