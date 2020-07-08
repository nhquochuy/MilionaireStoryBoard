//
//  QuizModel.swift
//  MilionaireStoryBoard
//
//  Created by Quoc Huy on 7/8/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation

struct AnswerModel {
    let code: String
    let content: String
    
    init(json: [String : Any]) {
        code = json["code"] as? String ?? ""
        content = json["content"] as? String ?? ""
    }
}
