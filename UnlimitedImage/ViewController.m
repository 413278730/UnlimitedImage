//
//  ViewController.m
//  UnlimitedImage
//
//  Created by king on 15/11/28.
//  Copyright © 2015年 djl. All rights reserved.
//

#import "ViewController.h"

#define IMAGEVIEW_TAG 2000

@interface ViewController ()<UIScrollViewDelegate>
@end

@implementation ViewController
{
    UIScrollView* _scrollView;
    NSMutableArray* _imageArray;
    NSTimer* _timer;//定时器
    UIPageControl* _pageControl;
    NSInteger _currentImageIndex;//当前显示图片
    BOOL _isFirst;//标记定时器方法是否是第一次调用
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageArray = [[NSMutableArray alloc] initWithArray:@[@"0.jpg",@"1.jpg",@"2.jpg",@"4.jpg"]];
    
    //创建UI
    [self createScrollView];//滚动视图
    [self createImageView];//图片
    [self createPageControl];//pagecontrol
    [self makeTimer];//定时器
}
#pragma mark 创建UI
- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width*3, 150)];
    [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0)];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.pagingEnabled = YES;
    //这个方法必须关闭，否则滑动时又白边效果
    _scrollView.bounces = NO; 
    [self.view addSubview:_scrollView];
}
- (void)createPageControl
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - (_imageArray.count*15), 130, _imageArray.count*30, 30)];
    _pageControl.numberOfPages = _imageArray.count;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:_pageControl];
}
//创建imageView，并且贴上初始图片
- (void)createImageView
{
    _currentImageIndex = 0;
    for (int i = 0; i < 3; i ++) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, 160)];
        imageView.tag = IMAGEVIEW_TAG + i;
        if (i == 1) {
            imageView.image = [UIImage imageNamed:_imageArray[0]];
        }else if (i == 0){
            imageView.image = [UIImage imageNamed:[_imageArray lastObject]];
        }else{
            imageView.image = [UIImage imageNamed:_imageArray[1]];
        }
        [_scrollView addSubview:imageView];
    }
    
}
- (void)makeTimer
{
    _isFirst = YES;
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate distantPast] interval:2 target:self selector:@selector(scrollAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
- (void)changeImage:(NSInteger)currtenIndex
{
    //提取imageView
    UIImageView* imageView = (UIImageView*)[_scrollView viewWithTag:IMAGEVIEW_TAG + 0];
    UIImageView* imageView1 = (UIImageView*)[_scrollView viewWithTag:IMAGEVIEW_TAG + 1];
    UIImageView* imageView2 = (UIImageView*)[_scrollView viewWithTag:IMAGEVIEW_TAG + 2];
    
    //三种情况转换imageView上的图片
    if (currtenIndex == _imageArray.count-1) {
        imageView1.image = [UIImage imageNamed:_imageArray[_currentImageIndex]];
        imageView2.image = [UIImage imageNamed:_imageArray[0]];
        imageView.image = [UIImage imageNamed:_imageArray[_currentImageIndex-1]];
    }else if (currtenIndex == 0){
        imageView1.image = [UIImage imageNamed:_imageArray[_currentImageIndex]];
        imageView2.image = [UIImage imageNamed:_imageArray[_currentImageIndex+1]];
        imageView.image = [UIImage imageNamed:[_imageArray lastObject]];
    }else{
        imageView1.image = [UIImage imageNamed:_imageArray[_currentImageIndex]];
        imageView2.image = [UIImage imageNamed:_imageArray[_currentImageIndex+1]];
        imageView.image = [UIImage imageNamed:_imageArray[_currentImageIndex-1]];

    }
}
#pragma mark UIScrollViewDelegate
//关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
}
//开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self makeTimer];
}
//定时器需要走的方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGPoint scrollViewPoint = _scrollView.contentOffset;
    if (scrollViewPoint.x > self.view.frame.size.width) {
        if (_currentImageIndex == _imageArray.count - 1) {
            _currentImageIndex = 0;
        }else{
            _currentImageIndex ++;
        }
    }else if(scrollViewPoint.x < self.view.frame.size.width){
        if (_currentImageIndex == 0) {
            _currentImageIndex = _imageArray.count-1;
        }else{
            _currentImageIndex --;
        }
    }
    //始终显示中间那张imageView
    [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
    [self changeImage:_currentImageIndex];//调整图片
    _pageControl.currentPage = _currentImageIndex;
}
//拖拽需要走的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint scrollViewPoint = _scrollView.contentOffset;
    if (scrollViewPoint.x > self.view.frame.size.width) {
        if (_currentImageIndex == _imageArray.count - 1) {
            _currentImageIndex = 0;
        }else{
            _currentImageIndex ++;
        }
    }else if(scrollViewPoint.x < self.view.frame.size.width){
        if (_currentImageIndex == 0) {
            _currentImageIndex = _imageArray.count-1;
        }else{
            _currentImageIndex --;
        }
    }
    //始终显示中间那张imageView
    [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
    [self changeImage:_currentImageIndex];//调整图片
    _pageControl.currentPage = _currentImageIndex;
}
#pragma mark 事件
- (void)scrollAction
{
    if (_isFirst == NO) {
        CGPoint scrollViewPoint = _scrollView.contentOffset;
        [_scrollView setContentOffset:CGPointMake(scrollViewPoint.x+self.view.frame.size.width, 0) animated:YES];
    }else{
        _isFirst = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
