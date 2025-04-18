//
//  CachedCurrency+CoreDataProperties.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/18/25.
//
//

import Foundation
import CoreData


extension CachedCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedCurrency> {
        return NSFetchRequest<CachedCurrency>(entityName: "CachedCurrency")
    }

    @NSManaged public var currencyCode: String
    @NSManaged public var rate: Double
    @NSManaged public var timeUnix: Int64
    @NSManaged public var change: String

}

extension CachedCurrency : Identifiable {

}
