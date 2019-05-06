//
//  ViewController.m
//  iOS_FontSize
//
//  Created by Hi_Arno on 2019/5/6.
//  Copyright © 2019 Hi_Arno. All rights reserved.
//

#import "ViewController.h"
#import "EXTextSizeView.h"

@interface ViewController ()<EXTextSizeViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    EXTextSizeView * bottomView = [EXTextSizeView loadTextSizeView];
    bottomView.delegate = self;
    bottomView.tabBar = YES;
    bottomView.items =  @[@(14.0),@(16.0),@(18.0),@(20.0),@(22.0),@(24.0)];
//    bottomView.items =  @[@"A",@"sdf",@"sd",@"sdfsf"];

    [self.view addSubview:bottomView];
    

}

- (void)textSizeAtObject:(id)object index:(NSInteger)index{
    NSLog(@"%@,%ld",object,(long)index);
    }
@end
