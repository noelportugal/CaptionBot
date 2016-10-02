# CaptionBot
A swift wrapper framework for Microsoft captionbot.ai

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
        
