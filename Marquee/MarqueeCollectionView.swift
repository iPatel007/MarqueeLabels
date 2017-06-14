//
//  InfiniteCollectionView.swift
//  ExampleInfiniteScrollView
//
//  Created by Mason L'Amy on 04/08/2015.
//  Copyright (c) 2015 Maso Apps Ltd. All rights reserved.
//

import UIKit

protocol MarqueeCollectionViewDataSource {
    func cellForItemAtIndexPath(_ collectionView: UICollectionView, dequeueIndexPath: IndexPath, usableIndexPath: IndexPath) -> UICollectionViewCell
    func numberOfItems(_ collectionView: UICollectionView) -> Int
}

protocol MarqueeCollectionViewDelegate {
    func didSelectCellAtIndexPath(_ collectionView: UICollectionView, usableIndexPath: IndexPath)
}

class MarqueeCollectionView: UICollectionView
{
    var infiniteDataSource: MarqueeCollectionViewDataSource?
    var infiniteDelegate: MarqueeCollectionViewDelegate?
    
    var cellPadding = CGFloat(0)
    var cellWidth = CGFloat(0)
    var indexOffset = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        dataSource = self
        delegate = self
        setupCellDimensions()
    }
    
    func setupCellDimensions() {
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        cellPadding = layout.minimumInteritemSpacing
        cellWidth = layout.itemSize.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centreIfNeeded()
    }

    func centreIfNeeded() {
        let currentOffset = contentOffset
        let contentWidth = getTotalContentWidth()

        let centerOffsetX: CGFloat = (3 * contentWidth - bounds.size.width) / 2
        let distFromCentre = centerOffsetX - currentOffset.x
        
        if (fabs(distFromCentre) > (contentWidth / 4)) {
            let cellcount = distFromCentre/(cellWidth+cellPadding)
            let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))
            
            let offsetCorrection = (abs(cellcount).truncatingRemainder(dividingBy: 1)) * (cellWidth+cellPadding)
            if (contentOffset.x < centerOffsetX) {
                contentOffset = CGPoint(x: centerOffsetX - offsetCorrection, y: currentOffset.y)
            }
            else if (contentOffset.x > centerOffsetX) {
                contentOffset = CGPoint(x: centerOffsetX + offsetCorrection, y: currentOffset.y)
            }
            shiftContentArray(getCorrectedIndex(shiftCells))
            reloadData()
        }
    }
    
    func shiftContentArray(_ offset: Int) {
        indexOffset += offset
    }
    
    func getTotalContentWidth() -> CGFloat {
        let numberOfCells = infiniteDataSource?.numberOfItems(self) ?? 0
        return CGFloat(numberOfCells) * (cellWidth + cellPadding)
    }
}

extension MarqueeCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let currentIndexPath = IndexPath(row: getCorrectedIndex(indexPath.row - indexOffset), section: 0)
        let width = marqueeVC.arrayForMarqueeItems[currentIndexPath.item]["title"]?.widthOfString(usingFont: UIFont.systemFont(ofSize: 17))

        print(cellWidth)
        print(marqueeVC.arrayForMarqueeItems[currentIndexPath.item]["title"]!)
        
            
        cellWidth = width! + 5
        centreIfNeeded ()
        return CGSize(width: cellWidth , height: self.frame.size.height)
    }
}

extension MarqueeCollectionView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = infiniteDataSource?.numberOfItems(self) ?? 0
        return  3 * numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // setupCellDimensions()
        return infiniteDataSource!.cellForItemAtIndexPath(self, dequeueIndexPath: indexPath, usableIndexPath: IndexPath(row: getCorrectedIndex(indexPath.row - indexOffset), section: 0))
    }
    
    func getCorrectedIndex(_ indexToCorrect: Int) -> Int {
        if let numberOfCells = infiniteDataSource?.numberOfItems(self) {
            if (indexToCorrect < numberOfCells && indexToCorrect >= 0) {
                return indexToCorrect
            }
            else {
                let countInIndex = Float(indexToCorrect) / Float(numberOfCells)
                let flooredValue = Int(floor(countInIndex))
                let offset = numberOfCells * flooredValue
                return indexToCorrect - offset
            }
        }
        else {
            return 0
        }
    }
}

extension MarqueeCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        infiniteDelegate?.didSelectCellAtIndexPath(self, usableIndexPath: IndexPath(row: getCorrectedIndex(indexPath.row - indexOffset), section: 0))
    }
}

extension MarqueeCollectionView {
    
    override var dataSource: UICollectionViewDataSource? {
        didSet {
            if (!self.dataSource!.isEqual(self)) {
                self.dataSource = self
            }
        }
    }
    
    override var delegate: UICollectionViewDelegate? {
        didSet {
            if (!self.delegate!.isEqual(self)) {
                self.delegate = self
            }
        }
    }
}

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
}
