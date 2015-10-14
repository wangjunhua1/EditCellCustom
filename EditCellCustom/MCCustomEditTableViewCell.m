//
//  MCCustomEditTableViewCell.m
//  EditCellCustom
//  Created by mark on 15/10/11.
//  Copyright © 2015年 mark. All rights reserved.
//  自定义带有侧滑效果的cell

#import "MCCustomEditTableViewCell.h"
#import "UIView+FrameAdjust.h"
#import "NSString+StringSize.h"
#import "MCEditCellDefine.h"

@interface MCCustomEditTableViewCell() <MCRightViewDelegate,UIGestureRecognizerDelegate>

/**
 *  手势识别器
 */
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;

/**
 *  纪录contenView 的最终x值
 */
@property (assign, nonatomic) CGFloat contentViewX;
/**
 *  手势平移的点
 */
@property (nonatomic,assign) CGPoint translatedPoint;

@end

@implementation MCCustomEditTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.openAnimatedDuration = 0.3;
        self.closeAnimatedDuration = 0.3;
        //初始化rightView
        [self setupRightView];
        
        //添加手势
        [self addPanGesture];
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeRightView) name:@"MCCloseRightView" object:nil];

    }
    return self;
}
//初始化rightView
- (void)setupRightView{
    MCRightView *rightView = [[MCRightView alloc]init];
    rightView.delegate = self;
    [self insertSubview:rightView belowSubview:self.contentView];
    self.rightView = rightView;
    self.rightView.hidden = YES;
    
}
//添加手势
- (void)addPanGesture{
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
//    panGesture.maximumNumberOfTouches = 1;
    [self.contentView addGestureRecognizer:panGesture];
    self.panGesture = panGesture;

}


// 给rightView传值
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.rightView.indexPath = indexPath;
}


// 滑动contentView触发的方法
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer{
    
    //平移的距离
    CGPoint translatedPoint = [recognizer translationInView:self.contentView];
    self.translatedPoint = translatedPoint;
    CGFloat rightViewCenterX = self.rightView.rightViewWidth/2;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.translatedPoint.x<=0) {
                [self.delegate rightViewWillShowInCell:self];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //向左滑动时
            if (translatedPoint.x<0.0) {
                self.rightView.hidden = NO;
                self.contentView.frame = CGRectMake(translatedPoint.x, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            }

        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self doTheEndThings:(CGFloat)rightViewCenterX];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self doTheEndThings:(CGFloat)rightViewCenterX];

        }
            break;
        default:
            break;
    }
}


// 滑动结束应执行的事情
- (void)doTheEndThings:(CGFloat)rightViewCenterX{

    //平移的距离大于等于right view的一半 执行动画完全显示
    if (-self.translatedPoint.x>=rightViewCenterX) {
        [self.delegate rightViewDidShowInCell:self];
        [UIView animateWithDuration:self.openAnimatedDuration animations:^{
            self.contentView.frame = CGRectMake(-self.rightView.rightViewWidth, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            self.contentViewX = -self.rightView.rightViewWidth;
            
        } completion:^(BOOL finished) {
            //通知rightview完全显示
            [self.delegate rightViewDidShowInCell:self];
            
        }];
    }
    
    //平移的距离小于right view的一半 执行动画关闭rightview
    if (-self.translatedPoint.x<rightViewCenterX) {
        
        [self.delegate rightViewWillHideInCell:self];
        [UIView animateWithDuration:self.closeAnimatedDuration animations:^{
            self.contentView.frame = CGRectMake(0, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            self.contentViewX = 0;
            
        } completion:^(BOOL finished) {
            //通知rightview完全隐藏
            [self.delegate rightViewDidHideInCell:self];
            self.rightView.hidden = YES;
            
        }];
    }
}


// 关闭显示的cell
- (void)closeRightView{
    
    [UIView animateWithDuration: self.closeAnimatedDuration animations:^{
        self.contentView.frame = CGRectMake(0., 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        self.contentViewX= 0.0;//赋值为0 防止重用时contentViewX 还是原来滑东的值
        
    } completion:^(BOOL finished) {
        
        self.rightView.hidden = YES;
        
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(self.contentViewX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.contentViewX= 0.0;

}


// 给rightView添加btn
- (void)addRightBtnWith:(NSString *)title backgroundColor:(UIColor *)color rightViewHeight:(CGFloat)rightViewH{
    [self.rightView addRightViewBtnWith:title backgroundColor:color rightViewHeight:rightViewH];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (!selected) {
        self.rightView.hidden = YES;
        [super setSelected:selected animated:animated];
    }
}

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return self.gestureBengin;
}


#pragma mark - MCRightViewDelegate

- (void)rightView:(MCRightView *)rightView didClickBtn:(UIButton *)btn indexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(customEditTableViewCell:didClickRightBtn: indexPath:)]) {
        [self.delegate customEditTableViewCell:self didClickRightBtn:btn indexPath:indexPath];
    }
    
}


@end





@interface MCRightView ()
/**
 *  rightView的高度
 */
@property (nonatomic,assign) CGFloat rightViewH;

@end
@implementation MCRightView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


//向rightView内部添加btn
- (void)addRightViewBtnWith:(NSString *)title backgroundColor:(UIColor *)backgroundColor rightViewHeight:(CGFloat)rightViewH{
    
    self.rightViewH = rightViewH;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:backgroundColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:kRightButtonFont];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnArray addObject:btn];
    [self addSubview:btn];
}

//(每个btn的位置 self的宽高)
- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int j = 0; j<self.btnArray.count; j++) {
        
        UIButton *button = self.btnArray[j];
        
        CGSize btnSizeLabel = [button.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:kRightButtonFont] maxSize:CGSizeMake(MAXFLOAT, self.rightViewH)];
        CGSize btnSize= CGSizeMake(btnSizeLabel.width+kBtnPadding, btnSizeLabel.height);
        
        CGFloat rightViewWTem ;
        rightViewWTem = rightViewWTem +btnSize.width;
        _rightViewWidth =rightViewWTem;
        
    }
    self.frame = CGRectMake(kScreenW-self.rightViewWidth, 0, self.rightViewWidth, self.rightViewH);
    
    CGFloat rightViewX =self.rightViewWidth ;
    
    for (int j = 0; j<self.btnArray.count; j++) {
        
        UIButton *button = self.btnArray[j];
        
        CGSize btnSizeLabel = [button.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:kRightButtonFont] maxSize:CGSizeMake(MAXFLOAT, self.rightViewH)];
        CGSize btnSize= CGSizeMake(btnSizeLabel.width+kBtnPadding, btnSizeLabel.height);
        
        CGFloat btnX = rightViewX - btnSize.width;
        rightViewX = btnX;
        button.frame = CGRectMake(rightViewX, 0, btnSize.width, self.rightViewH);
        
    }
}

//监听rightView内部btn的点击
- (void)buttonClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(rightView:didClickBtn:indexPath:)]) {
        [self.delegate rightView:self didClickBtn:btn indexPath:self.indexPath];
    };
}

#pragma mark - 懒加载初始化数据设置
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        
        _btnArray = [[NSMutableArray alloc]init]  ;
    }
    
    return _btnArray;
}


@end

