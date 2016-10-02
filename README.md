[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# CaptionBot
A swift wrapper framework for Microsoft captionbot.ai

# Carthage
Add "github noelportugal/CaptionBot" to your Cartfile and run "carthage update"

# Usage
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
        
