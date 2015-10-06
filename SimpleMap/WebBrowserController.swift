//
//  WebBrowserController.swift
//  SimpleMap
//
//  Created by Nick Chen on 10/5/15.
//  Copyright © 2015 Nick Chen. All rights reserved.
//

import UIKit

class WebBrowserController: UIViewController {

    @IBOutlet weak var browser: UIWebView!
    var url: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            let request = NSURLRequest(URL:url)
            browser.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
