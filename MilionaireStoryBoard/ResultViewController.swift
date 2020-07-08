//
//  ResultViewController.swift
//  MilionaireStoryBoard
//
//  Created by Quoc Huy on 7/8/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    deinit {
        print("ResultViewController Deinit")
    }
    
    // MARK: Variable
    var resultModel : ResultModel = .init(totalQuestion: 0, rightAnswerCount: 0, resultRating: .Poor)
    
    // MARK: OutLet
    @IBOutlet weak var gradeFaceImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    // MARK: Action
    @IBAction func playAgainButtonClick(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Overide
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Layout
        self.setUpLayout()
        
        // Set Data Control
        self.setDataToControl()
    }
    
    // MARK: Function
    // Set Up Layout
    func setUpLayout() {
        // Hide Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
        
        // Score Label
        self.scoreLabel.layer.borderWidth = 1
        self.scoreLabel.layer.borderColor = #colorLiteral(red: 0.003921568627, green: 0.337254902, blue: 0.4078431373, alpha: 1)
        self.scoreLabel.layer.cornerRadius = self.scoreLabel.frame.height / 2
        
        // Play Again Button
        self.playAgainButton.layer.cornerRadius = self.playAgainButton.frame.width / 2
    }
    
    // Set Data Control
    func setDataToControl() {
        switch resultModel.resultRating {
        case .Fair:
            self.gradeFaceImage.image = UIImage(named: "fair-face-icon")
            self.gradeLabel.text = "Fair"
        case .Poor:
            self.gradeFaceImage.image = UIImage(named: "poor-face-icon")
            self.gradeLabel.text = "Poor"
        case .Good:
            self.gradeFaceImage.image = UIImage(named: "good-face-icon")
            self.gradeLabel.text = "Good"
        case .VeryGood:
            self.gradeFaceImage.image = UIImage(named: "veryGood-face-icon")
            self.gradeLabel.text = "Very Good"
        default:
            self.gradeFaceImage.image = UIImage(named: "excellent-face-icon")
            self.gradeLabel.text = "Excellent"
        }
        
        self.scoreLabel.text = "Score: " + String(self.resultModel.rightAnswerCount) + "/" + String(self.resultModel.totalQuestionsCount)
    }

}
