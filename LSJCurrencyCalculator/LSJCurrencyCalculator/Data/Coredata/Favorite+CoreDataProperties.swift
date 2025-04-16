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

/*
- `@nonobjc` = Objective-C 에서는 동작하지 않고 Swift 에서만 동작하는 메서드임을 명시.
- `fetchRequest()` = Favorite 에 대한 여러가지 데이터 검색을 도움.
- `@NSManaged` = CoreData 에 의해 관리되는 객체를 의미.
- `Identifiable` = Favorite 타입이 고유하게 식별될 수 있음을 의미.
*/
