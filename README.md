# CScrollNubLabel
支持三种UILabel中数字翻滚效果   UILabel number turn over



### 使用方式：

// 初始化对象
- (instancetype)initWithFontName:(NSString *)fontName frame:(CGRect)frame;

// 传入数据、更新、实现数字在父控件等分效果 
- (void)updateToNumberDivide:(NSString *)number;

// 传入数据、更新、居中紧凑效果  且  整数部分字体等于小数部分字体
- (void)updateToNumberCompact:(NSString *)number;

// 传入数据、更新、居中紧凑效果  且  可指定整数部分、小数部分字体大小  */
- (void)updateToNumberCompact:(NSString *)number integerFontSize:(CGFloat)integerSize decimalFontSize:(CGFloat)decimalSize;

![] (https://github.com/417296350/CScrollNubLabel/blob/master/demo-CScrollNumberLabel/demo-CScrollNumberLabel/gitPic/QQ20161101-0%402x.png)
