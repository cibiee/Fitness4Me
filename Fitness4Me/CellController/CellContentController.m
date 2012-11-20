//
//  PortfolioCellContentController.m
//  Bridge
//
//  Created by Ciby K Jose on 28/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CellContentController.h"
    //#import "Globals.h"


@implementation CellContentController
@synthesize TitleLabel,DescriptionLabel,ExcersiceImage,cellBgImage,LockedImage,RateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        TitleLabel = [[UILabel alloc]init];
        
        TitleLabel.textAlignment = UITextAlignmentLeft;
        
        TitleLabel.font = [UIFont systemFontOfSize:14];
        
        TitleLabel.backgroundColor =[UIColor clearColor];
        
        TitleLabel.textColor =[UIColor whiteColor];
        
        
        // Initialization code
        RateLabel = [[UILabel alloc]init];
        
        RateLabel.textAlignment = UITextAlignmentLeft;
        
        RateLabel.font = [UIFont systemFontOfSize:14];
        
        RateLabel.backgroundColor =[UIColor clearColor];
        
        RateLabel.textColor =[UIColor whiteColor];
        
        
        
        DescriptionLabel = [[UILabel alloc]init];
        
        DescriptionLabel.textAlignment = UITextAlignmentLeft;
        
        DescriptionLabel.font = [UIFont systemFontOfSize:14];
        
        DescriptionLabel.textColor=[UIColor blackColor];
        
        DescriptionLabel.backgroundColor =[UIColor clearColor];
        
        DescriptionLabel.textColor =[UIColor whiteColor];
        
        ExcersiceImage =[[UIImageView alloc]init];
        
        LockedImage =[[UIImageView alloc]init];
        
        LockedImage.image =[UIImage imageNamed:@"locked.png"];
        
        [self.contentView addSubview:ExcersiceImage];
        
        //[self.contentView addSubview:LockedImage];
        
        [self.contentView addSubview:TitleLabel];
        
        [self.contentView addSubview:DescriptionLabel];
        
       // [self.contentView addSubview:RateLabel];
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"list_item.png"]];
        
        self.backgroundColor = background;
        
        
       
        
        
    

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
    {
        
        
      
        
        // Initialization code
        TitleLabel = [[UILabel alloc]init];
  
        TitleLabel.textAlignment = UITextAlignmentLeft;
  
        TitleLabel.font = [UIFont systemFontOfSize:14];
  
        TitleLabel.backgroundColor =[UIColor clearColor];
        
        TitleLabel.textColor =[UIColor whiteColor];
        
        
        // Initialization code
        RateLabel = [[UILabel alloc]init];
        
        RateLabel.textAlignment = UITextAlignmentLeft;
        
        RateLabel.font = [UIFont systemFontOfSize:14];
        
        RateLabel.backgroundColor =[UIColor clearColor];
        
        RateLabel.textColor =[UIColor whiteColor];
        
        

        DescriptionLabel = [[UILabel alloc]init];
  
        DescriptionLabel.textAlignment = UITextAlignmentLeft;
  
        DescriptionLabel.font = [UIFont systemFontOfSize:14];
  
        DescriptionLabel.textColor=[UIColor blackColor];
  
        DescriptionLabel.backgroundColor =[UIColor clearColor];
        
         DescriptionLabel.textColor =[UIColor whiteColor];
        
        ExcersiceImage =[[UIImageView alloc]init];
  
        LockedImage =[[UIImageView alloc]init];
    
        LockedImage.image =[UIImage imageNamed:@"locked.png"];
  
        [self.contentView addSubview:ExcersiceImage];
  
        [self.contentView addSubview:LockedImage];
                
        [self.contentView addSubview:TitleLabel];
  
        [self.contentView addSubview:DescriptionLabel];
        
        [self.contentView addSubview:RateLabel];
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"list_item.png"]];
        
        self.backgroundColor = background;
        

        
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    
    CGFloat boundsX = contentRect.origin.x;
    
    CGFloat boundsY = contentRect.origin.y;
    
    CGRect frame;
    
    frame =CGRectMake(2, 15, 80, 62);
//    
    ExcersiceImage.frame=frame;
//    
    frame =CGRectMake(contentRect.size.width-40, boundsY+20, 32, 32);
    
    LockedImage.frame=frame;

    frame= CGRectMake(boundsX+84 ,boundsY+10, contentRect.size.width-120, 25);
    
    TitleLabel.frame = frame;
    
    frame= CGRectMake(boundsX+84 ,40, contentRect.size.width-120, 15);
    
    DescriptionLabel.frame = frame;
    
    
    frame= CGRectMake(boundsX+82 ,60, 200, 15);
    
    RateLabel.frame = frame;
}






@end
