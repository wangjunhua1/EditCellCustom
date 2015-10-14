//
//  MCContact.m
//  EditCell
//
//  Created by mark on 15/10/10.
//  Copyright © 2015年 mark. All rights reserved.
//

#import "MCContact.h"

@implementation MCContact

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.image forKey:@"image"];
//    [encoder encodeObject:self.rowActiontag forKey:@"rowActiontag"];

    [encoder encodeObject:[NSNumber numberWithInt:self.rowActiontag]forKey:@"rowActiontag"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.image = [decoder decodeObjectForKey:@"image"];
//        self.rowActiontag = [decoder decodeObjectForKey:@"rowActiontag"];

        self.rowActiontag = [[decoder decodeObjectForKey:@"rowActiontag"] intValue];

    }
    return self;
}

//- (id)copyWithZone:(nullable NSZone *)zone{
//    if ([super copy]) {
//        
//    }
//    return self;
//}

@end
