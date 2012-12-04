//
//  TimeViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 03/12/12.
//
//

#import "TimeViewController.h"

@interface TimeViewController ()
@property NSMutableArray *excersices;
@property(strong,nonatomic)NSIndexPath *lastIndex;
@end

@implementation TimeViewController

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
    // Do any additional setup after loading the view from its nib.
    
    // add continue button
    UIButton *backutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backutton.frame = CGRectMake(0, 0, 58, 30);
    [backutton setBackgroundImage:[UIImage imageNamed:@"back_btn_with_text.png"] forState:UIControlStateNormal];
    [backutton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:backutton];
    self.navigationBar.leftBarButtonItem = backBtn;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//PickerViewController.m
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component==0) {
        return 5;
    }
    else{
       return  10;
        
    }

}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   
    if (component==0) {
        return  [NSString stringWithFormat:@"%i", row+1];
        
        }
    else{
        return  [NSString stringWithFormat:@"%i", row];
    }
   
}

//PickerViewController.m
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    
//    if (component==0) {
//        NSLog([NSString stringWithFormat:@"%i", row+1]);
//        
//    }
//    else{
//         NSLog([NSString stringWithFormat:@"%i", row]);
//        
//    }
}



-(IBAction)onClickNext:(id)sender
{
     FocusViewController *viewController =[[FocusViewController alloc]initWithNibName:@"FocusViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTimePickerView:nil];
    [self setNavigationBar:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}
@end
