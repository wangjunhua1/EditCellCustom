//
//  MCCustomEditTableViewCell.h
//  EditCellCustom
//
//  Created by mark on 15/10/11.
//  Copyright © 2015年 mark. All rights reserved.
//  自定义带有侧滑效果的cell

#import <UIKit/UIKit.h>

@class MCCustomEditTableViewCell,MCRightView;
typedef void (^RightOption)(UIButton * , NSUInteger);

@protocol MCCustomEditTableViewCellDelegate <NSObject>

@optional
/**
 * 监听right view里面btn的点击
 */
- (void)customEditTableViewCell:(MCCustomEditTableViewCell *)customEditTableViewCell didClickRightBtn:(UIButton *)btn indexPath:(NSIndexPath *)indexPath;

/**
 *  将要显示
 */
- (void)rightViewWillShowInCell:(MCCustomEditTableViewCell *)cell;
/**
 *  完全显示
 */
- (void)rightViewDidShowInCell:(MCCustomEditTableViewCell *)cell;
/**
 *  将要隐藏
 */
- (void)rightViewWillHideInCell:(MCCustomEditTableViewCell *)cell;
/**
 *  完全隐藏
 */
- (void)rightViewDidHideInCell:(MCCustomEditTableViewCell *)cell;

@end


@interface MCCustomEditTableViewCell : UITableViewCell

/**
 *  纪录第几个cell
 */
@property (nonatomic,strong) NSIndexPath *indexPath;

/**
 *  rightView
 */
@property (nonatomic,weak) MCRightView *rightView;

/**
 *  是否允许编辑(即手势是否开始)默认是no
 */
@property (nonatomic,assign,getter=isGestureBengin) BOOL gestureBengin;

/**
 *  rightView的高度
 */
@property (nonatomic,assign) CGFloat rightViewHeight;

/**
 *  打开的动画时长
 */
@property (nonatomic,assign) CGFloat openAnimatedDuration;
/**
 *  关闭的动画时长
 */
@property (nonatomic,assign) CGFloat closeAnimatedDuration;

@property (nonatomic,weak) id<MCCustomEditTableViewCellDelegate> delegate;

/**
 *  给rightView添加btn
 */
- (void)addRightBtnWith:(NSString *)title backgroundColor:(UIColor *)color rightViewHeight:(CGFloat)rightViewH;

/**
 *  关闭显示的cell
 */
- (void)closeRightView;

@end


@class MCRightView;

@protocol MCRightViewDelegate <NSObject>
@optional
/**
 *  点击rightview 里面的btn 触发的代理
 *
 *  @param btn       点击的btn
 *  @param rowNum    点击的第几行
 */
- (void)rightView:(MCRightView *)rightView didClickBtn:(UIButton *)btn indexPath:(NSIndexPath *)indexPath;

@end


@interface MCRightView : UIView
/**
 *  纪录外界给rightview添加的个数
 */
@property (nonatomic,strong) NSMutableArray *btnArray;
/**
 *  rightview的宽度
 */
@property (nonatomic,assign,readonly) CGFloat rightViewWidth;
/**
 *  indexPath 用于点击纪录点击第几个rightView
 */
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<MCRightViewDelegate> delegate;
/**
 *  给rightview添加btn
 *
 *  @param title           btn 里的文字设置
 *  @param backgroundColor btn 的背景颜色
 *  @param rightViewH      rightView的高度
 */
- (void)addRightViewBtnWith:(NSString *)title backgroundColor:(UIColor *)backgroundColor rightViewHeight:(CGFloat)rightViewH;

@end

