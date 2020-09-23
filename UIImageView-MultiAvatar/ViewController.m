//
//  ViewController.m
//  UIImageView-MultiAvatar
//
//  Created by xx on 2019/10/25.
//  Copyright © 2019 xx. All rights reserved.
//

#import "ViewController.h"

#import "UIImageView+MultiAvatar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (NSInteger i = 0; i < 9; i++) {
        
        UIImageView *avatar = [UIImageView new];
        
        avatar.layer.cornerRadius = 12*kWidthScale;
        avatar.layer.masksToBounds = YES;
        avatar.backgroundColor = [UIColor redColor];
        
        NSInteger col = i % 3;//列
        NSInteger row = i / 3;//行
        
        CGFloat x = 50 * (col+1) + 121*kWidthScale * col;
        CGFloat y = 50 + (121*kWidthScale + 10) * row;
        
        avatar.frame = CGRectMake(x, y, 121*kWidthScale, 121*kWidthScale);
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (NSInteger j = 0; j <= i; j++) {
            
            [tempArr addObject:@""];//头像url字符串
        }
        
        [avatar ht_setImageWithURLStrArr:tempArr.copy];
        
        [self.view addSubview:avatar];
    }
}


@end
