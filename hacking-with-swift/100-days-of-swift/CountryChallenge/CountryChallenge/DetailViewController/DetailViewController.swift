//
//  DetailViewController.swift
//  CountryChallenge
//
//  Created by rafaeldelegate on 11/24/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedCountry: Country?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameTextView: UITextView!
    @IBOutlet var capitalCityLabel: UILabel!
    @IBOutlet var capitalCityTextView: UITextView!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var sizeTextView: UITextView!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var populationTextView: UITextView!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyTextView: UITextView!
    @IBOutlet var largestCityLabel: UILabel!
    @IBOutlet var largestCityTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedCountry != nil {
            nameTextView.text = selectedCountry?.name
            capitalCityTextView.text = selectedCountry?.capitalCity
            populationTextView.text = "\(selectedCountry?.population ?? 0)"
            sizeTextView.text = "\(selectedCountry?.size ?? 0)"
            largestCityTextView.text = selectedCountry?.largestCity
        }
       
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
