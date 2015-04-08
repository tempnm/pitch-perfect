//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Richard Hall on 06/04/2015.
//  Copyright (c) 2015 RH. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {

    var filePathURL: NSURL!
    var title: String!
    
    override init() {
    }

    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
}


