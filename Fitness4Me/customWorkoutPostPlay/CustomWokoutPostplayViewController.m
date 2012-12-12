//
//  CustomWokoutPostplayViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//

#import "CustomWokoutPostplayViewController.h"
#import "CustomWorkoutsViewController.h"
#import "ShareFitness4MeViewController.h"
#import "MemberPromoViewController.h"
@interface CustomWokoutPostplayViewController ()

@end

@implementation CustomWokoutPostplayViewController
@synthesize workout;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[Fitness4MeUtils getBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(M_PI_2));

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickDoAnotherWokout:(id)sender {
    CustomWorkoutsViewController *viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onClickCOntinue:(id)sender {
    
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    NSString *hasMadeFullPurchase= [userinfo valueForKey:@"hasMadeFullPurchase"];
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
              
        ShareFitness4MeViewController *viewController;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController" bundle:nil];
            
        }
        else {
            viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController_iPad" bundle:nil];
        }
        
        //NSLog(<#id, ...#>)
        
        viewController.imageUrl =[self.workout ImageUrl];
        viewController.imageName =[self.workout ImageName];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        MemberPromoViewController *viewController;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            viewController = [[MemberPromoViewController alloc]initWithNibName:@"MemberPromoViewController" bundle:nil];
            
        }
        else {
            viewController = [[MemberPromoViewController alloc]initWithNibName:@"MemberPromoViewController" bundle:nil];
        }
        
        
        viewController.workout =self.workout;
        [self.navigationController pushViewController:viewController animated:YES];

        
       
        
    }
    
    
}


-(void)showAdMobs{
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    
    NSString *hasMadeFullPurchase= [userinfo valueForKey:@"hasMadeFullPurchase"];
    
    
    if ([hasMadeFullPurchase isEqualToString:@"true"]) {
        
    }
    
    else {
        
        // [self performSelector:@selector(showUpgradeView) withObject:nil afterDelay:2];
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,self.view.frame.size.width-40,
                                                    self.view.frame.size.height-10,
                                                    self.view.frame.size.width)];
            
        }
        else {
            bannerView_ = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0,self.view.frame.size.width-70,
                                                    self.view.frame.size.height-10,
                                                    90)];
            
        }
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a1506940e575b91";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
        
    }
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
