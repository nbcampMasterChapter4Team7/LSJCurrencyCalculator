//
//  LastView+CoreDataProperties.swift
//  LSJCurrencyCalculator
//
//  Created by yimkeul on 4/18/25.
//
//

import Foundation
import CoreData


extension LastView {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastView> {
        return NSFetchRequest<LastView>(entityName: "LastView")
    }

    @NSManaged public var screenType: String
    @NSManaged public var currencyCode: String?

}

extension LastView : Identifiable {

}
