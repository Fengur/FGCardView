
//
//  UWParallaxCell.h
//  UWParallaxCell

//  Created by 王智超 on 15/12/2.
//  Copyright © 2015年 com.fengur. All rights reserved.

/*

 复用cell后，设置背景即可，继承自UITableViewCell，具体用法可见代码
 [cell.parallaxImage yy_setImageWithURL:[NSURL URLWithString:_imageUrlArray[indexPath.row]]
placeholder:[UIImage imageNamed:@"maoboli"]];



 */
#import <UIKit/UIKit.h>
#import "CardModel.h"
@interface UWParallaxCell : UITableViewCell

@property (nonatomic, strong) UIImageView *parallaxImage;

@property (nonatomic, assign) CGFloat parallaxRatio;

- (void)setSourceWithModel:(CardModel *)card;

@end
