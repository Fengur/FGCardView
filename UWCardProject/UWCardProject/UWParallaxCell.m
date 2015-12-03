
//
//  UWParallaxCell.m
//  UWParallaxCell

//  Created by 王智超 on 15/12/2.
//  Copyright © 2015年 com.fengur. All rights reserved.

#import "UWParallaxCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface UWParallaxCell ()

@property (nonatomic, strong) UITableView *parentTableView;
@property (nonatomic, strong) UIImageView *topMargin;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *viewTimesLabel;
@property (nonatomic, strong) UILabel *talkLabel;
@property (nonatomic, strong) UILabel *longIntranceLabel;
@property (nonatomic, strong) UIImageView *viewTimeImage;
@property (nonatomic, strong) UIImageView *talkImage;
@property (nonatomic, strong) UIImageView *longInImage;

@end

@implementation UWParallaxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        [self createControls];
    }
    return self;
}


#pragma mark: - 自定义cell控件部分，与滑动视差逻辑无关
- (void)createControls {
    _topMargin = [UIImageView new];
    _topMargin.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli"]];

    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _titleLabel.textColor = [UIColor yellowColor];

    _viewTimesLabel = [UILabel new];
    _viewTimesLabel.textColor = [UIColor greenColor];
    _viewTimesLabel.font = [UIFont boldSystemFontOfSize:14.f];

    _talkLabel = [UILabel new];
    _talkLabel.textColor = [UIColor greenColor];
    _talkLabel.font = [UIFont boldSystemFontOfSize:14.f];

    _longIntranceLabel = [UILabel new];
    _longIntranceLabel.textAlignment = NSTextAlignmentLeft;
    _longIntranceLabel.textColor = [UIColor greenColor];
    _longIntranceLabel.font = [UIFont boldSystemFontOfSize:14.f];

    _viewTimeImage = [UIImageView new];
    _talkImage = [UIImageView new];
    _longInImage = [UIImageView new];

    self.viewTimeImage.image = [UIImage imageNamed:@"viewtime"];
    self.talkImage.image = [UIImage imageNamed:@"talk"];
    self.longInImage.image = [UIImage imageNamed:@"long"];

    [self.contentView addSubview:_topMargin];
    [self.contentView addSubview:_viewTimesLabel];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_talkLabel];
    [self.contentView addSubview:_longIntranceLabel];
    [self.contentView addSubview:_viewTimeImage];
    [self.contentView addSubview:_talkImage];
    [self.contentView addSubview:_longInImage];

    self.topMargin.sd_layout.leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .heightIs(5)
        .widthRatioToView(self.contentView, 1);

    self.titleLabel.sd_layout.leftSpaceToView(self.contentView, 5)
        .topSpaceToView(self.contentView, 140)
        .heightIs(30)
        .rightSpaceToView(self.contentView, 5);

    self.viewTimeImage.sd_layout.leftEqualToView(self.titleLabel)
        .topSpaceToView(self.titleLabel, 5)
        .widthIs(20)
        .heightIs(20);

    self.viewTimesLabel.sd_layout.leftSpaceToView(self.viewTimeImage, 5)
        .topEqualToView(self.viewTimeImage)
        .widthRatioToView(self.contentView, 0.2)
        .heightRatioToView(self.viewTimeImage, 1);

    self.talkImage.sd_layout.leftSpaceToView(self.viewTimesLabel, 5)
        .topEqualToView(self.viewTimesLabel)
        .widthRatioToView(self.viewTimeImage, 1)
        .heightRatioToView(self.viewTimesLabel, 1);

    self.talkLabel.sd_layout.leftSpaceToView(self.talkImage, 5)
        .topEqualToView(self.talkImage)
        .widthRatioToView(self.viewTimesLabel, 1)
        .heightRatioToView(self.viewTimesLabel, 1);

    self.longInImage.sd_layout.leftSpaceToView(self.talkLabel, 0)
        .topEqualToView(self.talkLabel)
        .widthRatioToView(self.talkImage, 1)
        .heightRatioToView(self.talkImage, 1);

    self.longIntranceLabel.sd_layout.leftSpaceToView(self.longInImage, 5)
        .topEqualToView(self.longInImage)
        .rightSpaceToView(self.contentView, 5)
        .heightRatioToView(self.talkLabel, 1);
}

- (void)setSourceWithModel:(CardModel *)card {
    self.titleLabel.text = card.cardTitle;
    self.talkLabel.text = card.talkingTimes;
    self.longIntranceLabel.text = card.longIntrance;
    self.viewTimesLabel.text = card.viewTimes;
}




#pragma mark: - 设置图片滑动视差逻辑
- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.parallaxImage = [UIImageView new];
    [self.contentView addSubview:self.parallaxImage];
    [self.contentView sendSubviewToBack:self.parallaxImage];
    self.parallaxImage.backgroundColor = [UIColor whiteColor];
    self.parallaxImage.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.parallaxRatio = 1.5f;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self safeRemoveObserver];
    UIView *v = newSuperview;
    while (v) {
        if ([v isKindOfClass:[UITableView class]]) {
            self.parentTableView = (UITableView *)v;
            break;
        }
        v = v.superview;
    }
    [self safeAddObserver];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self safeRemoveObserver];
}

- (void)safeAddObserver {
    if (self.parentTableView) {
        @try {
            [self.parentTableView
                addObserver:self
                 forKeyPath:@"contentOffset"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:nil];
        } @catch (NSException *exception) {
        }
    }
}

- (void)safeRemoveObserver {
    if (self.parentTableView) {
        @try {
            [self.parentTableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        } @catch (NSException *exception) {
        } @finally {
            self.parentTableView = nil;
        }
    }
}

- (void)dealloc {
    [self safeRemoveObserver];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.parallaxRatio = self.parallaxRatio;
    return;
}

- (void)setParallaxRatio:(CGFloat)parallaxRatio {
    _parallaxRatio = MAX(parallaxRatio, 1.0f);
    _parallaxRatio = MIN(parallaxRatio, 2.0f);

    CGRect rect = self.bounds;
    rect.size.height = rect.size.height * parallaxRatio;
    self.parallaxImage.frame = rect;

    [self updateParallaxOffset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (![self.parentTableView.visibleCells containsObject:self] ||
            (self.parallaxRatio == 1.0f)) {
            return;
        }

        [self updateParallaxOffset];
    }
}

- (void)updateParallaxOffset {
    CGFloat contentOffset = self.parentTableView.contentOffset.y;
    CGFloat cellOffset = self.frame.origin.y - contentOffset;
    CGFloat percent = (cellOffset + self.frame.size.height) /
                      (self.parentTableView.frame.size.height + self.frame.size.height);
    CGFloat extraHeight = self.frame.size.height * (self.parallaxRatio - 1.0f);
    CGRect rect = self.parallaxImage.frame;
    rect.origin.y = -extraHeight * percent;
    self.parallaxImage.frame = rect;
}
@end
