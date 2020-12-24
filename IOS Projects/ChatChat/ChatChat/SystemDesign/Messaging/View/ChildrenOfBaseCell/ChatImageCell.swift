//
//  ChatImageCell.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 11/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit

class ChatImageCell: BaseCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    //@IBOutlet weak var spinner: UIActivityIndicatorView!
    //@IBOutlet weak var imageHeight: NSLayoutConstraint!
    var loading = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.thumbnailImage.layer.cornerRadius = 15
        self.thumbnailImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(withCompletion completion: @escaping () -> Void) {
        if (link != nil) && thumbnailImage.image == nil && !loading {
            //spinner.startAnimating()
            loading = true
            let currentLink = link
            MLImageManager.sharedInstance().image(forAttachmentLink: link!, withCompletion: { data in
                DispatchQueue.main.async(execute: {
                    if currentLink == self.link {
                        if data == nil {
                            self.thumbnailImage.image = nil
                        } else if !(self.thumbnailImage.image != nil) {
                            var image: UIImage? = nil
                            if let data = data {
                                image = UIImage(data: data)
                            }
                            self.thumbnailImage.image = image
                            if (image?.size.height ?? 0.0) > (image?.size.width ?? 0.0) {
                                //self.imageHeight.constant = 360
                            }
                        }
                        self.loading = false
                        //self.spinner.stopAnimating()
                        if completion != nil {
                            completion()
                        }
                    }

                })
            })
        } else {
        }
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }

    override func copy(_ sender: Any?) {
        let pboard = UIPasteboard.general
        pboard.image = thumbnailImage.image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //imageHeight.constant = 200
        //spinner.stopAnimating()
    }

}
