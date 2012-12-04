//
//  CustomWorkoutsViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 28/11/12.
//
//

#import "CustomWorkoutsViewController.h"

@interface CustomWorkoutsViewController ()
@property NSMutableArray *groupedExcersice;
@end

@implementation CustomWorkoutsViewController

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

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return [groupedPortfolio count];
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDictionary *dictionary = [groupedPortfolio objectAtIndex:section];
//    NSArray *array = [dictionary objectForKey:@"portfolio"];
//    return [array count];
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"mycell";
    CustomCellContentController *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[CustomCellContentController alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    
    //NSDictionary *dictionary = [groupedPortfolio objectAtIndex:indexPath.section];
   // NSArray *array = [dictionary objectForKey:@"portfolio"];
   // Portfolio *portfolio = [array objectAtIndex:indexPath.row];
    cell.TitleLabel.text = @"Chest and Bisceps";
    cell.DurationLabel.text = @"20 Min";
    cell.focusLabel.text=@"Chest, Biceps";
    cell.EquipmentLabel.text=@"barbell ,  dumbell";
    cell.ExcersiceImage.image =[UIImage imageNamed:@"dummyimg.png"];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyleforRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("About to delete item %d\n", [indexPath row]);
    //[tableTitles removeObjectAtIndex:[indexPath row]];
    [tableView reloadData];
}

-(IBAction)onClickAdd:(id)sender{
    
}

-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeViewController *viewController =[[TimeViewController alloc]initWithNibName:@"TimeViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
