//
//  MembershipStayFitViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 03/01/13.
//
//

#import "MembershipStayFitViewController.h"
#import "MembershipPersonliazedViewController.h"

@interface MembershipStayFitViewController ()

@end

@implementation MembershipStayFitViewController

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
    [self.showMoreButton.titleLabel setNumberOfLines:3];
    self.showMoreButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.showMoreButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickNotYet:(id)sender {
    if ([self.navigateTo isEqualToString:@"List"]) {
        NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
        self.workoutType =[userinfo stringForKey:@"workoutType"];
        
       
            if ([self.workoutType isEqualToString:@"QuickWorkouts"]) {
                ListWorkoutsViewController *viewController;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                    viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController" bundle:nil];
                }else {
                    viewController =[[ListWorkoutsViewController alloc]initWithNibName:@"ListWorkoutsViewController_iPad" bundle:nil];
                }
                [self.navigationController pushViewController:viewController animated:YES];
                
                

        }
        
        
        else{
            CustomWorkoutsViewController *viewController;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
            }else {
                viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController_iPad" bundle:nil];
            }
            [viewController setWorkoutType:self.workoutType];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
    else
    {
        ShareFitness4MeViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController" bundle:nil];
        }
        else {
            viewController = [[ShareFitness4MeViewController alloc]initWithNibName:@"ShareFitness4MeViewController_iPad" bundle:nil];
        }
        viewController.workoutType=self.workoutType;
        viewController.imageUrl =[self.workout ImageUrl];
        viewController.imageName =[self.workout ImageName];
        [self.navigationController pushViewController:viewController animated:YES];
    }

}

- (IBAction)onClickShowYouTube:(id)sender {
}

- (IBAction)onClickTellMeMore:(id)sender {
    MembershipPersonliazedViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        viewController = [[MembershipPersonliazedViewController alloc]initWithNibName:@"MembershipPersonliazedViewController" bundle:nil];
        
    }
    else {
        viewController = [[MembershipPersonliazedViewController alloc]initWithNibName:@"MembershipPersonliazedViewController_iPad" bundle:nil];
    }
    [viewController setNavigateTo:[self navigateTo]];
    viewController.workout =self.workout;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (IBAction)showVideoButton:(id)sender {
}

- (IBAction)onClickSkipToPurchase:(id)sender {
    MembershipPurchaseViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        viewController = [[MembershipPurchaseViewController alloc]initWithNibName:@"MembershipPurchaseViewController" bundle:nil];
        
    }
    else {
        viewController = [[MembershipPurchaseViewController alloc]initWithNibName:@"MembershipPurchaseViewController_iPad" bundle:nil];
    }
    [viewController setNavigateTo:[self navigateTo]];
    viewController.workout =self.workout;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
@end
