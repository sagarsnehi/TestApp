//
//  UIImageView+ImageCache.swift
//  WiproTest
//
//  Created by sagar snehi on 09/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import UIKit

extension UIImageView {
    
    
    /// Asynchronously loads an image with URL into this image view
    ///
    /// - Parameter url: The URL location of the image
    /// - Parameter showActivity: Shows a loading indicator if
    public func loadImage(withUrl url: URL, showActivity: Bool = true) {
        
        var activityIndicator: UIActivityIndicatorView?
        if (showActivity) {
            activityIndicator = UIActivityIndicatorView()
            addSubview(activityIndicator!)
            activityIndicator!.color = .darkGray
            activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicator!.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicator!.startAnimating()
        }
        _ = URLSession.shared.loadImage(from: url) { [weak self] (image) in
            DispatchQueue.main.async {
                guard let image = image else {
                    debugPrint("Error fetching Image")
                    activityIndicator?.stopAnimating()
                    activityIndicator?.removeFromSuperview()
                    self?.image = UIImage.init(named: kPlaceholderImage)
                    return
                }
                activityIndicator?.stopAnimating()
                activityIndicator?.removeFromSuperview()
                self?.backgroundColor = UIColor.clear
                self?.image = image
            }
        }
    }
}
