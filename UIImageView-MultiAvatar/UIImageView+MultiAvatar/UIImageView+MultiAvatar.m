//
//  UIImageView+MultiAvatar.m
//  ZtCampus
//
//  Created by hongtu on 2019/10/24.
//  Copyright © 2019 hongtu. All rights reserved.
//

#import "UIImageView+MultiAvatar.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (MultiAvatar)

//设置群聊头像
- (void)ht_setImageWithURLStrArr:(NSArray *)arr {
    
    if (arr.count <= 0) {
        return;
    }
    else if (arr.count > 9) {
        
        //只显示9个头像
        NSMutableArray *tempArr = [NSMutableArray array];
        
        NSInteger index = 0;
        
        for (NSString *urlStr in arr) {
            
            if (index < 9) {
                
                [tempArr addObject:urlStr];
            }
            
            index++;
        }
        
        arr = tempArr.copy;
    }

    //下载小头像
    [self downImageWith:arr];
}

//下载小头像
- (void)downImageWith:(NSArray *)arr {
    
       SDWebImageManager *manager = [SDWebImageManager sharedManager];
       
       NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:arr.count];
       
       //调度组
       dispatch_group_t group = dispatch_group_create();
       
       for (NSString *urlStr in arr) {
           
           NSURL *url = [NSURL URLWithString:urlStr];
    
           dispatch_group_enter(group);
           
           dispatch_async(dispatch_get_global_queue(0, 0), ^{
               
               //下载头像
               [manager loadImageWithURL:url options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                   
               } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                  
                   if (image) {
                       
                       [tempArr addObject:image];
                   }
                   
                   dispatch_group_leave(group);
               }];
           });
       }
       
       dispatch_group_notify(group, dispatch_get_main_queue(), ^{
           
           //所有小头像绘制到一张图片上
           UIImage *avatar = [self drawGroupAvatarWith:tempArr.copy];
           self.image = avatar;
       });
}

//绘制群头像
- (UIImage *)drawGroupAvatarWith:(NSArray *)arr {
    
    //群头像大小
    CGSize avatarSize = CGSizeMake(121*kWidthScale, 121*kWidthScale);
    
    UIGraphicsBeginImageContext(avatarSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //背景色
    UIColor *bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 121*kWidthScale, 121*kWidthScale));
    
    //获取每个小头像的rect
    NSArray *rectArr = [self calculateEachRectWithCount:arr.count];
    
    NSInteger index = 0;
    
    for (UIImage *image in arr) {
        
        if (index > rectArr.count - 1) {
            
            break;
        }
        
        CGRect rect = CGRectFromString([rectArr objectAtIndex:index]);
        
        //绘制小头像
        [image drawInRect:rect];
        
        index++;
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//获取每个小头像的rect
- (NSArray *)calculateEachRectWithCount:(NSInteger)count {
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:count];
    
    if (count == 1) {
        
        CGRect rect = CGRectMake(33*kWidthScale, 33*kWidthScale, 55*kWidthScale, 55*kWidthScale);
        
        [tempArr addObject:NSStringFromCGRect(rect)];
    }
    else {
        
        [self getRects:tempArr count:(int)count];
    }

    return tempArr.copy;
}


//计算每个小头像的位置
- (void)getRects:(NSMutableArray *)array count:(int)count {
    
    int row_num = 0;//行数
    int col_num = 0;//列数
    
    CGFloat margin = 5*kWidthScale;
    CGFloat avatarWH = 121*kWidthScale;
    
    if (count == 2) {
        
        row_num = 1;
        col_num = 2;
    }
    else if (count <= 4) {
        
        row_num = col_num = 2;
    }
    else {
        
        col_num = 3;
        row_num = (count - 1) / col_num + 1;
    }
    
    CGFloat width = (avatarWH - margin * (col_num + 1)) / col_num;
    CGFloat origin_y = (avatarWH - width * row_num - margin * (row_num - 1)) / 2;
    
    int remainder = count % col_num;//第一行的个数（不满一行）
    
    if (remainder == 0) {
        
        //按九宫格计算
        for (int i = 0; i < count; i++) {
            
            int col = i % col_num;//列
            int row = i / col_num;//行
            
            CGFloat x = margin * (col+1) + width * col;
            CGFloat y = origin_y + (width + margin) * row;
            
            CGRect rect = CGRectMake(x, y, width, width);
            
            [array addObject:NSStringFromCGRect(rect)];
        }
    }
    else {
        
        //先计算第一行(第一行不铺满,只有1个或者2个)
        CGFloat constant_x = (col_num - remainder) * width / 2;
        
        for (NSInteger i = 0; i < remainder; i++) {
            
            int col = i % count;//列
            
            CGRect rect = CGRectMake(constant_x + margin * (col+1) + width * col, origin_y, width, width);
            
            [array addObject:NSStringFromCGRect(rect)];
        }
        
        //余下的按照九宫格计算
        for (int i = 0; i < count - remainder; i++) {
            
            int col = i % col_num;//列
            int row = i / col_num;//行
            
            CGRect rect = CGRectMake(margin * (col+1) + width * col, origin_y + (width + margin) * (row + 1), width, width);
            
            [array addObject:NSStringFromCGRect(rect)];
        }
    }
}

@end
