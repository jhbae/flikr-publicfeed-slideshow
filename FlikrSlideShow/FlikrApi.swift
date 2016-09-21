//
//  FlikrApi.swift
//  FlikrSlideShow
//
//  Created by luke.bae on 2016. 9. 21..
//  Copyright © 2016년 Luke Bae. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireRSSParser


class FlikerApi {

    static let sharedInstance = FlikerApi()


    func getPublicPhotos(parameters: [String: AnyObject], completionHandler: (Response<RSSFeed, NSError>) -> (Void)) {

        Alamofire.request(.GET, "https://api.flickr.com/services/feeds/photos_public.gne", parameters:parameters)
            .responseRSS(completionHandler)
    }
}
