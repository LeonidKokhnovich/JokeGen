//
//  ViewController.swift
//  JokeGen
//
//  Created by Leonid Kokhnovych on 2018-05-10.
//  Copyright © 2018 Leonid Kokhnovych. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        queryJokes()
    }
    
    func queryJokes() {
        let query = JokesDetailsQuery()
        apollo.fetch(query: query) { [weak self] (result, error) in
            guard error == nil else {
                print("Failed request with error: \(error?.localizedDescription)")
                return
            }
            
            guard let joke = result?.data?.joke else {
                print("No joke found: \(result.debugDescription)")
                return
            }
            
            print("Joke: \(joke)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

