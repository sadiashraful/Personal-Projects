//
//  ItemStore.swift
//  LootLogger
//
//  Created by Mohammad Ashraful Islam Sadi on 24/12/20.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    init(){
        for _ in 0..<5 {
            createItem()
        }
    }
}
