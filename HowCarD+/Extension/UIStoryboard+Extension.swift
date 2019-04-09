//
//  UIStoryboard+Extension.swift
//  HowCarD
//
//  Created by lohsts on 2019/4/2.
//  Copyright © 2019 lohsts. All rights reserved.
//

import UIKit

struct StoryboardCategory {

    static let main = "Main"

    static let dRecommend = "DRecommendation"

    static let discounts = "Discounts"

    static let cards = "Cards"

    static let wallet = "Wallet"

    static let qa = "QA"

    static let filter = "Filter"

}

extension UIStoryboard {

    static var main: UIStoryboard { return hcStoryboard(name: StoryboardCategory.main) }

    static var dRecommend: UIStoryboard { return hcStoryboard(name: StoryboardCategory.dRecommend) }

    static var discounts: UIStoryboard { return hcStoryboard(name: StoryboardCategory.discounts) }

    static var cards: UIStoryboard { return hcStoryboard(name: StoryboardCategory.cards) }

    static var wallet: UIStoryboard { return hcStoryboard(name: StoryboardCategory.wallet) }

    static var qa: UIStoryboard { return hcStoryboard(name: StoryboardCategory.qa) }

    static var filter: UIStoryboard { return hcStoryboard(name: StoryboardCategory.filter)}

    private static func hcStoryboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}
