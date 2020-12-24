//
//  LinkCell.swift
//  ChatChat
//
//  Created by Mohammad Ashraful Islam Sadi on 11/7/20.
//  Copyright © 2020 Wheels-Corporation. All rights reserved.
//

import UIKit


class LinkCell: BaseCell {
    
    @IBOutlet var messageTitle: UILabel!
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var imageUrl: NSURL!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bubbleView.layer.cornerRadius = 16
        self.bubbleView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func openlink(_ sender: Any?) {

        if (link != nil) {
            let url = URL(string: link!)
            if url?.scheme == "xmpp" {
                //let delegate = UIApplication.shared.delegate as? MonalAppDelegate
//                delegate?.handle(url)
            } else if (url?.scheme == "http") || (url?.scheme == "https") {
                //var safariView: SFSafariViewController? = nil
                if let url = url {
                    //safariView = SFSafariViewController(url: url)
                }
//                if let safariView = safariView {
//                    parent.present(safariView, animated: true)
//                }
            }
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(openlink(_:)) {
            if (link != nil) {
                return true
            }
        }
        return action == #selector(copy(_:))
    }

    override func copy(_ sender: Any?) {
        let pboard = UIPasteboard.general
        pboard.string = link
    }
    
    func loadPreview(withCompletion completion: @escaping () -> Void) {
    messageTitle.text = nil
        imageUrl = URL(string: "") as NSURL?

        if (link != nil) {
        var request: NSMutableURLRequest? = nil
            if let url = URL(string: link!) {
            request = NSMutableURLRequest(url: url)
        }
        request?.setValue("facebookexternalhit/1.1", forHTTPHeaderField: "User-Agent") //required on somesites for og tages e.g. youtube
        if let request = request {
            
            
            
            
            //URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

//                var body: String? = nil
//                if let data = data {
//                    body = String(data: data, encoding: .utf8)
//                }
//
//                DispatchQueue.main.async(execute: {
//                    self.messageTitle.text = MLMetaInfo.ogContent(withTag: "og:title", inHTML: body)
//                    self.imageUrl = URL(string: MLMetaInfo.ogContent(withTag: "og:image", inHTML: body).removingPercentEncoding ?? "")
//                    if imageUrl {
//                        loadImage(withCompletion: {
//                            if completion {
//                                completion()
//                            }
//                        })
//                    }
//                })
//                }).resume()
            }
        }
    }
    
    func loadImage(withCompletion completion: @escaping () -> Void) {
        if (imageUrl != nil) {
            //previewImage?.sd_setImage(withURL: imageUrl, completed: { image, error, cacheType, imageURL in
//                if error != nil {
//                    self.previewImage?.image = nil
//                }

                if completion != nil {
                    completion()
                }
        } else if completion != nil {
            completion()
        }
    }
}
