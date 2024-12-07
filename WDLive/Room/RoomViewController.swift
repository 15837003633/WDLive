//
//  RoomViewController.swift
//  WDLive
//
//  Created by scott on 2024/12/7.
//

import UIKit

class RoomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RoomViewController {
     @IBAction func onBackButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBottomButtonClick(_ sender: Any) {
        let button = sender as! UIButton
        switch button.tag {
        case 0:
            MusicRequest().request { songList in
                print(songList ?? "error")
            }
            break
        case 1:
            break
        case 2:
            break
        case 3:
            button.isSelected = !button.isSelected
            if button.isSelected {
                startEmitter()
            }else{
                stopEmitter()
            }
            break
        default:
            break
        }
   }
}

extension RoomViewController: EmitterEnableProtocol{
    
}
