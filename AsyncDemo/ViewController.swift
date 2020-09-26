//
//  ViewController.swift
//  AsyncDemo
//
//  Created by Duncan Champney on 9/26/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func doAsyncStuff() {
        //Run a loop on the main thread
        for callCount in 1...5 {
            
            //#1 inside loop, about to call asyncFunc
            print("About to call asyncFunc. callCount = \(callCount)")
            
            asyncFunc(callCount: callCount) { result in
                //MARK: - This is the completion handler
                //#2 In completion handler after async function finishes
                print("In completion handler. Result = \(result). callCount = \(callCount)")
                //MARK: - End of completion handler
            }
        }
    }
    
    func asyncFunc(callCount: Int, completion: @escaping (Bool) -> ()) {
        //#3 Entering asyncFunc
        print("  Entering \(#function). callCount = \(callCount)")

        //#4 Pick a random delay value from 0.01 to 0.2
        let delay = Double.random(in: 0.01...0.2)
        print(String(format: "    About to call asyncAfter with delay %.2f", delay))

        //#5 asyncAfter() call
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            //MARK: - This is the closure code that is run after a delay
            completion(Bool.random())
            //MARK: - End of closure code
        }

        //#6 Leaving asyncFunc
        print("  Leaving \(#function). callCount = \(callCount)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doAsyncStuff()
    }
}

