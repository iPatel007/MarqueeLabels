//
//  ViewController.swift
//  Marquee
//
//  Created by Amit Jarsaniya on 13/06/17.
//  Copyright © 2017 Amit Jarsaniya. All rights reserved.
//

import UIKit

var marqueeVC = MarqueeViewController()
class MarqueeViewController: UIViewController {
    
    let arrayForMarqueeItems = [["title": "Google - 1 dsadasdasda dasd", "link": "https://www.google.co.in"], ["title": "Twitter - 2", "link": "https://twitter.com/"], ["title": "Instagram - 3", "link": "https://www.instagram.com/?hl=en"], ["title": "Facebook - 4", "link": "https://www.facebook.com/"], ["title": "Yahoo - 5", "link": "https://in.yahoo.com/"], ["title": "Amazon - 6", "link": "https://www.amazon.in/"], ["title": "Flipkart - 7", "link": "https://www.flipkart.com/"]]
    
    @IBOutlet weak var marqueeCollView: MarqueeCollectionView! {
        didSet {
            marqueeCollView.backgroundColor = UIColor.white
            marqueeCollView.register(UINib(nibName: "MarqueeColleCtionCell", bundle: nil), forCellWithReuseIdentifier: "cellCollectionView")
            marqueeCollView.infiniteDataSource = self
            marqueeCollView.infiniteDelegate = self
            marqueeCollView.reloadData()
        }
    }
    
    // MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marqueeVC = self as MarqueeViewController
        
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.automaticScrollView), userInfo: nil, repeats: true)
    }
    
    // MARK: Timer Method
    func automaticScrollView() {
        marqueeCollView.contentOffset.x = marqueeCollView.contentOffset.x + 1
    }
}

// MARK: MarqueeCollectionViewDataSource Method
extension MarqueeViewController: MarqueeCollectionViewDataSource {
    
    func numberOfItems(_ collectionView: UICollectionView) -> Int {
        return arrayForMarqueeItems.count
    }
    
    func cellForItemAtIndexPath(_ collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath)  -> UICollectionViewCell  {
        let cell = marqueeCollView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView", for: dequeueIndexPath) as! MarqueeColleCtionCell
        cell.lbTitle.text = arrayForMarqueeItems[usableIndexPath.row]["title"]
        return cell
    }    
}

// MARK: MarqueeCollectionViewDelegate Method
extension MarqueeViewController: MarqueeCollectionViewDelegate {
    func didSelectCellAtIndexPath(_ collectionView: UICollectionView, usableIndexPath: IndexPath)
    {
        print("Selected cell with name \(arrayForMarqueeItems[usableIndexPath.row])")
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: arrayForMarqueeItems[usableIndexPath.row]["link"]!)!, options: [:], completionHandler: nil)
        }
        else {
           UIApplication.shared.openURL(URL(string: arrayForMarqueeItems[usableIndexPath.row]["link"]!)!)
        }
    }
}
