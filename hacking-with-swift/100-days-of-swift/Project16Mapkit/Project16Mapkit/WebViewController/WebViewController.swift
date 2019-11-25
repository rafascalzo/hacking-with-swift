//
//  WebViewController.swift
//  Project16Mapkit
//
//  Created by rafaeldelegate on 11/24/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    var path: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://en.wikipedia.org/wiki")?.appendingPathComponent(path ?? "London") else { return }
        webView.load(URLRequest(url: url))
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
