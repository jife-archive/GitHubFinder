//
//  TextField+Extension.swift
//  GithubSearch
//
//  Created by 최지철 on 5/7/24.
//

import UIKit

extension UITextField {
    
    func addLeftPadding() { /// 텍스트 필드 왼쪽에 패딩값을 주기위한 함수입니다.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightView(view: UIView) {  /// 텍스트 필드 오른쪽에 뷰를 넣고, 패딩값을 주기 위한 함수입니다.
        let container = UIView()
        container.addSubview(view)
        
        container.snp.makeConstraints {
            $0.width.equalTo(view.snp.width).offset(12)
            $0.height.equalTo(view.snp.height)
        }
        view.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        self.rightView = container
        self.rightViewMode = .always
     }
}
