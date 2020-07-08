//
//  ResultModel.swift
//  MilionaireStoryBoard
//
//  Created by Quoc Huy on 7/8/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation

enum ResultRating {
    case Poor, Fair, Good, VeryGood, Excellent
}

struct ResultModel {
    let totalQuestionsCount : Int
    let rightAnswerCount : Int
    let resultRating : ResultRating
    
    init(totalQuestion : Int, rightAnswerCount : Int, resultRating : ResultRating) {
        self.totalQuestionsCount = totalQuestion
        self.rightAnswerCount = rightAnswerCount
        self.resultRating = resultRating
    }
}
