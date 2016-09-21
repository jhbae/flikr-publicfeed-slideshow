//
//  FeedJSONData.swift
//  FlikrSlideShow
//
//  Created by luke.bae on 2016. 9. 21..
//  Copyright © 2016년 Luke Bae. All rights reserved.
//

import Foundation

import EasyMapping


public enum TagMode: String {
    case all  = "all"
    case any = "any"
}

public enum Format: String {
    case json = "json"
}

public enum LanguageCode: String {
    case de = "de-de"
    case en = "en-us"
    case fr = "fr-fr"
    case it = "it-it"
    case ko = "ko-kr"
    case pt = "pt-br"
    case zh = "zh-hk"
}

public class FlkrFeed: EKObjectModel {
    var items: [FlkrItem]!
}


public class FlkrItem: EKObjectModel {
    var title: String!
    var link: String?
    var media: FlkrMedia!
    var dateTaken: NSDate?
    var published: NSDate?
    var author: String?
    var authorId: String!
    //    var tags: [String]?
}


public class FlkrMedia: EKObjectModel {
    var m: String!
}


extension FlkrItem {
    override public class func objectMapping() -> EKObjectMapping{
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapPropertiesFromArray(["title","link", "media", "author"])
        mapping.mapPropertiesFromUnderscoreToCamelCase(["author_id"])

        mapping.mapKeyPath("date_taken", toProperty: "dateTaken", withValueBlock: { result in

            let value = result.1 as! String

            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss xxx"

            let dateFromString = dateFormatter.dateFromString(value)

            return dateFromString
        })

        //        mapping.mapKeyPath("published", toProperty: "published", withValueBlock: { result in
        //
        //            let value = result.1 as! String
        //
        //            let dateFormatter: NSDateFormatter = NSDateFormatter()
        //            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //
        //            let dateFromString = dateFormatter.dateFromString(value)
        //
        //            return dateFromString
        //        })

        mapping.hasOne(FlkrMedia.self, forKeyPath: "media")
        return mapping
    }
}

extension FlkrMedia {
    override public class func objectMapping() -> EKObjectMapping {
        let mapping = EKObjectMapping(objectClass: self)
        mapping.mapPropertiesFromArray(["m"])
        return mapping
    }
}

extension FlkrFeed{
    override public class func objectMapping() -> EKObjectMapping {
        let mapping = EKObjectMapping(objectClass: self)
        mapping.hasMany(FlkrItem.self, forKeyPath: "items")
        return mapping
    }
}