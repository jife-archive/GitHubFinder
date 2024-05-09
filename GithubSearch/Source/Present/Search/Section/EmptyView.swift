//
//  EmptyView.swift
//  GithubSearch
//
//  Created by 최지철 on 5/8/24.
//

import UIKit

final class EmptyView: UIView {
    private let emptyImg = UIImageView().then {
        $0.image = UIImage(systemName: "person.fill")
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "아쉽게도, 해당 유저가 보이질 않네요."
        $0.font = .systemFont(ofSize: 15,weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    func configure(searchText: String) {
        titleLabel.text = "\(searchText)\n아쉽게도, 해당 유저가 보이질 않네요."
    }
    
    private func layout() {
        [emptyImg, titleLabel].forEach {
            self.addSubview($0)
        }
        emptyImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImg.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
