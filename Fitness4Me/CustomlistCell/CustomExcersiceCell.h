//
//  CustomExcersiceCell.h
//  Fitness4Me
//
//  Created by Ciby  on 12/12/12.
//
//

#import <UIKit/UIKit.h>

@interface CustomExcersiceCell : UITableViewCell
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


@property(retain,nonatomic)IBOutlet UILabel *focusLabels;

//@property(retain,nonatomic)IBOutlet UILabel *EquipmentLabels;



@end
