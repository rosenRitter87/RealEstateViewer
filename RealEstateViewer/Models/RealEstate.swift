//
//  RealEstate.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 17/04/2021.
//

import Foundation

struct RealEstate: Codable, Identifiable {
    var id: Int
    var bedrooms: Int?
    var city: String?
    var area: Double?
    var url: String?
    var price: Double
    var professional: String?
    var propertyType: String?
    var rooms: Int?
}
