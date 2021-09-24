//
//  CollectionViewLayout.swift
//  Ting
//
//  Created by 朱偉綸 on 2021/7/13.
//

import Foundation
import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var rows = [CollectionViewRow]()
        
        var currentRowY: CGFloat = -1

        for attribute in attributes {
            if currentRowY != attribute.frame.origin.y{
                currentRowY = attribute.frame.origin.y
                rows.append(CollectionViewRow(spacing: 10))
            }
            rows.last?.add(attribute: attribute)
        }
        rows.forEach { $0.leftLayout() }
        return rows.flatMap { $0.attributes }
    }
}

class CollectionViewRow {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing:CGFloat = 0
    
    init(spacing: CGFloat) {
        self.spacing = spacing
    }
    
    func add(attribute: UICollectionViewLayoutAttributes){
        attributes.append(attribute)
    }
  
    var rowWidth: CGFloat {
        return attributes.reduce(0, { result, attribute -> CGFloat in
            return result + attribute.frame.width
        }) + CGFloat(attributes.count - 1) * spacing
    }
    
    func centerLayout(collectionViewWidth: CGFloat) {
        let padding = (collectionViewWidth - rowWidth) / 2
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = offset
            offset += attribute.frame.width + spacing
        }
    }
    
    func leftLayout(){
        var offset = CGFloat(0)
        for attribute in attributes{
            attribute.frame.origin.x = offset
            offset += attribute.frame.width + spacing
        }
    }
    
    func rightLayout(collectionViewWidth: CGFloat){
        let padding = collectionViewWidth - rowWidth
        var offset = padding
        
        for attribute in attributes{
            attribute.frame.origin.x = offset
            offset += attribute.frame.width + spacing
        }
    }
}
