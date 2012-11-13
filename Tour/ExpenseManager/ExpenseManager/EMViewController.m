//
//  EMViewController.m
//  ExpenseManager
//
//  Created by Ciby  on 13/11/12.
//  Copyright (c) 2012 Ciby. All rights reserved.
//

#import "EMViewController.h"


// RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface EMViewController ()
@property (weak, nonatomic) UITableViewCell *addTourCell;
@property (weak, nonatomic) UITableViewCell *addFriendsCell;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSArray *favoriteWorkplaces;
@end

@implementation EMViewController

- (void)viewDidLoad
{
    self.friends=[[NSMutableArray alloc]init];
    [self.friends addObject:@""];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onClickAddFriends:(id)sender
{
    [self.friends  addObject:@""];
    [self.addTourManagerTableView reloadData];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cell = 0;
    if (section == 0) {
        cell = 1;
    } else if (section == 1) {
        cell = [self.friends count];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
     if (indexPath.section == 0) {
        
        // session start
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddTourCell"];
        [cell viewWithTag:1];
        self.addTourCell = cell;
        
    } else if (indexPath.section == 1) {
        
        // favorite workplace
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float cellHeight;
    if(section == 0) {
      cellHeight=   40;
    } else if (section == 1) {
      cellHeight=   40;
    }
    
    return cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    } else if (indexPath.section == 1) {
        return 50;
    }else
        return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor = [UIColor clearColor];
    
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,300,44)];
    tempLabel.font =[UIFont boldSystemFontOfSize:17];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = UIColorFromRGBWithAlpha(0x4c566c, 1);
    tempLabel.shadowColor=[UIColor whiteColor];
    tempLabel.shadowOffset= CGSizeMake(1.0f, 1.0f);
    
    if(section == 0) {
        tempLabel.text = NSLocalizedString(@"Add Tour", nil);
    } else if (section == 1) {
        tempLabel.text = NSLocalizedString(@"Add Friends", nil);
    }
    
    [tempView addSubview:tempLabel];
    return tempView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section==1) {
         [self.friends removeObjectAtIndex:[indexPath row]];
            [self.addTourManagerTableView reloadData];
        // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

#pragma mark -TextView delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSIndexPath *path =[NSIndexPath indexPathForRow:0 inSection:1];
    
        [self.addTourManagerTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *path =[NSIndexPath indexPathForRow:0 inSection:0];
   
        [self.addTourManagerTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}


@end
