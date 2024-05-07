//
//  TextField+Extension.swift
//  GithubSearch
//
//  Created by 최지철 on 5/7/24.
//

import UIKit

extension UITextField {
  func addLeftPadding() { /// 텍스트 필드 왼쪽에 패딩값을 주기위한 함수입니다.
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
