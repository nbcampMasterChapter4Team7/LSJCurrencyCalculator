//
//  FavoriteCurrency+CoreDataProperties.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/17/25.
//
//

import Foundation
import CoreData


extension FavoriteCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged public var currency: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var rate: Double

}

extension FavoriteCurrency : Identifiable {

}
