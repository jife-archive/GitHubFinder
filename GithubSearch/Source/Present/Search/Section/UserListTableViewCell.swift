//
//  UserListTableViewCell.swift
//  GithubSearch
//
//  Created by 최지철 on 5/7/24.
//

import UIKit

import Kingfisher

final class UserListTableViewCell: UITableViewCell {
    // MARK: - Properties

    static let identifier = "UserListTableViewCell"
    
    // MARK: - Properties

    private let userImg = UIImageView().then {
        $0.image = UIImage(systemName: "square.and.arrow.up")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.clipsToBounds = true
    }
    private let userNameLabel = UILabel().then {
        $0.text = "asdasdasdasdsad"
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .black
        $0.sizeToFit()
    }
    private let urlLabel = UILabel().then {
        $0.text = "asdasdasdasdsad"
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .blue
        $0.sizeToFit()
    }
    private let labelSV = UIStackView().then {
        $0.spacing = 4
        $0.axis = .vertical
    }
    
    // MARK: - Method

    private func layout() {
        [userNameLabel, urlLabel].forEach {
            labelSV.addArrangedSubview($0)
        }
        [userImg, labelSV].forEach {
            self.addSubview($0)
        }
        
        userImg.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        labelSV.snp.makeConstraints {
            $0.leading.equalTo(userImg.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(name: String, url: String, img: String) {
        self.userNameLabel.text = name
        self.urlLabel.text = url
        if let imageURL = URL(string: img) {
            self.userImg.kf.setImage(with: imageURL)
        }
    }
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        layout()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
