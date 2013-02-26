//
//  CustomExcersiceCell.m
//  Fitness4Me
//
//  Created by Ciby  on 12/12/12.
//
//

#import "CustomExcersiceCell.h"

@implementation CustomExcersiceCell

@synthesize TitleLabel,ExcersiceImage,focusLabel,DurationLabel;

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
        
        focusLabel.numberOfLines=4;
        
        
        // Initialization code
        self.DurationLabels = [[UILabel alloc]init];
        
        self.DurationLabels.textAlignment = UITextAlignmentLeft;
        
        self.DurationLabels.font = [UIFont boldSystemFontOfSize:13];
        
        self.DurationLabels.backgroundColor =[UIColor clearColor];
        
        self.DurationLabels.textColor =[UIColor blackColor];
        
        [self.DurationLabels setText:@"Duration"];
        
        [self.DurationLabels setLineBreakMode:UILineBreakModeWordWrap];
        // Initialization code
        self.focusLabels = [[UILabel alloc]init];
        
        self.focusLabels.textAlignment = UITextAlignmentLeft;
        
        self.focusLabels.font = [UIFont boldSystemFontOfSize:13];
        
        self.focusLabels.backgroundColor =[UIColor clearColor];
        
        self.focusLabels.textColor =[UIColor blackColor];
        
        [self.focusLabels setText:@"Focus"];
        
        [self.focusLabels setLineBreakMode:UILineBreakModeWordWrap];
               
        
        
        
        
        ExcersiceImage =[[UIImageView alloc]init];
        
        
              
        [self.contentView addSubview:TitleLabel];
        
        
        
        [self.contentView addSubview:ExcersiceImage];
        
        [self.contentView addSubview:focusLabel];
        [self.contentView addSubview:DurationLabel];
        [self.contentView addSubview:self.focusLabels];
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
    
    
    frame= CGRectMake(boundsX+35,boundsY+1, contentRect.size.width-80, 25);
    
    TitleLabel.frame = frame;
    
    
    frame =CGRectMake(3, 25, 80, 72);
    
    ExcersiceImage.frame=frame;
    
    
    frame= CGRectMake(boundsX+85 ,20, 65, 21);
    
    self.DurationLabels.frame = frame;
    
    
    frame= CGRectMake(boundsX+150 ,20, 110, 21);
    
    self.DurationLabel.frame = frame;
    
    
    frame= CGRectMake(boundsX+150 ,50, contentRect.size.width-170, 64);
    
    self.focusLabel.frame = frame;
    
    frame= CGRectMake(boundsX+85 ,24, 65, 65);
    
    self.focusLabels.frame = frame;
    
      
}



@end
