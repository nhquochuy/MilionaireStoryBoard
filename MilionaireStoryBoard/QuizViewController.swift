//
//  QuizViewController.swift
//  MilionaireStoryBoard
//
//  Created by Quoc Huy on 7/5/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    deinit {
        print("QuizViewController Deinit")
    }
    
    // MARK: Variable
    let jsonString = """
[
  {
    "content": "1 + 1 = ?",
     "result": "A",
     "answers": [
                  {
                    "code": "A",
                    "content": "2"
                  },
                  {
                    "code": "B",
                    "content": "3"
                  },
                  {
                    "code": "C",
                    "content": "4"
                  },
                  {
                    "code": "D",
                    "content": "5"
                  }
                ]
  },
  {
    "content": "What is VietNam's capital city?",
     "result": "B",
     "answers": [
                  {
                    "code": "A",
                    "content": "Ho Chi Minh"
                  },
                  {
                    "code": "B",
                    "content": "Ha Noi"
                  },
                  {
                    "code": "C",
                    "content": "Da Nang"
                  },
                  {
                    "code": "D",
                    "content": "Hue"
                  }
                ]
  },
  {
    "content": "3 + 3 = ?",
     "result": "C",
     "answers": [
                  {
                    "code": "A",
                    "content": "9"
                  },
                  {
                    "code": "B",
                    "content": "12"
                  },
                  {
                    "code": "C",
                    "content": "6"
                  },
                  {
                    "code": "D",
                    "content": "15"
                  }
                ]
  },
  {
    "content": "How many seasons in a year?",
     "result": "D",
     "answers": [
                  {
                    "code": "A",
                    "content": "3 seasons"
                  },
                  {
                    "code": "B",
                    "content": "5 seasons"
                  },
                  {
                    "code": "C",
                    "content": "9 seasons"
                  },
                  {
                    "code": "D",
                    "content": "4 seasons"
                  }
                ]
  }
]
"""
    // Question List
    var questionList : Array<QuestionModel> = []
    // Current Question
    var currentQuestion : QuestionModel?
    // Total Question Count
    var totalQuestionCount : Int = 0
    // Right Anwser Count
    var rightAnwserCount : Int = 0
    // Timer
    var timer : Timer?
    
    // MARK: Outlet
    // Content View
    @IBOutlet weak var contentView: UIView!
    
    // Time
    @IBOutlet weak var timeLabel: UILabel!
    
    // Question
    @IBOutlet weak var questionLabelView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    // Answer Button
    @IBOutlet weak var answerAButton: UIButton!
    @IBOutlet weak var answerBButton: UIButton!
    @IBOutlet weak var answerCButton: UIButton!
    @IBOutlet weak var answerDButton: UIButton!
    
    // Result Icon Image
    @IBOutlet weak var resultIconImage: UIImageView!
    
    // MARK: Action
    @IBAction func anwserButtonClick(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        let buttonTag = button.tag
        guard let question = currentQuestion else { return }
        
        var isCorrect = false
        let result = question.result
        if (buttonTag == 1 && result == "A") || (buttonTag == 2 && result == "B")
            || (buttonTag == 3 && result == "C") || (buttonTag == 4 && result == "D") {
            isCorrect = true
            rightAnwserCount += 1
        }
        
        // Stop Timer
        self.stopTimer()
        
        // Disable Answer Button
        self.isEnableButton(isEnable: false)
        
        // Show Result Icon When User CLick Answer Button
        self.showResultIcon(isCorrect: isCorrect)
    }
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Layout
        self.setupLayOut()
        
        // Parsing Data
        self.parsingJsonData(jsonString: jsonString)
        
        // Set Data For Control
        self.setUpQuestion()
    }
    
    // MARK: Function
    // Setup Layout
    func setupLayOut() {
        // Time Label
        self.timeLabel.clipsToBounds = true
        self.timeLabel.layer.cornerRadius = timeLabel.frame.width/2
        
        // Question Label View
        self.questionLabelView.layer.borderWidth = 1
        self.questionLabelView.layer.borderColor = #colorLiteral(red: 1, green: 0.953854382, blue: 0.8467800021, alpha: 1)
        self.questionLabelView.layer.cornerRadius = questionLabelView.frame.height/2
        
        // Answer Button
        self.answerAButton.layer.cornerRadius = answerAButton.frame.height/2
        self.answerBButton.layer.cornerRadius = answerBButton.frame.height/2
        self.answerCButton.layer.cornerRadius = answerCButton.frame.height/2
        self.answerDButton.layer.cornerRadius = answerDButton.frame.height/2
    }
    
    // Parsing Json Data
    func parsingJsonData(jsonString : String) {
        guard let jsonData = jsonString.data(using: .utf8) else {return}
        
        do{
            guard let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String : Any]] else { return }
            
            jsonObjects.forEach { (object) in
                self.questionList.append(QuestionModel(json: object))
            }
            
            self.totalQuestionCount = self.questionList.count
        } catch let error {
            print("Can not parsing Json:", error)
        }
    }
    
    // Set Data For Control
    func setUpQuestion() {
        // Fill Data To Control
        if self.questionList.count > 0 {
            self.currentQuestion = questionList.randomElement()
            
            guard let question = currentQuestion else { return }
            self.questionList = self.questionList.filter({ (questionItem) -> Bool in
                return questionItem.content != question.content
            })
            
            // set up for TIme Label
            setUpQuestionForTimeLabel()
            // set up for Question Label
            setUpQuestionForQuestionLabel()
            // set up for Answer Button
            setUpQuestionForAnswerButton()
        } else {
            pushResultView()
        }
    }
    
    // Push Resel View
    func pushResultView() {
        guard let resultViewController = self.storyboard?.instantiateViewController(identifier: "resultview") as? ResultViewController else { return }
        let resultRating = self.getResultRatingByScore(scoreRate: Float(rightAnwserCount) / Float(totalQuestionCount))
        resultViewController.resultModel = ResultModel.init(totalQuestion: totalQuestionCount, rightAnswerCount: rightAnwserCount, resultRating: resultRating)
        
        UIView.animate(withDuration: 1, animations: { [weak self] () in
            guard let this = self else { return }
            this.contentView.transform = .init(scaleX: 10, y: 10)
        }) { [weak self] (isComplete) in
            guard let this = self else { return }
            this.navigationController?.pushViewController(resultViewController, animated: false)
        }
    }
    
    // Set Result Rating By Score
    func getResultRatingByScore(scoreRate : Float) -> ResultRating {
        switch scoreRate {
        case let x where x < 0.1:
            return .Poor
        case let x where 0.1 <= x && x < 0.5:
            return .Fair
        case let x where 0.5 <= x && x < 0.6:
            return .Good
        case let x where 0.6 <= x && x < 0.9:
            return .VeryGood
        default:
            return .Excellent
        }
    }
    
    // Show Result Image
    func showResultIcon(isCorrect : Bool) {
        self.resultIconImage.alpha = 1
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] () in
            guard let this = self else { return }
            this.resultIconImage.image = isCorrect ? UIImage(named: "right-answer-icon") : UIImage(named: "wrong-answer-icon")
            this.resultIconImage.transform = .init(scaleX: 0.6, y: 0.6)
        }) { [weak self] (isComplete) in
            guard let this = self else { return }
            this.isEnableButton(isEnable: true)
            this.resultIconImage.alpha = 0
            this.resultIconImage.transform = .identity
            this.setUpQuestion()
        }
    }
    
    // Dis/Enable Button
    func isEnableButton(isEnable : Bool) {
        [self.answerAButton, self.answerBButton, self.answerCButton, self.answerDButton].forEach { (button) in
            button.isEnabled = isEnable
        }
    }
    
    // Set Up Question For Time Label
    func setUpQuestionForTimeLabel() {
        self.timeLabel.text = "10"
        //guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(selectorSetUpQuestionForTimeLabel(sender:)), userInfo: nil, repeats: true)
    }
    
    @objc private func selectorSetUpQuestionForTimeLabel(sender : Timer) {
        var timeLabelValue = Int(self.timeLabel.text ?? "10")!
        let timer = Int(sender.timeInterval)
        
        timeLabelValue -= timer
        
        self.timeLabel.text = String(format: "%02d", timeLabelValue)
        
        if timeLabelValue == 0 {
            // Stop Timer
            self.stopTimer()
            
            // Disable Buton
            self.isEnableButton(isEnable: false)
            
            // Show Result Icon When User CLick Answer Button
            self.showResultIcon(isCorrect: false)
        }
    }
    
    // Stop Timer
    func stopTimer() {
        guard let timer = self.timer else { return }
        
        timer.invalidate()
    }
    
    // Set Up Question For Question Label
    func setUpQuestionForQuestionLabel() {
        guard let question = currentQuestion else { return }
        
        self.questionLabel.text = String(self.totalQuestionCount - self.questionList.count) + ". " + question.content
    }
    
    // Set Up Question For Answer Button
    func setUpQuestionForAnswerButton() {
        guard let question = currentQuestion else { return }
        
        self.answerAButton.setTitle(question.answersList[0].code + ". " + question.answersList[0].content, for: .normal)
        self.answerBButton.setTitle(question.answersList[1].code + ". " + question.answersList[1].content, for: .normal)
        self.answerCButton.setTitle(question.answersList[2].code + ". " + question.answersList[2].content, for: .normal)
        self.answerDButton.setTitle(question.answersList[3].code + ". " + question.answersList[3].content, for: .normal)
    }
}
