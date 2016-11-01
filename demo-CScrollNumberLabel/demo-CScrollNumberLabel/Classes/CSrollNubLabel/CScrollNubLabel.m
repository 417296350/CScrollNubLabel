//
//  CScrollNubLabel.m
//  dome-scrollNumber-label
//
//  Created by C on 16/10/31.
//  Copyright © 2016年 程旭东. All rights reserved.
//

#import "CScrollNubLabel.h"

#define kRadixLabelW 3

@interface CScrollNubLabel(){

    /** ------------------ 容器相关属性 ----------------------- */
    CGRect          _containerViewF;     //容器的frame

    /** ----------------- Label相关通用属性 ---------------------- */
    NSString        *_defaultNumbers;     //label中默认存放的数字
    NSMutableArray  *_labels;             //存放label的数组
    NSString        *_fontName;           //Label内文本使用的字体名称
    NSInteger       _rowOfLabel;          //Laebl内的行数 （默认11行 {0、1..9、0} ）
    NSInteger       _dataLenght;          //数据长度 = 数字的位数+小数点的总数量
    CGFloat         _radixSysbolLabelW;   //小数点符号label的宽度
    NSInteger       _randixLabelIndex;    //小数点label的索引[-1不存在小数]
    CGFloat         _radixSymbolfontSize; //小数点符号字体大小
 
    /** ----------------- 紧凑Label相关属性 ---------------------- */
    CGFloat         _integerFontSize;           //整数部分字体大小
    CGFloat         _decimalFontSize;           //小数部分字体大小
    CGFloat         _compactIntegerLabelW;      //紧凑类型整数label宽度
    CGFloat         _compactRadixLabelW;        //紧凑类型小数label宽度

}
@end

@implementation CScrollNubLabel

#pragma mark - 初始化构造
- (instancetype)initWithFontName:(NSString *)fontName frame:(CGRect)frame{

    if ( self = [super initWithFrame:frame] ) {
        _fontName = fontName;
        _containerViewF = frame;
        _defaultNumbers = @"0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0";
        _rowOfLabel = 11;       //一个label中默认11行
        _randixLabelIndex = -1; //-1默认不存在小数点
        _labels = [NSMutableArray array];
    }
    return self;
}


#pragma mark - 重载set方法
- (void)setContainerViewBackground:(UIColor *)containerViewBackground{
    _containerViewBackground = containerViewBackground;
    self.backgroundColor = _containerViewBackground;
}

- (void)setFontColor:(UIColor *)fontColor{
    _fontColor = fontColor;
    for (UILabel *label in _labels) {
        label.textColor = _fontColor;
    }
}




#pragma mark --------- 更新数据方式1
- (void)updateToNumberDivide:(NSString *)number{

    // 0.根据传入数据的长度，记录数字+小数点的总长度
    _dataLenght = number.length;

    // 1.如果传入的数据个数不等于数组中label的个数
    if ( [self isNeedAgainCreateLabelsWithNumber:number] ) {

        // 1.1 清空容器View中的所有label 及 数组中的所有label元素  [后期优化]
        [self removerAllLabes];

        // 1.2 根据传入数据的数字个数创建label
        [self createAllDivideLabelsWithNumber:number];
    }


    // 2.给label传入数据、执行动画
    [self setData:number animation:YES];
}

// 创建所有label
- (void)createAllDivideLabelsWithNumber:(NSString *)number{

    // 1. 确认数据是处理否存在小数点
    [self judgeDecimalForNumber:number];

    // 2. 创建label，设置相关属性
    for (NSInteger i = 0; i<_dataLenght; i++) {

        // 2.0 获取显示数据
        NSString *showText = [number substringWithRange:NSMakeRange(i, 1)];

        // 2.1 判断showText文本属于数字or小数点
        UILabel *label = nil;
        if ( [showText isEqualToString:@"."] ) {//小数点，去创建小数点类型的label
            label = [self createDivideRadixLabelAttributeWithIndex:i];
        }else{//数字，去创建数字类型的label
            label = [self createDivideNumberLabelAttributeWithIndex:i];
        }

        // 2.6 添加到容器中
        [self addSubview:label];

        // 2.6 添加的labels数组中
        [_labels addObject:label];
    }
}

// 处理数字label
- (UILabel *)createDivideNumberLabelAttributeWithIndex:(NSInteger)index{

    // 1. 创建label
    UILabel *label = [[UILabel alloc] init];

    // 2. 判断是否存在小数
    if (_randixLabelIndex == -1) {
        _radixSysbolLabelW = 0;
    }else{
        _radixSysbolLabelW = kRadixLabelW;
    }


    // 3. 判断是整数部分or小数部分
    if ( _randixLabelIndex==-1 || index < _randixLabelIndex ) {//如果索引小于小数label的索引，为整数部分

        // 1. 计算一个label相对于当前容器大小的宽度
        // 默认包含小数点，所以要除以（_dataLenght - 1）
        CGFloat labelW = (_containerViewF.size.width - _radixSysbolLabelW) / (_dataLenght - 1);
        // _randixLabelIndex==-1不包含小数点则除以_dataLenght
        if ( _randixLabelIndex==-1  ) {
            labelW = (_containerViewF.size.width - _radixSysbolLabelW) / (_dataLenght);
        }
        

        // 2 计算label的X,Y,H
        CGFloat labelX = labelW * index;
        CGFloat labelY = 0;
        CGFloat labelH = _containerViewF.size.height * (_rowOfLabel);

        // 3. 由于W,H确定控件字体大小 [fontSize = min(W，H)]
        CGFloat fontSize = MIN(labelW, _containerViewF.size.height) - 2;

        // 4. 设置字体和frame
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.font = [UIFont fontWithName:_fontName size:fontSize];
        _radixSymbolfontSize = fontSize;

        // 5. 设置整数部分的属性
        label.textAlignment = NSTextAlignmentRight;

    }else{// 小数部分

        // 1. 计算一个label相对于当前容器大小的宽度
        CGFloat labelW = (_containerViewF.size.width - _radixSysbolLabelW) / (_dataLenght - 1);

        // 2 计算label的X,Y,H
        CGFloat labelX = labelW * (index-1) + _radixSysbolLabelW;
        CGFloat labelY = 0;
        CGFloat labelH = _containerViewF.size.height * _rowOfLabel;

        // 3. 由于W,H确定控件字体大小 [fontSize = min(W，H)]
        CGFloat fontSize = MIN(labelW, _containerViewF.size.height) - 2;

        // 4. 设置字体和frame
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.font = [UIFont fontWithName:_fontName size:fontSize];
        
        // 5. 设置整数部分的属性
        label.textAlignment = NSTextAlignmentLeft;
    }

    // 5. 设置属性

    label.numberOfLines = _rowOfLabel;

    // 6. 传入预先默认的数字文本内容
    label.text = _defaultNumbers;
    [self setRowAttributewForLabel:label];

    // 7. 返回label
    return label;

}

// 处理小数点label
- (UILabel *)createDivideRadixLabelAttributeWithIndex:(NSInteger)index{

    // 1. 计算一个label相对于当前容器大小的宽度
    CGFloat labelW = kRadixLabelW;

    // 2 计算label的X,Y,H
    CGFloat labelX = 0;
    if ( index > 0) {//获取最后一个整数的label
        UILabel *lastLabel = _labels[index - 1];
        labelX = lastLabel.frame.origin.x + lastLabel.frame.size.width;
    }
    CGFloat labelY = 0;
    CGFloat labelH = _containerViewF.size.height * _rowOfLabel;

    // 3. 由于W,H确定控件字体大小 [fontSize = min(W，H)]
    CGFloat fontSize = 0;
    if ( _radixSymbolfontSize == 0 ) {
        fontSize = MIN(labelW, labelH);
    }else{
        fontSize = _radixSymbolfontSize;
    }

    // 4. 创建label
    UILabel *label = [[UILabel alloc] init];

    // 5. 设置属性
    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    label.font = [UIFont fontWithName:_fontName size:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    
    // 6. 传入数据
    label.text = @".\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.";

    // 5. 设置属性
    label.numberOfLines = _rowOfLabel;
    
    // 6. 传入预先默认的数字文本内容
    [self setRowAttributewForLabel:label];

    // 7. 记录小数点label的索引
    _randixLabelIndex = index;

    // 8. 返回数据
    return label;
}


#pragma mark --------- 更新数据方式2
- (void)updateToNumberCompact:(NSString *)number{

    // 0.根据传入数据的长度，记录数字+小数点的总长度
    _dataLenght = number.length;
    
    // 2.判断是否应该重写创建Label控件
    if ( [self isNeedAgainCreateLabelsWithNumber:number] ) {
        
        // 1.1 清空容器View中的所有label 及 数组中的所有label元素  [后期优化]
        [self removerAllLabes];
        
        // 1.2 根据传入数据的数字个数创建label
        [self createAllCompactLabelsWithNumber:number];
    }
    
    // 3.给label传入数据、执行动画
    [self setData:number animation:YES];
    
}

// 创建所有label
- (void)createAllCompactLabelsWithNumber:(NSString *)number{

    // 1. 确认数据是否存在小数点
    [self judgeDecimalForNumber:number];
    
    // 2. 先预算整数label 、 小数label 、小数点符号label的宽度
    [self advanceCalculateCompactAllLabelWidth];
    
    // 2. 创建label，设置相关属性
    for (NSInteger i = 0; i<_dataLenght; i++) {
        
        // 2.0 获取显示数据
        NSString *showText = [number substringWithRange:NSMakeRange(i, 1)];
        
        // 2.1 判断showText文本属于数字or小数点
        UILabel *label = nil;
        if ( [showText isEqualToString:@"."] ) {//小数点，去创建小数点类型的label
            label = [self createCompactRadixLabelAttributeWithIndex:i];
        }else{//数字，去创建数字类型的label
            label = [self createCompactNumberLabelAttributeWithIndex:i];
        }
        
        // 2.6 添加到容器中
        [self addSubview:label];
        
        // 2.6 添加的labels数组中
        [_labels addObject:label];
    }
}

// 处理数字label
- (UILabel *)createCompactNumberLabelAttributeWithIndex:(NSInteger)index{
    
    // 0. 处理字体
    [self disposeCompactFontSize];
    
    // 1. 创建label
    UILabel *label = [[UILabel alloc] init];

    // 2. 判断是整数部分or小数部分
    if ( _randixLabelIndex==-1 || index < _randixLabelIndex) {//如果索引小于小数label的索引，为整数部分
        
        // 4. 设置字体
        label.font = [UIFont fontWithName:_fontName size:_integerFontSize];
        
        // 5. 设置整数部分的属性
        label.textAlignment = NSTextAlignmentRight;
        
        // 6. 设置属性
        label.numberOfLines = _rowOfLabel;
        
        // 7. 传入预先默认的数字文本内容
        label.text = _defaultNumbers;
        
        // 8. 处理label的行高
        [self setRowAttributewForLabel:label];
        
        // 9. 最后计算frame
        [label sizeToFit];
        CGFloat labelY = 0;
        CGFloat labelH = _containerViewF.size.height * (_rowOfLabel);
        CGFloat labelX = (_containerViewF.size.width - label.frame.size.width * _dataLenght)*0.5 + _compactIntegerLabelW * index;//无小数情况
        if ( _randixLabelIndex != -1 ) {//有小数情况
            labelX = (_containerViewF.size.width - _compactIntegerLabelW * _randixLabelIndex -_compactRadixLabelW * (_dataLenght - _randixLabelIndex - 1) - _radixSysbolLabelW )*0.5 + _compactIntegerLabelW * index;
        }
        label.frame = CGRectMake(labelX, labelY, _compactIntegerLabelW, labelH);
        
        
    }else{// 小数部分
      
        // 1. 设置字体
        label.font = [UIFont fontWithName:_fontName size:_decimalFontSize];
        
        // 2. 设置整数部分的属性
        label.textAlignment = NSTextAlignmentLeft;
        
        // 3. 设置属性
        label.numberOfLines = _rowOfLabel;
        
        // 4. 传入预先默认的数字文本内容
        label.text = _defaultNumbers;
        
        // 5. 处理行高
        [self setRowAttributewForLabel:label];
        
        // 6. 最后计算frame
        [label sizeToFit];
        UILabel *lastLabel = _labels[index - 1];
        CGFloat labelW = label.frame.size.width;
        CGFloat labelX = lastLabel.frame.origin.x + lastLabel.frame.size.width;
        CGFloat labelY = 0;
        CGFloat labelH = _containerViewF.size.height * _rowOfLabel;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
    }
    
    // 7. 返回label
    return label;
    
}

// 处理小数点label
- (UILabel *)createCompactRadixLabelAttributeWithIndex:(NSInteger)index{
    
    // 1. 计算一个label相对于当前容器大小的宽度
    CGFloat labelW = _radixSysbolLabelW;
    
    // 2 计算label的X,Y,H
    CGFloat labelX = 0;
    if ( index > 0) {//获取最后一个整数的label
        UILabel *lastLabel = _labels[index - 1];
        labelX = lastLabel.frame.origin.x + lastLabel.frame.size.width;
    }
    CGFloat labelY = 0;
    CGFloat labelH = _containerViewF.size.height * _rowOfLabel;
    
    // 3. 由于W,H确定控件字体大小 [fontSize = min(W，H)]
    CGFloat fontSize = 0;
    if ( _radixSymbolfontSize == 0 ) {
        fontSize = MIN(labelW, labelH);
    }else{
        fontSize = _radixSymbolfontSize;
    }
    
    // 4. 创建label
    UILabel *label = [[UILabel alloc] init];
    
    // 5. 设置属性
    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    label.font = [UIFont fontWithName:_fontName size:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    
    // 6. 传入数据
    label.text = @".\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.";
    
    // 7. 设置属性
    label.numberOfLines = _rowOfLabel;
    
    // 8. 处理行高
    [self setRowAttributewForLabel:label];
    
    // 9. 记录小数点label的索引
    _randixLabelIndex = index;
    
    // 10. 返回数据
    return label;
}


#pragma mark --------- 更新数据方式3
- (void)updateToNumberCompact:(NSString *)number integerFontSize:(CGFloat)integerSize decimalFontSize:(CGFloat)decimalSize{

    _integerFontSize = integerSize;
    _decimalFontSize = decimalSize;
    
    [self updateToNumberCompact:number];
}



#pragma mark - 传入数据、执行动画
- (void)setData:(NSString *)number animation:(BOOL)isAnimation{

    // 开始给label传入数据  [实质：移动label的frame]
    if ( isAnimation ) {
        [self setDateAnimation:number];
    }else{
        [self setDate:number];
    }

}

// 执行动画更新数据[数字有动画 + 小数点无动画]
- (void)setDateAnimation:(NSString *)number{
    
    int i = 0;
    for (UILabel *label in _labels) {
        
        // 1.0 获取要显示的数据
        NSString *showText = [number substringWithRange:NSMakeRange(i, 1)];
        
        // 1.1 一行label的高度
        CGFloat sigleRowLabelH = label.frame.size.height/(_rowOfLabel);
        
        // 1.2 判断要显示数据类型
        if ( [showText isEqualToString:@"."] ) {//是小数点
            
            CGFloat labelY = -(sigleRowLabelH * 0 + (label.frame.size.height - (label.font.ascender - label.font.descender) * _rowOfLabel)/(_rowOfLabel - 1)*0.5);
            label.frame = CGRectMake(label.frame.origin.x, labelY, label.frame.size.width, label.frame.size.height);
            
        }else{//是数字
            
            [UIView animateWithDuration:(self.animationDuration!=0)?self.animationDuration:1  animations:^{
                
                // 整数字体=小数字体：默认统一的逻辑处理整数部分和小数部分
                NSInteger number = [showText integerValue];
                [self removeToCernterForNumber:number label:label sigleRowH:sigleRowLabelH];
    
                // 整数字体!=小数字体：特殊处理处理整数部分和小数部分
                if ( _integerFontSize != _decimalFontSize ) {
                    
                    // 不存在小数部分、或当期为小数点.符号位则直接返回
                    if ( _randixLabelIndex == -1 || _randixLabelIndex==i  ) {return;}
                    
                    // 存在小数部分，特殊处理整数部分和小数部分
                    if ( i < _randixLabelIndex ) {
                        NSLog(@"%ld",(long)number);
                        [self removeToCernterForNumber:number label:label sigleRowH:sigleRowLabelH];
                    }else{
                        NSLog(@"%ld",(long)number);
                        [self removeToBottomForNumber:number label:label sigleRowH:sigleRowLabelH];
                    }
                    
                }

            }];
            
            
        }
        self.layer.masksToBounds = YES;
        
        i++;
        
    }

}

// 不执行动画更新数据[数字+小数 均无动画]
- (void)setDate:(NSString *)number{

    int i = 0;
    for (UILabel *label in _labels) {

        // 1.0 获取要显示的数据
        NSString *showText = [number substringWithRange:NSMakeRange(i, 1)];

        // 1.1 一行label的高度
        CGFloat sigleRowLabelH = label.frame.size.height/(_rowOfLabel);

        // 1.2 判断要显示数据类型
        if ( [showText isEqualToString:@"."] ) {//是小数点
            
            CGFloat labelY = -(sigleRowLabelH * 0 + (label.frame.size.height - (label.font.ascender - label.font.descender) * _rowOfLabel)/(_rowOfLabel - 1)*0.5);
            label.frame = CGRectMake(label.frame.origin.x, labelY, label.frame.size.width, label.frame.size.height);
            
        }else{//是数字
            
            NSInteger number = [showText integerValue];
            [self removeToCernterForNumber:number label:label sigleRowH:sigleRowLabelH];

        }
        self.layer.masksToBounds = YES;

        i++;

    }
}




#pragma mark - private
// 移除父控件中所有label 且 清空labels数组
- (void)removerAllLabes{
    
    // 清空labels数组中的所有label
    [_labels removeAllObjects];
    
    // 清空当前容器View中的所有数字label控件
    for (UILabel *label in self.subviews) {
        [label removeFromSuperview];
    }
}

// 判断是否需要重新创建label： YES需要  NO不需要
- (BOOL)isNeedAgainCreateLabelsWithNumber:(NSString *)number{
    
    // 逻辑：
    // [两次数据位数不同  || 两次数据位数相同且一个为整数一个为小数 ||
    // [labels数组为空] ||  两次数据都是小数且小数点的位数不同   认为 需要重新创建label
    
    // 1. 判断labels数组是否为空,为空则需要创建labels：返回YES
    if ( _labels == nil ) {
        return YES;
    }
    
    // 2. 判断新旧数据位数是否相同，不同需要重新创建labels：返回YES
    if ( number.length != _labels.count ) {
        return YES;
    }
    
    // 3. 对比上一次数据 和 这次数据，是否是位数相同且一个为整数一个为小数
    BOOL currentIsHaveRadix = NO;
    int  radixIndex = 0;
    for (int i=0; i<number.length; i++) {
        if ( [[number substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"."] ) {
            currentIsHaveRadix = YES;
            radixIndex = i;
            break;
        }
        currentIsHaveRadix = NO;
    }
    
    if ( (currentIsHaveRadix == NO && _randixLabelIndex!=-1) || (currentIsHaveRadix == YES && _randixLabelIndex==-1) ) {
        return YES;
    }
    
    // 4. 同为小数，判断小数点所在位置是否相同，不相同则返回YES
    if ( currentIsHaveRadix == YES || _randixLabelIndex!=-1 ) {
        
        if ( radixIndex != _randixLabelIndex ) {
            return YES;
        }
        
    }
    
    return NO;
}


// 跟传入的label设置每一行的行高
- (void)setRowAttributewForLabel:(UILabel *)label{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];
    [paragraphStyle setMinimumLineHeight:_containerViewF.size.height];
    [paragraphStyle setMaximumLineHeight:_containerViewF.size.height];
    paragraphStyle.lineHeightMultiple = 0;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    [label setAttributedText:attributedString];
    
    
    
}

// 处理是否存在小数
- (void)judgeDecimalForNumber:(NSString *)number{

    for (NSInteger i = 0; i<_dataLenght; i++) {
        
        // 2.0 获取显示数据
        NSString *showText = [number substringWithRange:NSMakeRange(i, 1)];
        
        // 2.0 获取显示数据
        if ( [showText isEqualToString:@"."] ) {//小数点，去创建小数点类型的label
            _randixLabelIndex = i;
            break;
        }else{//数字，去创建数字类型的label
            _randixLabelIndex = -1;
        }
    }
}

// 预先处理紧凑类型:整数、小数、小数点符号的字体
- (void)disposeCompactFontSize{

    // 整数部分
    if ( _integerFontSize == 0 ) {
        if ( self.compactFontSize != 0 ) {
            _integerFontSize = self.compactFontSize;
        }else{
            _integerFontSize = 15;
        }
    }
    
    // 小数部分
    if ( _decimalFontSize == 0 ) {
        _decimalFontSize = self.compactFontSize;
    }
    
    // 小数点符号部分 [默认等于整数部分字体]
    _radixSymbolfontSize = _integerFontSize;
    
}


// 预算紧凑类型：整数label 、 小数label 、小数点符号label的宽度
- (void)advanceCalculateCompactAllLabelWidth{

    // 0. 处理整数、小数、小数点符号字体大小
    [self disposeCompactFontSize];
    
    // 1. 判断是否存在小数
    if (_randixLabelIndex == -1) {//不是小数默认小数点符号label\小数label的宽度为0
        _radixSysbolLabelW = 0;
        _compactRadixLabelW = 0;
    }else{
        
        // 否则预算小数点label符号的宽度
        UILabel *sysbolLabel = [[UILabel alloc] init];
        sysbolLabel.font = [UIFont fontWithName:_fontName size:_radixSymbolfontSize];
        sysbolLabel.text = @".\n.\n.\n.\n.\n.\n.\n.\n.\n.\n.";
        sysbolLabel.numberOfLines = _rowOfLabel;
        [self setRowAttributewForLabel:sysbolLabel];
        [sysbolLabel sizeToFit];
        _radixSysbolLabelW = sysbolLabel.frame.size.width;
        
        // 预算小数部分label的宽度
        UILabel *radixLabel = [[UILabel alloc] init];
        radixLabel.font = [UIFont fontWithName:_fontName size:_decimalFontSize];
        radixLabel.numberOfLines = _rowOfLabel;
        radixLabel.text = _defaultNumbers;
        [self setRowAttributewForLabel:radixLabel];
        [radixLabel sizeToFit];
        _compactRadixLabelW = radixLabel.frame.size.width;
    }
    
    
    // 2. 预算整数部分
    UILabel *integerLabel = [[UILabel alloc] init];
    integerLabel.font = [UIFont fontWithName:_fontName size:_integerFontSize];
    integerLabel.numberOfLines = _rowOfLabel;
    integerLabel.text = _defaultNumbers;
    [self setRowAttributewForLabel:integerLabel];
    [integerLabel sizeToFit];
    _compactIntegerLabelW = integerLabel.frame.size.width;
    
}

// 算法：把字体移动到中间位置
- (void)removeToCernterForNumber:(NSInteger)number label:(UILabel *)label sigleRowH:(CGFloat)sigleRowLabelH{
    
    CGFloat labelY = -(sigleRowLabelH * number + (label.frame.size.height - (label.font.ascender - label.font.descender) * _rowOfLabel)/(_rowOfLabel - 1)*0.5);
    label.frame = CGRectMake(label.frame.origin.x, labelY, label.frame.size.width, label.frame.size.height);
}

// 算法：把字体移动到底部位置
- (void)removeToBottomForNumber:(NSInteger)number label:(UILabel *)label sigleRowH:(CGFloat)sigleRowLabelH{
    
    CGFloat labelY = -(sigleRowLabelH * number + (label.frame.size.height - (label.font.ascender - label.font.descender + (_integerFontSize - _decimalFontSize)*0.75) * _rowOfLabel)/(_rowOfLabel - 1)*0.5);
    label.frame = CGRectMake(label.frame.origin.x, labelY, label.frame.size.width, label.frame.size.height);
    NSLog(@"%f,%f,%f",label.font.ascender,label.font.descender,label.font.capHeight);
}


@end
