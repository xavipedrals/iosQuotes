//
//  Network.swift
//  quotes
//
//  Created by mac33 on 5/2/16.
//  Copyright © 2016 mac33. All rights reserved.
//

import UIKit

class Network{

    var baseURL:NSURL
    
    init(baseURL:NSURL) {
        self.baseURL = baseURL
    }
    
    init(){
//        self.baseURL = NSURL(string: "http://quotes.rest/qod.json")!
        self.baseURL = NSURL(string: "https://iosquotes.herokuapp.com/api/quotes")!
    }
    
    func getQuoteOfTheDay(completionHandler:(quoteLogic:QuoteLogic?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: baseURL)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                if let jsonArray = self.parseJSONFromData(data!) {
                    if let quoteLogic = self.parseQuoteFromHerokuJSON(jsonArray) {
                        completionHandler(quoteLogic: quoteLogic)
                    }
                    else {
                        completionHandler(quoteLogic: nil)
                    }
                }
                else {
                    completionHandler(quoteLogic: nil)
                }
            } else {
                completionHandler(quoteLogic: nil)
            }
        })
        task.resume()
    }
    
    func parseJSONFromData(data:NSData) -> [String:AnyObject]? {
        var json = [String:AnyObject]()
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! [String:AnyObject]
            return json
        } catch {
            print(error)
            return nil
        }
    }
    
    func parseQuoteFromJSON(json:[String:AnyObject]) -> QuoteLogic? {
        if let contents = json["contents"] as? [String:AnyObject] {
            if let quoteObj = contents["quotes"]![0] as? [String:AnyObject] {
                if let quoteLogic = QuoteLogic(json: quoteObj) {
                    return quoteLogic
                }
            }
            
        }
        return nil
    }
    
    func parseQuoteFromHerokuJSON(json:[String:AnyObject]) -> QuoteLogic? {
        if let quoteLogic = QuoteLogic(json: json) {
            return quoteLogic
        }
        return nil
    }
    
    
    func downloadImageFromUrl(URL:NSURL) -> UIImage?{
        if let data = NSData(contentsOfURL: URL){
            return UIImage(data: data)!
        }
        return nil
    }
}