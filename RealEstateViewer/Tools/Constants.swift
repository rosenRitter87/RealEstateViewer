//
//  Constants.swift
//  RealEstateViewer
//
//  Created by Hamza Nejjar on 17/04/2021.
//

import Foundation

let kBaseUrl = "https://gsl-apps-technical-test.dignp.com"

//Webservices errors
enum ServicesErrors: Error {
    case invalidURL, dataNotFound
}

//Webservices call states
enum WebserviceStatus {
    case none, loading, failed, success
}
