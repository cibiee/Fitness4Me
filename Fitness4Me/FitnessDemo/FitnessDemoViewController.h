//
//  FitnessDemoViewController.h
//  Fitness4Me
//
//  Created by Ciby  on 04/03/13.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AVFoundation/AVFoundation.h"
#import "GADBannerView.h"


@interface FitnessDemoViewController : UIViewController{
IBOutlet UIView *subview;
    MPMoviePlayerController __strong *moviePlayer;
    GADBannerView *bannerView_;
}

-(IBAction)onClickClose:(id)sender;
@end
