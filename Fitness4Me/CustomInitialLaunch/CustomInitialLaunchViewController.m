//
//  CustomInitialLaunchViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 15/01/13.
//
//

#import "CustomInitialLaunchViewController.h"
#import "CustomWorkoutsViewController.h"
#import "FocusViewController.h"

@interface CustomInitialLaunchViewController ()

@end

@implementation CustomInitialLaunchViewController

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
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, 58, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_btn_with_text.png"] forState:UIControlStateNormal];
    [nextButton setTitle:NSLocalizedStringWithDefaultValue(@"next", nil,[Fitness4MeUtils getBundle], nil, nil) forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [nextButton.titleLabel setTextAlignment:UITextAlignmentRight];
    [nextButton addTarget:self action:@selector(onClickNext:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    self.navigationBar.rightBarButtonItem = nextBtn;


}

-(IBAction)onClickNext:(id)sender
{
    
    CustomWorkoutsViewController *viewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        viewController =[[CustomWorkoutsViewController alloc]initWithNibName:@"CustomWorkoutsViewController" bundle:nil];
    }else {
        //viewController =[[HintsViewController alloc]initWithNibName:@"CustomizedWorkoutListViewController_iPad" bundle:nil];
    }
     NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    [userinfo setObject:@"SelfMade" forKey:@"workoutType"];
    [userinfo setObject:@"" forKey:@"SelectedWorkouts"];
    [viewController setWorkoutType:@"SelfMade"];
    GlobalArray=nil;
    GlobalArray=[[NSMutableArray alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickDontShow:(id)sender {
    NSUserDefaults *userinfo =[NSUserDefaults standardUserDefaults];
    self.checkboxSelected = !self.checkboxSelected;
    if (self.checkboxSelected == NO)
    {
        [userinfo setObject:@"false" forKey:@"DontShow"];
        [self.dontShowButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    else
    {
        [userinfo setObject:@"true" forKey:@"DontShow"];
        [self.dontShowButton setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateNormal];
    }
        
}
- (void)viewDidUnload {
    [self setDontShowButton:nil];
    [super viewDidUnload];
}
@end
