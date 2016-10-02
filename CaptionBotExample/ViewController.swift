//
//  ViewController.swift
//  CaptionBotExample
//
//  Created by Noel Portugal on 10/2/16.
//  Copyright © 2016 theiotlabs. All rights reserved.
//

import UIKit
import CaptionBot

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionBot(url: "https://www.captionbot.ai/images/6.jpg"){ caption, error in
            if let caption = caption{
                print("Caption: \(caption)")
            }else{
                print("Error: \(error)")
            }
        }
        
        // Caption: I think it's a young man jumping in the air on a skateboard.
        
        let image = UIImage(named: "dog")!
        captionBot(image: image){ caption, error in
            if let caption = caption{
                print("Caption: \(caption)")
            }else{
                print("Error: \(error)")
            }
        }
        
        // Caption: I think it's a brown dog with its mouth open.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

