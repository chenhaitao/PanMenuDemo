//
//  ECViewController.m
//  PanMenuDemo
//
//  Created by 陈 海涛 on 13-5-30.
//  Copyright (c) 2013年 陈 海涛. All rights reserved.
//

#import "ECViewController.h"
#import "QuartzCore/QuartzCore.h"

#pragma mark - 配置参数
static const CGFloat LeftMenuMaxWidth = 120;
static const CGFloat MaxAlpha = 0.5;
static const CGFloat MinScale = 0.95;
static const CGFloat speedPixel = 0.0015;

#pragma mark -

@interface ECViewController ()

@property (nonatomic,strong) ECLeftMenuViewController *leftMenuViewController;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,strong) CAGradientLayer *leftLayer;
@end

@implementation ECViewController

- (void)viewDidLoad
{
     
    [super viewDidLoad];
	self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    [self.contentView addGestureRecognizer:self.panGestureRecognizer];
    
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenu"];
    [self addChildViewController:self.leftMenuViewController];
    CGRect frame = self.leftMenuViewController.view.frame;
    frame.origin = CGPointMake(0.0f, 0.0f);
    frame.size.width = LeftMenuMaxWidth + 50;
    self.leftMenuViewController.view.frame = frame;
    self.leftLayer = [CAGradientLayer layer];
    self.leftLayer.frame = self.leftMenuViewController.view.bounds;
    self.leftLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0.0f alpha:MaxAlpha].CGColor,(__bridge id)[UIColor colorWithWhite:0.0f alpha:MaxAlpha].CGColor];
    [self.leftMenuViewController.view.layer addSublayer:self.leftLayer];
    self.leftMenuViewController.view.transform = CGAffineTransformMakeScale(MinScale, MinScale);
    self.leftMenuViewController.view.hidden = YES;
    [self.view insertSubview:self.leftMenuViewController.view belowSubview:self.contentView];
    [self.leftMenuViewController didMoveToParentViewController:self];
    
}

-(void)handlePan:(UIPanGestureRecognizer *)sender
{
    static CGPoint last;
    CGFloat here = self.contentView.frame.origin.x;
    if (here > 0) {
        self.leftMenuViewController.view.hidden = NO;
       self.leftLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0.0f alpha:(LeftMenuMaxWidth - here)/(LeftMenuMaxWidth * MaxAlpha)].CGColor,(__bridge id)[UIColor colorWithWhite:0.0f alpha:(LeftMenuMaxWidth - here)/(LeftMenuMaxWidth * MaxAlpha)].CGColor];
        self.leftMenuViewController.view.transform = CGAffineTransformMakeScale(1-(LeftMenuMaxWidth - here)/LeftMenuMaxWidth *(1-MinScale), 1 - (LeftMenuMaxWidth - here)/LeftMenuMaxWidth *(1-MinScale));
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        last = [sender locationInView:self.view];
        self.leftMenuViewController.view.userInteractionEnabled = NO;
        //....
    }else if(sender.state == UIGestureRecognizerStateChanged){
        CGPoint now = [sender locationInView:self.view];
        CGFloat movingDistance = now.x - last.x;
        last = now;
        if (fabs(here) <= LeftMenuMaxWidth) {
            [UIView animateWithDuration:(movingDistance*speedPixel) animations:^{
                self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, movingDistance,0);
            }];
        }
    }else if(sender.state == UIGestureRecognizerStateEnded){
        self.leftMenuViewController.view.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = NO;
        __block  CGFloat movingDistance = fabsf(here);
        [UIView animateWithDuration:(movingDistance*speedPixel) animations:^{
            if(movingDistance > LeftMenuMaxWidth){
                movingDistance = LeftMenuMaxWidth;
            }
            if (here > LeftMenuMaxWidth / 2 ) {
                self.contentView.transform = CGAffineTransformMakeTranslation(LeftMenuMaxWidth, 0);
            }else if(here < LeftMenuMaxWidth / 2){
                self.contentView.transform = CGAffineTransformIdentity;
            }else{
                self.contentView.transform = CGAffineTransformIdentity;
            }
            
        } completion:^(BOOL finish){
            last = CGPointZero;
            self.view.userInteractionEnabled = YES;
            if (self.contentView.frame.origin.x == 0) {
                self.leftMenuViewController.view.hidden = YES;
            }
        }];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.view.window == nil) {
        [self.leftMenuViewController didMoveToParentViewController:nil];
        [self.leftMenuViewController.view removeFromSuperview];
        [self.leftMenuViewController removeFromParentViewController];
    }
}

@end



























































































