//
//  DetailViewController.swift
//  Project7
//
//  Created by rafaeldelegate on 10/19/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        let html = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style> body { font-size: 150%; } </style>
            <style> header { font-size: 250%; color: blue; } </style>
            </head>
            <header>
        \(detailItem.title)
            </header>
            <body>
        \(detailItem.body)
            </body>
            </html>
"""
        webView.loadHTMLString(html, baseURL: nil)
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
