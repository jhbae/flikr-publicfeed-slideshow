//
//  ViewController.swift
//  FlikrSlideShow
//
//  Created by luke.bae on 2016. 9. 21..
//  Copyright © 2016년 Luke Bae. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage
import AlamofireRSSParser
import BoltsSwift


class ViewController: UIViewController {

    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var feedImgView: UIImageView!
    @IBOutlet weak var termSlider: UISlider!
    @IBOutlet weak var toggleStartBtn: UIButton!

    private var isStoped = true

    lazy private var slideShowViewModel: SlideShowViewModel = SlideShowViewModel(stopFunc:self.stopSlideShow, startFunc:self.startSlideShow, updateImageView: self.updateImage)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.secondsLabel.text = "1";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func secondValueChanged(sender: UISlider) {

        sender.setValue(round(sender.value), animated:false);

        self.secondsLabel.text = String(Int(sender.value));
    }

    @IBAction func btnClicked(sender: UIButton) {
        if self.isStoped {
            startSlideShow()
        } else {
            stopSlideShow()
        }
    }

    func startSlideShow() {
        self.slideShowViewModel.startLoading()

        self.toggleStartBtn.setTitle("멈춤", forState: .Normal)
        self.termSlider.enabled = false

        self.isStoped = false

        return
    }

    func stopSlideShow() {
        self.slideShowViewModel.stopLoading()

        self.toggleStartBtn.setTitle("시작", forState: .Normal)
        self.termSlider.enabled = true

        self.isStoped = true
    }

    func updateImage(urlString:String) {

        if self.isStoped == false {
            let url = NSURL(string: urlString)

            self.feedImgView.af_setImageWithURL(url!,
                                                placeholderImage: nil,
                                                runImageTransitionIfCached: true,
                                                imageTransition: .CrossDissolve(0.4),
                                                completion:
                {
                    (response:Response<UIImage, NSError>) in

                    let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,
                        Int64(Double(self.termSlider.value) * Double(NSEC_PER_SEC)))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        // your function here
                        self.slideShowViewModel.doSlideShow()
                    })
                }
            )
        }
    }
    
}

