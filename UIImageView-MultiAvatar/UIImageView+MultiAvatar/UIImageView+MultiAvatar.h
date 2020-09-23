//
//  UIImageView+MultiAvatar.h
//  ZtCampus
//
//  Created by xx on 2019/10/24.
//  Copyright © 2019 hongtu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWidthScale     ([[UIScreen mainScreen] bounds].size.width/1080)


@interface UIImageView (MultiAvatar)

//设置群聊头像
- (void)ht_setImageWithURLStrArr:(NSArray *)arr;

@end

