//
//  PortfolioCellContentController.h
//  Bridge
//
//  Created by Ciby K Jose on 28/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellContentController : UITableViewCell


@property(retain,nonatomic)IBOutlet UILabel *DurationLabel;

@property(retain,nonatomic)IBOutlet UILabel *TitleLabel;

@property(retain,nonatomic)IBOutlet UILabel *focusLabel;

//@property(retain,nonatomic)IBOutlet UILabel *EquipmentLabel;

@property(retain,nonatomic)IBOutlet UIImageView *ExcersiceImage;

@property(retain,nonatomic)IBOutlet UILabel *DurationLabels;



@property(retain,nonatomic)IBOutlet UILabel *EditLabel;

@property(retain,nonatomic)IBOutlet UIButton *EditButton;

@property(retain,nonatomic)IBOutlet UILabel *deleteLabel;

@property(retain,nonatomic)IBOutlet UIButton *deleteButton;

@property(retain,nonatomic)IBOutlet UIButton *favIcon;

@property(retain,nonatomic)IBOutlet UILabel *focusLabels;

//@property(retain,nonatomic)IBOutlet UILabel *EquipmentLabels;



@end
