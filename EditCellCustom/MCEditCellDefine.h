

//
//  MCEditCellDefine.h
//  EditCellCustom
//
//  Created by mark on 15/10/14.
//  Copyright © 2015年 mark. All rights reserved.
//

#ifndef MCEditCellDefine_h
#define MCEditCellDefine_h

// btn 的字体大小
#define kRightButtonFont 17
//btn 的内部Padding
#define kBtnPadding 10
#define kScreenW ([UIScreen mainScreen].bounds.size.width)
// 文件路径
#define MCContactsFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"contacts.data"]

#define kRowHeight 50
#endif /* MCEditCellDefine_h */
