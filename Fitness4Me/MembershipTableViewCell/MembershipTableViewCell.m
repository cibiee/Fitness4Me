//
//  MembershipTableViewCell.m
//  Fitness4Me
//
//  Created by Ciby  on 29/01/13.
//
//

#import "MembershipTableViewCell.h"

@implementation MembershipTableViewCell

@synthesize nameLabel,rateLabel,buyNowButton,moreInfoButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        nameLabel = [[UILabel alloc]init];
        
        nameLabel.textAlignment = UITextAlignmentCenter;
        
        nameLabel.font = [UIFont boldSystemFontOfSize:17];
        
        nameLabel.backgroundColor =[UIColor clearColor];
        
        nameLabel.textColor =[UIColor blackColor];
        
              
        
        
        // Initialization code
        rateLabel = [[UILabel alloc]init];
        
        rateLabel.textAlignment = UITextAlignmentLeft;
        rateLabel.font = [UIFont boldSystemFontOfSize:20];
        
        rateLabel.backgroundColor =[UIColor clearColor];
        
        rateLabel.textColor =[UIColor redColor];
        
        rateLabel.numberOfLines=0;
        
        [rateLabel sizeToFit];
        
        moreInfoButton =[[UIButton alloc]init];
        buyNowButton =[[UIButton alloc]init];
    
         
        
        [moreInfoButton setTitle:@"More Info"  forState:UIControlStateNormal];
        [buyNowButton setTitle:@"Buy Now"  forState:UIControlStateNormal];
        [moreInfoButton setBackgroundImage:[UIImage imageNamed:@"btnMembership.png"] forState:UIControlStateNormal];
        [buyNowButton setBackgroundImage:[UIImage imageNamed:@"btnMembership.png"] forState:UIControlStateNormal];
        
        
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:rateLabel];
        [self.contentView addSubview:moreInfoButton];
        [self.contentView addSubview:buyNowButton];
        
        
        
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
    
    
    frame= CGRectMake(boundsX+10,boundsY, contentRect.size.width-30, 36);
    
    nameLabel.frame = frame;
    
    frame= CGRectMake(boundsX+106 ,33, contentRect.size.width-200, 36);
    
    self.rateLabel.frame = frame;
    
       
    frame= CGRectMake(56 ,74, 90, 28);
    
    self.moreInfoButton.frame = frame;
    
    
    frame= CGRectMake(156 ,74, 90, 28);
    
    self.buyNowButton.frame = frame;
    
}






@end
