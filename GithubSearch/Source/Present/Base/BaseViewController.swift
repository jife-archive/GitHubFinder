//
//  BaseViewController.swift
//  GithubSearch
//
//  Created by Choi on 5/7/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    func layout() {}
    func configure() {}
    func addView() {}
    func binding() {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.configure()
        self.addView()
        self.layout()
        self.binding()
    }
}
