//
//  PageInfoHeaderViewN.swift
//  STYLiSH
//
//  Created by yueh on 2019/7/21.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class PageInfoHeaderView: UIView, UIScrollViewDelegate {
    
    let pageScrollView = UIScrollView()
    let pageControl = UIPageControl(frame: CGRect.zero)
    let fullScreen = UIScreen.main.bounds
    
    init(numberOfImage: Int, images: [String]) {
        super .init(frame: CGRect.zero)
//        self.backgroundColor = .blue
        setupScrollLViewayout(number: numberOfImage)
        showImage(number: numberOfImage, images: images)
        changePageLayout(number: numberOfImage)
        pageScrollView.delegate = self
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ScrollLView
    func setupScrollLViewayout(number: Int) {
        
        pageScrollView.contentSize.height = 500
        pageScrollView.contentSize.width = fullScreen.width * CGFloat(number)
        pageScrollView.isPagingEnabled = true
        pageScrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageScrollView)
        
        NSLayoutConstraint.activate([
            pageScrollView.topAnchor.constraint(equalTo: topAnchor),
            pageScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    // MARK: - showImage
    func showImage(number: Int, images: [String]) {
       let putImageStackView = UIStackView(frame: CGRect.zero)
        putImageStackView.axis = .horizontal //指定方向
        putImageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for num in 0...number-1 {
            let showImageView = UIImageView(frame: CGRect.zero)
            let url = URL(string: images[num])
            showImageView.kf.setImage(with: url)
            showImageView.contentMode = .scaleAspectFill
            showImageView.clipsToBounds = true
            
            showImageView.translatesAutoresizingMaskIntoConstraints = false

            putImageStackView.addArrangedSubview(showImageView)
            showImageView.widthAnchor.constraint(equalToConstant: fullScreen.width).isActive = true
            showImageView.heightAnchor.constraint(equalToConstant: pageScrollView.contentSize.height).isActive = true
        }
      
        pageScrollView.addSubview(putImageStackView)
    }

    // MARK: - 更換頁面
    func changePageLayout(number: Int) {
        
        pageControl.numberOfPages = number
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.pageIndicatorTintColor = .white
        self.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        pageControl.addTarget(self, action: #selector (pageChanged(sender:)), for: .valueChanged)
        
    }

    @objc func pageChanged(sender: UIPageControl) {
        let currentPageNumber = sender.currentPage
        let width = pageScrollView.frame.size.width
        let offset = CGPoint(x: width * CGFloat(currentPageNumber), y: 0)
        pageScrollView.setContentOffset(offset, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         let currentPage = Int(pageScrollView.contentOffset.x / pageScrollView.frame.size.width)
        print("x:\(pageScrollView.contentOffset.x)")
        print("寬度:\(pageScrollView.frame.size.width)")
        print(currentPage)
        pageControl.currentPage = currentPage
        
    }
    
}
