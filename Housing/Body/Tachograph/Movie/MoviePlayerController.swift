//
//  MoviePlayerController.swift
//  Tachograph
//
//  Created by Ethan on 16/7/11.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import MediaPlayer

class MoviePlayerController: UIViewController {
    
    var fileUrl : NSString?

    fileprivate var moviePlayerView : MPMoviePlayerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let str = fileUrl {
            NotificationCenter.default.addObserver(self, selector: #selector(MoviePlayerController.playingDone), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil)
            
            moviePlayerView = MPMoviePlayerViewController(contentURL:URL(fileURLWithPath: str as String))
            moviePlayerView.moviePlayer.controlStyle = .fullscreen
            moviePlayerView.moviePlayer.scalingMode = .aspectFill
            
            view.addSubview(moviePlayerView.view)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MoviePlayerController{
    
    @objc fileprivate func playingDone(){
        moviePlayerView.view.removeFromSuperview()
        moviePlayerView = nil
        if let naviController = self.navigationController?.popViewController(animated: false){
            naviController.viewWillAppear(true)
        }
    }
    
}
