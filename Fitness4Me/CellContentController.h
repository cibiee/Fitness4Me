//
//  PortfolioCellContentController.h
//  Bridge
//
//  Created by Ciby K Jose on 28/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellContentController : UITableViewCell
{
    
    
    UILabel *TitleLabel;
    UILabel *RateLabel;
    UILabel *DescriptionLabel;
    UIImageView *ExcersiceImage;
    UIImageView *LockedImage;
    
    UIImageView * cellBgImage;
    
}

@property(retain,nonatomic)UILabel *RateLabel;

@property(retain,nonatomic)UILabel *TitleLabel;

@property(retain,nonatomic)UILabel *DescriptionLabel;

@property(retain,nonatomic)UIImageView *ExcersiceImage;

@property(retain,nonatomic)UIImageView *LockedImage;

@property(retain,nonatomic)UIImageView *cellBgImage;

@end
