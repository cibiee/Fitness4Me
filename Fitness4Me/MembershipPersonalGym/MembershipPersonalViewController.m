//
//  MembershipPersonalViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 03/01/13.
//
//

#import "MembershipPersonalViewController.h"
#import "MemverRateViewController.h"

@interface MembershipPersonalViewController ()

@end

@implementation MembershipPersonalViewController

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
                //viewController =[[HintsViewController alloc]initWithNibName:@"CustomizedWorkoutListViewController_iPad" bundle:nil];
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
    MemverRateViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        viewController = [[MemverRateViewController alloc]initWithNibName:@"MemverRateViewController" bundle:nil];
        
    }
    else {
        viewController = [[MemverRateViewController alloc]initWithNibName:@"MemverRateViewController" bundle:nil];
    }
    [viewController setNavigateTo:[self navigateTo]];
    viewController.workout =self.workout;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
