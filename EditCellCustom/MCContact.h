//
//  MCContact.h
//  EditCell
//
//  Created by mark on 15/10/10.
//  Copyright © 2015年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCContact : NSObject <NSCopying>
/**
 *  联系人名字
 */
@property (nonatomic,copy) NSString *name;

/**
 *  联系人描述
 */
@property (nonatomic,copy) NSString *desc;

/**
 *  联系人头像
 */
@property (nonatomic,copy) NSString *image;
//@property (nonatomic,strong) NSNumber *rowActiontag;

@property (nonatomic,assign) int rowActiontag;
@end
