//
//  MembershipRateViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 11/12/12.
//
//

#import "MembershipRateViewController.h"
#import "MembershipPurchaseViewController.h"
@interface MembershipRateViewController ()

@end

@implementation MembershipRateViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickYes:(id)sender {
//    MembershipPurchaseViewController *viewController;
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
//        
//        viewController = [[MembershipPurchaseViewController alloc]initWithNibName:@"MembershipPurchaseViewController" bundle:nil];
//        
//    }
//    else {
//        viewController = [[MembershipPurchaseViewController alloc]initWithNibName:@"MembershipPurchaseViewController" bundle:nil];
//    }
//    
//    viewController.workout =self.workout;
//    viewController.navigateTo =[self navigateTo];
//    [self.navigationController pushViewController:viewController animated:YES];

}

- (IBAction)onClickNotYet:(id)sender {
    if ([self.navigateTo isEqualToString:@"List"]) {
        CustomWorkoutsViewController *viewController;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
        }else {
            //viewController =[[HintsViewController alloc]initWithNibName:@"CustomizedWorkoutListViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:viewController animated:YES];
        
        
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
        viewController.imageUrl =[self.workout ImageUrl];
        viewController.imageName =[self.workout ImageName];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
@end
