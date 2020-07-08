//
//  QuestionModel.swift
//  MilionaireStoryBoard
//
//  Created by Quoc Huy on 7/8/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation

struct QuestionModel {
    let content: String
    let result: String
    let answersList: [AnswerModel]
    
    init(json: [String : Any]) {
        self.content = json["content"] as? String ?? ""
        self.result = json["result"] as? String ?? ""
        
        var answer : [AnswerModel] = []
        if let answers = json["answers"] as? [[String : Any]] {
            answers.forEach { (item) in
                answer.append(AnswerModel(json: item))
            }
        }
        self.answersList = answer
    }
}
