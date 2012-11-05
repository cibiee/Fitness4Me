//
//  InitialAppLaunchViewController.h
//  Fitness4Me
//
//  Created by Ciby on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import <QuartzCore/QuartzCore.h>


@interface InitialAppLaunchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath *lastIndex;
    NSString *selectedLanguage;
    NSMutableArray *currencyKeys;
    NSMutableArray *currencytexts;
    
    IBOutlet UILabel *signUpLabel;
    IBOutlet UILabel *logInLabel;
    IBOutlet UILabel *haveAccountLabel;
    IBOutlet UILabel *newtoFitness4meLabel;
    IBOutlet UIView *selectLanguageView;
    IBOutlet UITableView *languageSelectionTableView;

}


-(IBAction)onclickRegisterUser:(id)sender;
-(IBAction)onclickLogin:(id)sender;
-(IBAction)dismissActionSheets:(id)sender;
@end


//
// define for specifyng custom colours
//

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]