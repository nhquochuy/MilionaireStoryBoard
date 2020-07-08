//
//  ViewController.swift
//  MilionaireStoryBoard
//
//  Created by Quoc Huy on 7/5/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    deinit {
          print("HomeViewController Deinit")
      }
    
    // MARK: Outlet
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: Action
    @IBAction func startButtonClick(_ sender: Any) {
        animateStartButtonAndPushQuizView()
    }

    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        setupLayout()
    }
    
    // MARK: Function
    // Setup Layout
    func setupLayout() {
        startButton.layer.cornerRadius = startButton.frame.width / 2
        startButton.clipsToBounds = true
    }
    
    // MARK: Animation
   func animateStartButtonAndPushQuizView() {
       UIView.animate(withDuration: 1, animations: { [weak self] in
           guard let this = self else { return }
           this.startButton.transform = .init(scaleX: 10, y: 10)
       }) { [weak self] (isCompletion) in
           guard let this = self else { return }
           this.pushQuizViewController()
           this.startButton.transform = .identity
       }
   }
    
    // MARK: Push View Controller
    func pushQuizViewController() {
        let quizView = self.storyboard?.instantiateViewController(identifier: "quizview") as! QuizViewController
        self.navigationController?.pushViewController(quizView, animated: false)
        quizView.navigationController?.isNavigationBarHidden = true
    }
    
   
}

