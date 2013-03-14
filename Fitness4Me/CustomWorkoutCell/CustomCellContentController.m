//
//  PortfolioCellContentController.m
//  Bridge
//
//  Created by Ciby K Jose on 28/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCellContentController.h"
#import "Fitness4MeUtils.h"
    //#import "Globals.h"


@implementation CustomCellContentController
@synthesize TitleLabel,ExcersiceImage,focusLabel,DurationLabel,deleteButton,deleteLabel,EditButton,EditLabel,favIcon;

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
        
        DurationLabel.font = [UIFont boldSystemFontOfSize:13];
        
        DurationLabel.backgroundColor =[UIColor clearColor];
        
        DurationLabel.textColor =[UIColor blackColor];
        
        
        
        // Initialization code
        focusLabel = [[CustomLabel alloc]init];
        
        focusLabel.textAlignment = UITextAlignmentLeft;
        
        focusLabel.font = [UIFont boldSystemFontOfSize:13];
        
        focusLabel.backgroundColor =[UIColor clearColor];
        
        focusLabel.textColor =[UIColor blackColor];

        [self.focusLabel setLineBreakMode:UILineBreakModeWordWrap];
         self.focusLabel.numberOfLines=0;
        
        [focusLabel sizeToFit];
        
    
        // Initialization code
        self.DurationLabels = [[UILabel alloc]init];
        
        self.DurationLabels.textAlignment = UITextAlignmentLeft;
        
        self.DurationLabels.font = [UIFont boldSystemFontOfSize:13];
        
        self.DurationLabels.backgroundColor =[UIColor clearColor];
        
        self.DurationLabels.textColor =[UIColor blackColor];
        
        
        [self.DurationLabels setLineBreakMode:UILineBreakModeWordWrap];
       
        [self.DurationLabels setText:NSLocalizedStringWithDefaultValue(@"duration", nil,[Fitness4MeUtils getBundle], nil, nil)];
        
        
        // Initialization code
        self.focusLabels = [[UILabel alloc]init];
        
        self.focusLabels.textAlignment = UITextAlignmentLeft;
        
        self.focusLabels.font = [UIFont boldSystemFontOfSize:13];
        
        self.focusLabels.backgroundColor =[UIColor clearColor];
        
        self.focusLabels.textColor =[UIColor blackColor];
        
        [self.focusLabels setLineBreakMode:UILineBreakModeWordWrap];

        [self.focusLabels setText:NSLocalizedStringWithDefaultValue(@"focus", nil,[Fitness4MeUtils getBundle], nil, nil)];

        // Initialization code
        self.EditLabel = [[UILabel alloc]init];
        
        self.EditLabel.textAlignment = UITextAlignmentLeft;
        
        self.EditLabel.font = [UIFont systemFontOfSize:12];
        
        self.EditLabel.backgroundColor =[UIColor clearColor];
        
        self.EditLabel.textColor =[UIColor blackColor];
        
        [self.EditLabel setText:@"Edit"];
        
        
        // Initialization code
        self.deleteLabel = [[UILabel alloc]init];
        
        self.deleteLabel.textAlignment = UITextAlignmentLeft;
        
        self.deleteLabel.font = [UIFont systemFontOfSize:12];
        
        self.deleteLabel.backgroundColor =[UIColor clearColor];
        
        self.deleteLabel.textColor =[UIColor blackColor];
        
        [self.deleteLabel setText:@"Delete"];
        

        
        ExcersiceImage =[[UIImageView alloc]init];
        
       
        
         EditButton =[[UIButton alloc]init];
         deleteButton =[[UIButton alloc]init];
        
        [EditButton setImage:[UIImage imageNamed:@"icon_edit.png"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
        favIcon =[[UIButton alloc]init];
        
        [favIcon setImage:[UIImage imageNamed:@"smiley.png"] forState:UIControlStateNormal];

       
        [self.contentView addSubview:TitleLabel];
        
        
        [self.contentView addSubview:favIcon];
        [self.contentView addSubview:ExcersiceImage];
        [self.contentView addSubview:focusLabel];
        [self.contentView addSubview:DurationLabel];
        [self.contentView addSubview:self.focusLabels];
        [self.contentView addSubview:self.DurationLabels];
        [self.contentView addSubview:deleteButton];
        [self.contentView addSubview:deleteLabel];
        [self.contentView addSubview:EditLabel];
        [self.contentView addSubview:EditButton];

         

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
    
    
    frame =CGRectMake(3, 25, 80, 72);
    ExcersiceImage.frame=frame;
    
    
    frame= CGRectMake(boundsX+85 ,30, 65, 21);
    self.DurationLabels.frame = frame;
    

    frame= CGRectMake(boundsX+150 ,30, 110, 21);
    self.DurationLabel.frame = frame;

    
    frame= CGRectMake(boundsX+150 ,50, contentRect.size.width-180, 64);
    self.focusLabel.frame = frame;
  
    frame= CGRectMake(boundsX+85 ,24, 65, 65);
    self.focusLabels.frame = frame;

    frame= CGRectMake(contentRect.size.width-30,10, 32, 32);
    self.favIcon.frame = frame;
    
    frame= CGRectMake(contentRect.size.width-30 ,80, 32, 32);
    self.EditButton.frame = frame;
    
    frame= CGRectMake(contentRect.size.width-30 ,45, 32, 32);
    self.deleteButton.frame = frame;
    
   }






@end
