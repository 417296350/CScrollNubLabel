//
//  CScrollNubLabel.h
//  dome-scrollNumber-label
//
//  Created by C on 16/10/31.
//  Copyright © 2016年 程旭东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CScrollNubLabel : UIView


#pragma mark - public 属性
/**  label所在容器的背景色   */
@property (nonatomic,strong) UIColor *containerViewBackground;
/**  label的字体颜色   */
@property (nonatomic,strong) UIColor *fontColor;
/**  执行动画间隔 [默认0.2秒]  */
@property (nonatomic,assign) CGFloat animationDuration;
/**  Compact紧凑模式指定的字体大小   */
@property (nonatomic,assign) CGFloat compactFontSize;

#pragma mark - public 方法
/**  初始化对象   */
- (instancetype)initWithFontName:(NSString *)fontName frame:(CGRect)frame;

/**  传入数据、等分效果  */
- (void)updateToNumberDivide:(NSString *)number;

/**  传入数据、居中紧凑效果  */
- (void)updateToNumberCompact:(NSString *)number;

/**  传入数据、居中紧凑效果 且 指定整数部分、小数部分字体大小  */
- (void)updateToNumberCompact:(NSString *)number integerFontSize:(CGFloat)integerSize decimalFontSize:(CGFloat)decimalSize;

@end
