//
//  CustomExcersiceCell.m
//  Fitness4Me
//
//  Created by Ciby  on 12/12/12.
//
//

#import "CustomExcersiceCell.h"

@implementation CustomExcersiceCell

@synthesize TitleLabel,ExcersiceImage,focusLabel,DurationLabel,deleteButton,deleteLabel,EditButton,EditLabel;

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
        
        DurationLabel.font = [UIFont systemFontOfSize:13];
        
        DurationLabel.backgroundColor =[UIColor clearColor];
        
        DurationLabel.textColor =[UIColor blackColor];
        
        
        
        // Initialization code
        focusLabel = [[UILabel alloc]init];
        
        focusLabel.textAlignment = UITextAlignmentLeft;
        
        focusLabel.font = [UIFont systemFontOfSize:13];
        
        focusLabel.backgroundColor =[UIColor clearColor];
        
        focusLabel.textColor =[UIColor blackColor];
        
        focusLabel.numberOfLines=4;
        
        
        // Initialization code
        self.DurationLabels = [[UILabel alloc]init];
        
        self.DurationLabels.textAlignment = UITextAlignmentLeft;
        
        self.DurationLabels.font = [UIFont systemFontOfSize:13];
        
        self.DurationLabels.backgroundColor =[UIColor clearColor];
        
        self.DurationLabels.textColor =[UIColor blackColor];
        
        [self.DurationLabels setText:@"Duration"];
        
        
        // Initialization code
        self.focusLabels = [[UILabel alloc]init];
        
        self.focusLabels.textAlignment = UITextAlignmentLeft;
        
        self.focusLabels.font = [UIFont systemFontOfSize:13];
        
        self.focusLabels.backgroundColor =[UIColor clearColor];
        
        self.focusLabels.textColor =[UIColor blackColor];
        
        [self.focusLabels setText:@"Focus"];
        
        
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
        
        
        [self.contentView addSubview:TitleLabel];
        
        
        
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
    
    
    frame= CGRectMake(boundsX+35,boundsY+1, contentRect.size.width-60, 25);
    
    TitleLabel.frame = frame;
    
    
    
    
    frame =CGRectMake(7, 25, 80, 72);
    
    ExcersiceImage.frame=frame;
    
    
    
    frame= CGRectMake(boundsX+160 ,30, 110, 21);
    
    self.DurationLabel.frame = frame;
    
    
    frame= CGRectMake(boundsX+160 ,50, contentRect.size.width-210, 65);
    
    self.focusLabel.frame = frame;
    
    
    
    
    frame= CGRectMake(boundsX+90 ,30, 55, 21);
    
    self.DurationLabels.frame = frame;
    
    
    frame= CGRectMake(boundsX+90 ,50, 55, 65);
    
    self.focusLabels.frame = frame;
    
    
    
    
    frame= CGRectMake(270 ,80, 25, 25);
    
    self.EditButton.frame = frame;
    
    
    
    
    frame= CGRectMake(270 ,50, 25, 25);
    
    self.deleteButton.frame = frame;
    
}



@end
