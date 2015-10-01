//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Aysin Kuran on 9/21/15.
//  Copyright © 2015 Aysin Kuran. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}

