//
//  FavoriteCurrency+CoreDataProperties.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/22/25.
//
//

import Foundation
import CoreData


extension FavoriteCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged public var currencyCode: String?
    @NSManaged public var isFavorite: Bool

}

extension FavoriteCurrency : Identifiable {

}
