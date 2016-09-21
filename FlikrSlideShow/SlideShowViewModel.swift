//
//  SlideShowViewModel.swift
//  FlikrSlideShow
//
//  Created by luke.bae on 2016. 9. 21..
//  Copyright © 2016년 Luke Bae. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireImage
import AlamofireRSSParser


typealias StopSlide = (Void) -> Void
typealias StartSlide = (Void) -> Void
typealias UpdateImage = (String) -> Void


private let MAX_FEED_LIMIT = 50
private let MIN_FEED_LEFT_LIMIT = 5

class SlideShowViewModel {

    var updateImage: UpdateImage

    private var stopped: Bool = true
    private var feeds: [RSSItem] = []
    private var curIndex = 0

    init (updateImageView:UpdateImage) {
        self.updateImage = updateImageView
    }


    func isStopped() -> Bool {
        return stopped
    }


    func stopLoading() {
        self.stopped = true
        self.curIndex = 0
        self.feeds = []
    }

    func startLoading() {
        self.stopped = false
        self.loadFeeds()
    }


    func doSlideShow() {
        if self.stopped == false
            && self.feeds.count - MIN_FEED_LEFT_LIMIT > self.curIndex {
            self.updateImage(self.feeds[self.curIndex].mediaContent!)
            self.increaseIndex()

        } else if self.stopped == false
            && self.feeds.count - MIN_FEED_LEFT_LIMIT <= self.curIndex {
            loadFeeds()
        }
    }

    private func increaseIndex() {
        self.curIndex += 1
    }

    private func loadFeeds() {

        let flkrRestClient = FlkrRestClient.sharedInstance

        flkrRestClient.getPublicPhotoFeeds(nil, ids:nil, tags:nil, tagMode:nil, format:nil, lang:nil)
            .continueOnSuccessWith{ result in

                if self.feeds.count + result.items.count > MAX_FEED_LIMIT {

                    if self.curIndex >= result.items.count {
                        self.curIndex -= result.items.count
                        self.feeds.removeFirst(result.items.count)
                    } else {
                        self.feeds.removeAll()
                        self.curIndex = 0
                    }
                }

                self.feeds.appendContentsOf(result.items)
                self.doSlideShow()

            }.continueOnErrorWith { (error:NSError) in
                print("\(error)")
        }
    }
}