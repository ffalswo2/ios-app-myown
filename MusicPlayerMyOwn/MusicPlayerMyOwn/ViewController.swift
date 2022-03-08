//
//  ViewController.swift
//  MusicPlayerMyOwn
//
//  Created by 김민재 on 2022/03/06.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    // MARK: Custom Var
    var musicPlayer: AVAudioPlayer!
    var timer: Timer!
    
    // MARK: IBOutlet Var
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    // MARK: IBOutlet Action
    @IBAction func touchPlayPauseButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.musicPlayer.play()
            self.makeAndFireTimer()
        } else {
            self.musicPlayer.pause()
            self.invalidateTimer()
        }
        
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.musicPlayer.currentTime = TimeInterval(sender.value)
        
    }
    
    // MARK: Custom Methods
    func initMusicPlayer() {
        guard let soundAssest: NSDataAsset = NSDataAsset(name: "sound") else {
            print("음원 파일을 찾을 수 없습니다")
            return
        }
        
        do {
            try self.musicPlayer = AVAudioPlayer(data: soundAssest.data)
            self.musicPlayer.delegate = self
        } catch {
            print("no musicPlayer found : \(error.localizedDescription)")
        }
        
        self.timeSlider.minimumValue = 0
        self.timeSlider.maximumValue = Float(self.musicPlayer.duration)
        self.timeSlider.value = Float(self.musicPlayer.currentTime)
        
    }
    
    func updateTimeLabelText(time: TimeInterval) {
        let minute: Int = Int(time/60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond :Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute,second,milisecond)
        
        self.timeLabel.text = timeText
    }
    
    func makeAndFireTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            
            if self.timeSlider.isTracking { return }
            
            self.updateTimeLabelText(time: self.musicPlayer.currentTime)
            self.timeSlider.value = Float(self.musicPlayer.currentTime)
        })
        self.timer.fire()
    }
    
    func invalidateTimer() {
        self.timer.invalidate()
        self.timer = nil
    }
    
    
    //MARK: VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMusicPlayer()
    }


}



extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.isSelected = false
        self.updateTimeLabelText(time: 0)
        self.timeSlider.value = 0
        self.invalidateTimer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error: Error = error else {
            print("오디오 플레이어 디ㅣ코드 오류 발생")
            return
        }
        
        let message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
