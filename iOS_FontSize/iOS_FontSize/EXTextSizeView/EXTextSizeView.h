//
//  EXTextSizeView.h
//  EXECUTOR
//
//  Created by Hi_Arno on 2019/4/29.
//  Copyright © 2019 Hi_Arno. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol EXTextSizeViewDelegate <NSObject>

- (void)textSizeAtObject:(id)object index:(NSInteger)index;

@end

@interface EXTextSizeView : UIView

@property (nonatomic, assign) BOOL tabBar;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<EXTextSizeViewDelegate> delegate;

+ (EXTextSizeView *) loadTextSizeView;
@end



@interface EXSlider : UIView
// 最大值
@property (nonatomic, assign) NSInteger max;
// 默认值 不能超过最大值
@property (nonatomic, assign) NSInteger select;

@property (nonatomic) SEL action;

@property (nonatomic, weak) id target;

@end

NS_ASSUME_NONNULL_END
