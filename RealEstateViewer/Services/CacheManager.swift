//
//  CacheManager.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 18/04/2021.
//

import Foundation

let kCachedRealEstates = "CachedRealEstates"
let kViewedRealEstates = "ViewedRealEstates"
let kCachedRealEstate = "CachedRealEstate"

class CacheManager {
    //Caching Real Estates
    class func cacheRealEstates(realEstates: [RealEstate]) {
        try? UserDefaults.standard.setCodable(object: realEstates, forKey: kCachedRealEstates)
    }
    
    //get cached Real Estates
    class func getCachedRealEstates() -> [RealEstate]? {
        return (try? UserDefaults.standard.getCodable(objectType: [RealEstate].self, forKey: kCachedRealEstates))
    }
    
    //set a Real Estate as viewed
    class func setRealEstateAsViewed(realEstate: RealEstate) {
        var cachedIDs = getViewedRealEstatesIDs()
        cachedIDs.insert(realEstate.id)
        UserDefaults.standard.set(Array(cachedIDs), forKey: kViewedRealEstates)
    }
    
    //check if a Real Estate has been viewed
    class func isRealEstateViewed(realEstate: RealEstate) -> Bool{
        return getViewedRealEstatesIDs().contains(realEstate.id)
    }
    
    //get all viewed Real Estates ids
    class func getViewedRealEstatesIDs() -> Set<Int> {
        return Set(UserDefaults.standard.object(forKey: kViewedRealEstates) as? [Int] ?? [Int]())
    }
    
    //Caching Real Estate
    class func cacheRealEstate(realEstate: RealEstate) {
        try? UserDefaults.standard.setCodable(object: realEstate, forKey: kCachedRealEstate + "\(realEstate.id)")
    }
    
    //get cached Real Estate
    class func getCachedRealEstate(id: Int) -> RealEstate? {
        return (try? UserDefaults.standard.getCodable(objectType: RealEstate.self, forKey: kCachedRealEstate + "\(id)"))
    }
}
