//
//  PortfolioCellContentController.m
//  Bridge
//
//  Created by Ciby K Jose on 28/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCellContentController.h"
    //#import "Globals.h"


@implementation CustomCellContentController
@synthesize TitleLabel,EquipmentLabel,ExcersiceImage,focusLabel,DurationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        TitleLabel = [[UILabel alloc]init];
        
        TitleLabel.textAlignment = UITextAlignmentCenter;
        
        TitleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        TitleLabel.backgroundColor =[UIColor clearColor];
        
        TitleLabel.textColor =[UIColor blackColor];
        
        
        // Initialization code
        DurationLabel = [[UILabel alloc]init];
        
        DurationLabel.textAlignment = UITextAlignmentLeft;
        
        DurationLabel.font = [UIFont systemFontOfSize:12];
        
        DurationLabel.backgroundColor =[UIColor clearColor];
        
        DurationLabel.textColor =[UIColor blackColor];
        
        
        
        // Initialization code
        focusLabel = [[UILabel alloc]init];
        
        focusLabel.textAlignment = UITextAlignmentLeft;
        
        focusLabel.font = [UIFont systemFontOfSize:12];
        
        focusLabel.backgroundColor =[UIColor clearColor];
        
        focusLabel.textColor =[UIColor blackColor];

        
        
        EquipmentLabel = [[UILabel alloc]init];
        
        EquipmentLabel.textAlignment = UITextAlignmentLeft;
        
        EquipmentLabel.font = [UIFont systemFontOfSize:12];
        
        EquipmentLabel.textColor=[UIColor blackColor];
        
        EquipmentLabel.backgroundColor =[UIColor clearColor];
        
        
        
        // Initialization code
        self.DurationLabels = [[UILabel alloc]init];
        
        self.DurationLabels.textAlignment = UITextAlignmentLeft;
        
        self.DurationLabels.font = [UIFont systemFontOfSize:12];
        
        self.DurationLabels.backgroundColor =[UIColor clearColor];
        
        self.DurationLabels.textColor =[UIColor blackColor];
        
        [self.DurationLabels setText:@"Duration"];
        
        
        // Initialization code
        self.focusLabels = [[UILabel alloc]init];
        
        self.focusLabels.textAlignment = UITextAlignmentLeft;
        
        self.focusLabels.font = [UIFont systemFontOfSize:12];
        
        self.focusLabels.backgroundColor =[UIColor clearColor];
        
        self.focusLabels.textColor =[UIColor blackColor];
        
         [self.focusLabels setText:@"Focus"];
        
        self.EquipmentLabels = [[UILabel alloc]init];
        
        self.EquipmentLabels.textAlignment = UITextAlignmentLeft;
        
        self.EquipmentLabels.font = [UIFont systemFontOfSize:12];
        
        self.EquipmentLabels.textColor=[UIColor blackColor];
        
        self.EquipmentLabels.backgroundColor =[UIColor clearColor];

        [self.EquipmentLabels setText:@"Equipments"];
        
        
        
        ExcersiceImage =[[UIImageView alloc]init];
        
        [self.contentView addSubview:TitleLabel];
        
        [self.contentView addSubview:ExcersiceImage];
        
        [self.contentView addSubview:focusLabel];
    
        [self.contentView addSubview:EquipmentLabel];
        
        [self.contentView addSubview:DurationLabel];
        
               
        [self.contentView addSubview:self.focusLabels];
        
        [self.contentView addSubview:self.EquipmentLabels];
        
        [self.contentView addSubview:self.DurationLabels];
        
         

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    
    CGFloat boundsX = contentRect.origin.x;
    
    CGFloat boundsY = contentRect.origin.y;
    
    CGRect frame;
    
    
    frame= CGRectMake(boundsX+35,boundsY+1, contentRect.size.width-120, 25);
    
    TitleLabel.frame = frame;
    
    
    
    
    frame =CGRectMake(20, 29, 70, 70);
    
    ExcersiceImage.frame=frame;
    
    
    
    frame= CGRectMake(boundsX+187 ,22, 200, 15);
    
    self.DurationLabel.frame = frame;

    
    frame= CGRectMake(boundsX+187 ,47, 200, 40);
    
    self.focusLabel.frame = frame;

    
    
    frame= CGRectMake(boundsX+187 ,88, contentRect.size.width-120, 40);
    
    EquipmentLabel.frame = frame;
    
    
    
    frame= CGRectMake(boundsX+110 ,22, 200, 15);
    
    self.DurationLabels.frame = frame;
    
    
    frame= CGRectMake(boundsX+110 ,47, 200, 40);
    
    self.focusLabels.frame = frame;
    
    
    
    frame= CGRectMake(boundsX+110 ,88, contentRect.size.width-120, 40);
    
    self.EquipmentLabels.frame = frame;
    
    

    
    
   }






@end
