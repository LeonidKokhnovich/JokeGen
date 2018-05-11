//
//  SearchJokeViewController.swift
//  JokeGen
//
//  Created by Leonid Kokhnovych on 2018-05-10.
//  Copyright © 2018 Leonid Kokhnovych. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class SearchJokeViewController: UIViewController {
    @IBOutlet weak var searchQueryTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    let viewModel = SearchJokeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.query <~ searchQueryTextField.reactive.continuousTextValues
        textView.reactive.text <~ viewModel.result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
