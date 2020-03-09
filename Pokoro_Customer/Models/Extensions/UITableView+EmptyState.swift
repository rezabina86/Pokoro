//
//  UITableView+EmptyState.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-08.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

extension UITableView {
    
    func showEmptyView(title: String, subtitle: String? = nil, image: UIImage? = nil) {
        let emptyView = PKEmptyStateView(frame: self.frame)
        emptyView.title = title
        emptyView.subtitle = subtitle
        emptyView.image = image
        self.backgroundView = emptyView
    }
    
    func hideEmptyView() {
        self.backgroundView = nil
    }
    
}
