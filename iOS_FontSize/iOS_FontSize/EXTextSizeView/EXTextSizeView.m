//
//  EXTextSizeView.m
//  EXECUTOR
//
//  Created by Hi_Arno on 2019/4/29.
//  Copyright © 2019 Hi_Arno. All rights reserved.
//

#import "EXTextSizeView.h"

#define IPHONE_X \
        ({BOOL isPhoneX = NO;\
            if (@available(iOS 11.0, *)) {\
                isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
            }\
        (isPhoneX);})

@implementation EXTextSizeView

+ (EXTextSizeView *)loadTextSizeView{
    EXTextSizeView * view = [[EXTextSizeView alloc]init];
    return view;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
            CGRect rect = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 140);
            if (IPHONE_X && !self.tabBar) {
                rect.size.height = 174.0;
            }
            self.frame = rect;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.backgroundColor = [UIColor whiteColor];

    
    CGRect textRect = CGRectMake(0, 20, self.frame.size.width, 30);
    
    UIView * textView = [[UIView alloc]initWithFrame:textRect];
    [self addSubview:textView];

    CGRect minRect = CGRectMake(18, 0, 30, 30);
    
    UILabel *minLabel = [[UILabel alloc]initWithFrame:minRect];
    minLabel.text = @"A";
    minLabel.font = [UIFont systemFontOfSize:14.0];
    [textView addSubview:minLabel];
    
    CGRect maxRect = CGRectMake(CGRectGetMaxX(textRect)-30, 0, 30, 30);

    UILabel *maxLabel = [[UILabel alloc]initWithFrame:maxRect];
    maxLabel.text = @"A";
    maxLabel.font = [UIFont systemFontOfSize:24.0];
    [textView addSubview:maxLabel];
    
    
    
    CGRect defRect =  CGRectMake(CGRectGetMaxX(minRect)+25, 0, 60, 30);
    
    UILabel *defLabel = [[UILabel alloc]initWithFrame:defRect];
    defLabel.text = @"default";
    defLabel.font = [UIFont systemFontOfSize:16.0];
    defLabel.textColor = [UIColor grayColor];
    [textView addSubview:defLabel];
    
    CGRect sliderRect = CGRectMake(0, CGRectGetMaxY(textRect), CGRectGetWidth(textRect), 40);
    
    EXSlider * slider = [[EXSlider alloc]initWithFrame:sliderRect];
    slider.target = self;
    slider.action = @selector(sliderAtIndex:);
    slider.max = self.items.count;
    slider.select = 2;
    [self addSubview:slider];
    
}

- (void)sliderAtIndex:(id) index{
    
    NSInteger i =  [index integerValue];
    
    if ([self.delegate respondsToSelector:@selector(textSizeAtObject:index:)]) {
        [self.delegate textSizeAtObject:self.items[i] index:i];
    }
}
@end

@implementation EXSlider{
    NSMutableArray * _rects;
    CGFloat _marginx;
}
- (instancetype)initWithFrame:(CGRect)frame
{   frame.size.height = 40;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self loadRect];

}
- (void)loadRect{
    //1 间隔
    _marginx = 20.0;
    CGFloat distance = (self.frame.size.width - 40) / (self.max-1);
    CGSize size = CGSizeMake(distance, 40);

    _rects = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.max; i ++ ) {
        CGPoint point = CGPointMake(distance * i - (distance*0.5)+_marginx , 0);
        CGRect rects = (CGRect){point,size};
        [_rects addObject:[NSValue valueWithCGRect:rects]];
    }
    
    CGRect rect = [_rects[3] CGRectValue];
    
//    UIView * view = [[UIView alloc]initWithFrame:rect];
//    view.backgroundColor = [UIColor yellowColor];
//    [self addSubview:view];
    
}

-(void)drawRect:(CGRect)rect{

    
    NSInteger cont = self.max;
    
    CGFloat centery = rect.size.height * 0.5;
    CGFloat width = rect.size.width - (_marginx * 2);
    
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 设置线条宽度
    CGContextSetLineWidth(context, 0.5);
    // 设置颜色
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGPoint aPoints[2];
    aPoints[0] = CGPointMake(_marginx, centery);
    aPoints[1] = CGPointMake((rect.size.width - _marginx), centery);
    //添加线 points[]坐标数组，和count大小
    CGContextAddLines(context, aPoints, 2);
    //根据坐标绘制路径

    CGFloat lineWidth = width / (cont -1);
    CGPoint bPoint[cont];
    CGPoint ePoint[cont];
    for (int i = 0; i < cont; i++) {
        bPoint[i] = CGPointMake(lineWidth * i + _marginx, centery-5);
        ePoint[i] = CGPointMake(lineWidth * i + _marginx, centery+5);
        CGContextMoveToPoint(context, bPoint[i].x, bPoint[i].y);
        CGContextAddLineToPoint(context, ePoint[i].x, ePoint[i].y);
    }

    CGContextDrawPath(context, kCGPathStroke);

    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetShadow(context,(CGSize){0.5,0.5}, 3.0);
    CGContextAddArc(context, bPoint[self.select - 1].x, centery, 14, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for (NSUInteger i = 0; i < _rects.count; i++){
        NSValue * value = _rects[i];
        CGRect rect = [value CGRectValue];
        if (CGRectContainsPoint(rect, point)) {
            self.select = i+1;
            [self setNeedsDisplay];
            if ([self.target respondsToSelector:self.action] && self.target && self.action) {
                ((void (*)(id, SEL,NSNumber*))[self.target methodForSelector:self.action])(self.target, self.action,@(i));
//                [self.target performSelector:self.action withObject:@(i)];
            }
            break;
        }
    }

}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (NSUInteger i = 0; i < _rects.count; i++){
        NSValue * value = _rects[i];
        CGRect rect = [value CGRectValue];
        if (CGRectContainsPoint(rect, point)) {
            self.select = i+1;
            [self setNeedsDisplay];
            if ([self.target respondsToSelector:self.action] && self.target) {
                ((void (*)(id, SEL,NSNumber*))[self.target methodForSelector:self.action])(self.target, self.action,@(i));

//                [self.target performSelector:self.action withObject:@(i)];
            }
            break;
        }
    }
}

@end
