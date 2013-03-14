//
//  FitnessDemoViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 04/03/13.
//
//

#import "FitnessDemoViewController.h"

@interface FitnessDemoViewController ()

@end

@implementation FitnessDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(M_PI_2));
      moviePlayer.view.backgroundColor =[UIColor  whiteColor];
    [self showAdMobs];
    [self initializPlayer];
    
}

    // Do any additional setup after loading the view from its nib.


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)showAdMobs
{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *hasMadeFullPurchase= [userinfo valueForKey:@"hasMadeFullPurchase"];
    [userinfo setObject:@"false" forKey:@"shouldExit"];
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
        
    }
    else {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,-7,
                                                    self.view.frame.size.width-70,
                                                    50)];
            
        }
        else {
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,0,
                                                    self.view.frame.size.height-70,
                                                    90)];
            
        }
        
        bannerView_.adUnitID = @"a150efb4cbe1a0a";
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
    }
}


-(void)initializPlayer
{
    NSString*thePath=[[NSString alloc]init];
    thePath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"fitness4me-intro-small.mp4"];
    
    
    
            moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:thePath]];
           // moviePlayer.contentURL =theurl;
           // [moviePlayer play];
    [moviePlayer prepareToPlay];
    [moviePlayer setShouldAutoplay:YES];
            moviePlayer.controlStyle = MPMovieControlStyleNone;
            moviePlayer.view .frame= subview.bounds;
            [subview addSubview: moviePlayer.view];
   
            
         moviePlayer.controlStyle = MPMovieControlStyleNone;
        //Register to receive a notification when the movie has finished playing.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps == 1){
        if(moviePlayer.controlStyle == MPMovieControlStyleEmbedded)
            moviePlayer.controlStyle = MPMovieControlStyleNone;
        else
            moviePlayer.controlStyle = MPMovieControlModeVolumeOnly;
    }
}





-(IBAction)onClickClose:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    moviePlayer = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    [self.navigationController popViewControllerAnimated:YES];

    
}



@end
