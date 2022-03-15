//
//  ViewController.swift
//  UpDownGame
//
//  Created by 김민재 on 2022/03/14.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlet Var
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var tryCountLabel: UILabel!
    @IBOutlet weak var minimumValueLabel: UILabel!
    @IBOutlet weak var maximumValueLabel: UILabel!
    
    var randomValue = 0
    var tryCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .highlighted)
        reset()
    }
    
    @IBAction func touchUpResetButton(_ sender: UIButton) {
        reset()
        print("touched reset button")
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        sliderValueLabel.text = Int(sender.value).description
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.reset()
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func touchUpHitButton(_ sender: UIButton) {
        tryCount = tryCount + 1
        tryCountLabel.text = "\(tryCount) / 5"
        
        if Int(slider.value) == randomValue {
            showAlert(message: "You Win!!")
            reset()
            return
        } else if tryCount >= 5 {
            showAlert(message: "You lose....")
            reset()
            return
        } else if Int(slider.value) < randomValue {
            slider.minimumValue = slider.value
            minimumValueLabel.text = Int(slider.value).description
        } else {
            slider.maximumValue = slider.value
            maximumValueLabel.text = Int(slider.value).description
        }
    }
    
    func reset() {
        randomValue = Int.random(in: 0...30)
        print(randomValue)
        
        tryCount = 0
        slider.minimumValue = 0
        slider.maximumValue = 30
        maximumValueLabel.text = 30.description
        minimumValueLabel.text = 0.description
        slider.value = 15
        tryCountLabel.text = "\(tryCount) / 5"
        sliderValueLabel.text = Int(slider.value).description
    }
}

