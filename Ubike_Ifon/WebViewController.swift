//
//  WebViewController.swift
//  Ubike_Ifon
//
//  Created by Adam on 2021/10/10.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://taipei.youbike.com.tw/station/2_map?_id=5e0d965bbae27166a62a1993")
        let request = URLRequest(url: url!)
        
        webView.load(request)
    }
}
