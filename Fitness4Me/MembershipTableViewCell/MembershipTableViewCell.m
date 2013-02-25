//
//  MembershipTableViewCell.m
//  Fitness4Me
//
//  Created by Ciby  on 29/01/13.
//
//

#import "MembershipTableViewCell.h"

@implementation MembershipTableViewCell

@synthesize nameLabel,rateLabel,descritptionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        nameLabel = [[UILabel alloc]init];
        
        nameLabel.textAlignment = UITextAlignmentCenter;
        
        nameLabel.font = [UIFont boldSystemFontOfSize:20];
        
        nameLabel.backgroundColor =[UIColor clearColor];
        
        nameLabel.textColor =[UIColor blackColor];
        
        // Initialization code
        rateLabel = [[UILabel alloc]init];
        
        rateLabel.textAlignment = UITextAlignmentCenter;
        
        rateLabel.font = [UIFont boldSystemFontOfSize:18];
        
        rateLabel.backgroundColor =[UIColor clearColor];
        
        rateLabel.textColor =[UIColor whiteColor];
        
        rateLabel.numberOfLines=0;
        
        [rateLabel sizeToFit];
        
        //
        
        descritptionLabel = [[UILabel alloc]init];
        
        descritptionLabel.textAlignment = UITextAlignmentCenter;
        
        descritptionLabel.font = [UIFont systemFontOfSize:13];
        
        descritptionLabel.backgroundColor =[UIColor clearColor];
        
        descritptionLabel.textColor =[UIColor blackColor];
        
        descritptionLabel.numberOfLines=2;
        
        descritptionLabel.lineBreakMode=UILineBreakModeWordWrap;
        
        [descritptionLabel sizeToFit];

       
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:rateLabel];
        [self.contentView addSubview:descritptionLabel];
               
        
        
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
    
    frame= CGRectMake(boundsX+5,boundsY, contentRect.size.width-5, 36);
    
    nameLabel.frame = frame;
    
    frame= CGRectMake(boundsX+5,66, contentRect.size.width-5, 36);
    
    self.rateLabel.frame = frame;
    
    frame= CGRectMake(boundsX+5 ,25, contentRect.size.width-5, 56);
    
    self.descritptionLabel.frame = frame;
}






@end
