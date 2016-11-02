# CScrollNubLabel
1.支持三种UILabel中数字翻滚效果。            UILabel number turn over    
2.支持小数点符号闪烁[指定时间、闪烁次数]。    Support the decimal notation
3.支持小数点符号停止闪烁。                   Support the decimal notation to stop flashing



### 使用方式：

//  初始化对象   
- (instancetype)initWithFontName:(NSString *)fontName frame:(CGRect)frame;

//  传入数据、等分效果  
- (void)updateToNumberDivide:(NSString *)number;

//  传入数据、居中紧凑效果  
- (void)updateToNumberCompact:(NSString *)number;

//  传入数据、居中紧凑效果 且 指定整数部分、小数部分字体大小   
- (void)updateToNumberCompact:(NSString *)number integerFontSize:(CGFloat)integerSize decimalFontSize:(CGFloat)decimalSize;

//  设置指定数据   
- (void)setAppointData:(NSString *)data fontSize:(CGFloat)fontSize;

//  小数点符号单独闪烁的方法: timeInterval时间间隔  frequency闪烁次数 
- (void)startDecimalSymbolSpangleInterval:(CGFloat)timeInterval frequency:(NSInteger)frequency;

//  停止小数点符号闪烁的方法   
- (void)stopDecimalSyemobolSpangle;

![] (https://github.com/417296350/CScrollNubLabel/blob/master/demo-CScrollNumberLabel/demo-CScrollNumberLabel/gitPic/QQ20161101-0%402x.png)
