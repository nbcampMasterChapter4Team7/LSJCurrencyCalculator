//
//  Favorite+CoreDataProperties.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/16/25.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var currency: String?
    @NSManaged public var rate: Double
    @NSManaged public var isFavorite: Bool

}

extension Favorite : Identifiable {

}
