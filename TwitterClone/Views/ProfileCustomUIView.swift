//
//  ProfileCustomUIView.swift
//  TwitterClone
//
//  Created by Саша Восколович on 10.10.2023.
//

import UIKit



extension CGRect {
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}


class ProfileCustomUIView: UIView {
    
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
        layer.borderColor = UIColor.clear.cgColor
        updateCornerRadius()
    }
    
    
    func setAvatarImage(url: URL?) {
        avatarImageView.sd_setImage(with: url)
    }
    
    private func updateCornerRadius() {
        let radius = min(bounds.size.width, bounds.size.height) / 2.0
        avatarImageView.layer.cornerRadius = radius
    }
}
