//
//  ViewController.m
//  dome-scrollNumber-label
//
//  Created by C on 16/10/31.
//  Copyright © 2016年 程旭东. All rights reserved.
//

#import "ViewController.h"
#import "CScrollNubLabel.h"

@interface ViewController ()
@property (nonatomic,strong) CScrollNubLabel *nubDivdeLabel;
@property (nonatomic,strong) CScrollNubLabel *nubCompactLabel;
@property (nonatomic,strong) CScrollNubLabel *nubCompactFontLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化UI
    [self setupUI];
    
}


#pragma mark - 初始化UI
- (void)setupUI{

    // 1. 第一种模式 【1.字体大小随着父控件大小、数字长度自动进行适配         2.数字均匀分布】
    [self numberDivide];
    
    // 2. 第二种模式 【1.使用者指定字体大小，默认整数、小数字体大小相等       2.数字居中集中式排列】
    [self numberCompact];
    
    // 3. 第二种模式 【1.使用者指定整数、小数部部分大小,可实现整数小数不同大小 2.数字居中集中式排列】
    [self numberCompactAppointFontSize];
}


#pragma mark - 创建对象
- (void)numberDivide{

    CScrollNubLabel *nubLabel = [[CScrollNubLabel alloc] initWithFontName:@"Quartz-Regular" frame:CGRectMake(100, 100, 150, 40)];
    nubLabel.backgroundColor = [UIColor greenColor];
    [nubLabel updateToNumberDivide:@"2992"];
    [self.view addSubview:nubLabel];
    self.nubDivdeLabel = nubLabel;
}

- (void)numberCompact{
    
    CScrollNubLabel *nubLabel = [[CScrollNubLabel alloc] initWithFontName:@"Quartz-Regular" frame:CGRectMake(100, 200, 150, 40)];
    nubLabel.compactFontSize = 20;
    nubLabel.backgroundColor = [UIColor greenColor];
    [nubLabel updateToNumberCompact:@"2952392"];
    [self.view addSubview:nubLabel];
    self.nubCompactLabel = nubLabel;
}


- (void)numberCompactAppointFontSize{

    CScrollNubLabel *nubLabel = [[CScrollNubLabel alloc] initWithFontName:@"Quartz-Regular" frame:CGRectMake(100, 300, 150, 40)];
    nubLabel.backgroundColor = [UIColor greenColor];
    [nubLabel updateToNumberCompact:@"2452.392" integerFontSize:25 decimalFontSize:10];
    [self.view addSubview:nubLabel];
    self.nubCompactFontLabel = nubLabel;
}

#pragma makr - 点击更新数据
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 获取随机数.
    NSString *randomNumberTes = nil;
    if ( arc4random_uniform(2) == 1  ) {
        randomNumberTes = [NSString stringWithFormat:@"%d%d",arc4random_uniform(100),arc4random_uniform(100)];
    }else{
        randomNumberTes = [NSString stringWithFormat:@"%d.%d",arc4random_uniform(100),arc4random_uniform(100)];
    }
    
    // 1. 默认1随机数匹配
    [self.nubDivdeLabel updateToNumberDivide:randomNumberTes];
    
    // 2. 模式2随机匹配
    [self.nubCompactLabel updateToNumberCompact:randomNumberTes];

    // 3. 模式3随机匹配
    [self.nubCompactFontLabel updateToNumberCompact:randomNumberTes integerFontSize:25 decimalFontSize:10];
    
}

@end
