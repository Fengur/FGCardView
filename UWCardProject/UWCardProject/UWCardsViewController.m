//
//  UWCardsViewController.m
//  UWCardProject
//
//  Created by 王智超 on 15/12/2.
//  Copyright © 2015年 com.fengur. All rights reserved.
//

#import "UWCardsViewController.h"
#import "CardModel.h"
#import "UWParallaxCell.h"
@interface UWCardsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *cardTableView;
@property (nonatomic, strong) NSMutableArray *containArray;
@property (nonatomic, strong) UIImageView *baseImageView;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@end

@implementation UWCardsViewController

- (void)viewDidLoad {
    [self setUpUrlArray];
    [self setUpModels];
    [self createTableView];
    [self createImageView];
    [super viewDidLoad];
}

- (void)createImageView {
    _baseImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    _baseImageView.image = [UIImage imageNamed:@"best"];
    [self.view addSubview:_baseImageView];

    [UIView animateWithDuration:1.5f
        animations:^{
            _baseImageView.alpha = 0;
        }
        completion:^(BOOL finished) {
            [_baseImageView removeFromSuperview];
            _baseImageView = nil;
        }];
}

- (void)createTableView {
    _cardTableView = [[UITableView alloc] init];
    _cardTableView.frame = self.view.bounds;
    _cardTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mig"]];
    _cardTableView.delegate = self;
    _cardTableView.dataSource = self;
    _cardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_cardTableView];
}

- (void)viewWillLayoutSubviews {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillLayoutSubviews];
    [UIView animateWithDuration:0.7 animations:^{
        _cardTableView.frame = self.view.frame;
    }];
}

#pragma mark : - tableView代理和数据源方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UWParallaxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UWParallaxCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSourceWithModel:self.containArray[indexPath.row]];
    [cell.parallaxImage yy_setImageWithURL:[NSURL URLWithString:_imageUrlArray[indexPath.row]]
                               placeholder:[UIImage imageNamed:@"maoboli"]];
    cell.parallaxRatio = 2.0f;
    return cell;
}

#pragma mark : - 加载数据

- (void)setUpModels {
    NSMutableArray *viewTimeArray = [[NSMutableArray alloc]
        initWithObjects:@"11345", @"2314", @"123214", @"124", @"1231", @"3234", @"56577", nil];
    NSMutableArray *talkTimesArray = [[NSMutableArray alloc]
        initWithObjects:@"13", @"22", @"57", @"10", @"4", @"245", @"132", nil];
    NSMutableArray *longIntranceArray = [[NSMutableArray alloc]
        initWithObjects:@"02:23", @"00:35", @"11:20", @"14:13", @"09:13", @"23:34", @"13:45", nil];
    NSMutableArray *titleArray = [[NSMutableArray alloc]
        initWithObjects:@"日本AU广告：岳父,请把小女许配给我吧！",
                        @"妈妈护卫队", @"男人结婚后是一种怎样的体验？",
                        @"幸福虐狗的娱乐生活。", @"悟空还会回来么？",
                        @"一头喷火大怪龙到了归墟",
                        @"论麻将对大妈的终极吸引力", nil];

    _containArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        CardModel *carModel = [[CardModel alloc] init];
        carModel.viewTimes = viewTimeArray[i];
        carModel.talkingTimes = talkTimesArray[i];
        carModel.longIntrance = longIntranceArray[i];
        carModel.cardTitle = titleArray[i];
        [_containArray addObject:carModel];
    }
}

- (void)setUpUrlArray {
    _imageUrlArray = [[NSMutableArray alloc]
        initWithObjects:@"http://e.hiphotos.baidu.com/zhidao/pic/item/"
                        @"1c950a7b02087bf476aac438f3d3572c10dfcf99.jpg",
                        @"http://b.hiphotos.baidu.com/zhidao/pic/item/"
                        @"3c6d55fbb2fb43161440f47a23a4462309f7d357.jpg",
                        @"http://att.bbs.duowan.com/forum/201306/15/2216008185zmdzda1stdbm.jpg",
                        @"http://e.hiphotos.baidu.com/zhidao/pic/item/"
                        @"7af40ad162d9f2d3db298908abec8a136327cc19.jpg",
                        @"http://b.hiphotos.baidu.com/zhidao/pic/item/"
                        @"4afbfbedab64034f218260e4aac379310b551d80.jpg",
                        @"http://img2.cache.hxsd.com/game/2012/10/24/667794_1351044539_4.jpg",
                        @"http://a.hiphotos.baidu.com/zhidao/pic/item/"
                        @"359b033b5bb5c9eaa55e9032d439b6003bf3b3b6.jpg",
                        nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
