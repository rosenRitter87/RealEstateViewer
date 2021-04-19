//
//  RealEstateList.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 17/04/2021.
//

import Foundation

struct RealEstateList: Codable {
    var items: [RealEstate]?
    var totalCount: Int
}
