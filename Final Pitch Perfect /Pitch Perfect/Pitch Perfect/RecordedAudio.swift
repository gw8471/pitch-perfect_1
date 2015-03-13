//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Gary Wang on 3/6/15.
//  Copyright (c) 2015 self. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    //constructor
    init(filePathUrl: NSURL!, title: String!)
    {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
