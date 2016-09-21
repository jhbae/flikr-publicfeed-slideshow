//
//  FlikrRestClient.swift
//  FlikrSlideShow
//
//  Created by luke.bae on 2016. 9. 21..
//  Copyright © 2016년 Luke Bae. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireRSSParser
import BoltsSwift


public class FlkrRestClient {

    static let sharedInstance = FlkrRestClient()

    func getPublicPhotoFeeds(id: String?, ids: [String]?, tags: [String]?, tagMode: String?,
                             format: String?, lang: String?) -> Task<RSSFeed> {
        let tcs = TaskCompletionSource<RSSFeed>()
        let flkrApi = FlikerApi.sharedInstance;


        var parameters = [String: String]()

        if id?.characters.count > 0 {
            parameters["id"] = id!
        }

        if ids?.isEmpty == false {
            var idStrings = ""

            for each in ids! {
                idStrings += (each + ",")
            }

            parameters["ids"] = idStrings
        }

        if tags?.isEmpty == false {
            var idStrings = ""

            for each in tags! {
                idStrings += each
            }

            parameters["tags"] = idStrings
        }

        if tagMode?.characters.count > 0 && (tagMode?.uppercaseString == "any" || tagMode?.uppercaseString == "all") {
            parameters["tagmode"] = tagMode!
        }

        //In this example only support rss2 for convenience
        parameters["format"] = "rss2"
        //        //In this example remove extra charators from result for convenience
        //        parameters["nojsoncallback"] = "1"

        if lang?.characters.count > 0 {
            parameters["lang"] = lang!
        }

        flkrApi.getPublicPhotos(parameters, completionHandler: {(response: Response<RSSFeed, NSError>) in

            if response.result.isFailure, let error = response.result.error {
                tcs.set(error: error)
                return
            } else if let result = response.result.value {
                tcs.set(result: result)
            } else {
                tcs.cancel()
            }
        })
        
        return tcs.task
    }
}