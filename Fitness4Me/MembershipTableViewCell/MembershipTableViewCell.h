//
//  MembershipTableViewCell.h
//  Fitness4Me
//
//  Created by Ciby  on 29/01/13.
//
//

#import <UIKit/UIKit.h>

@interface MembershipTableViewCell : UITableViewCell

@property(retain,nonatomic)IBOutlet UILabel *nameLabel;
@property(retain,nonatomic)IBOutlet UILabel *rateLabel;
@property(retain,nonatomic)IBOutlet UIButton *buyNowButton;
@property(retain,nonatomic)IBOutlet UIButton *moreInfoButton;
@end
