//
//  EMViewController.h
//  ExpenseManager
//
//  Created by Ciby  on 13/11/12.
//  Copyright (c) 2012 Ciby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *addTourManagerTableView;

-(IBAction)onClickAddFriends:(id)sender;
-(IBAction)onClickSaveTourName:(id)sender;
-(IBAction)onClickSave:(id)sender;

@end
