//
//  Image.m
//  Gallery
//
//  Created by Tim Boisvert on 2/21/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Image.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MainNav.h"

@implementation Image

@synthesize curatorId, imageId, curatorName, curatorImageCount, photographerNames, secondaryTextLabel, photographerNameLabel, curatorButton, displayButton, scrollView, tapCover;

int timerCount;
int MAX_SECONDS_BEFORE_GOING_BACK_TO_CURATOR = 30;
NSTimer *timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [photographerNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    [secondaryTextLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:17]];
    

    NSMutableArray *imgViews = [(MainNav *)self.navigationController imgViews];
    NSMutableArray *tempImgViews = [NSMutableArray new];
    
    //add the images
    for(int i = 1; i <= curatorImageCount; i++) {
        if(imgViews == nil) {
            NSString *fileName = [NSString stringWithFormat:@"Full-%@-%d.jpg", curatorId, i];
            UIImage *img = [UIImage imageNamed:fileName];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            [imgView setContentMode:UIViewContentModeScaleAspectFit];
            [imgView setFrame:CGRectMake((i-1) * 836, 0, 836, 554)];
            [tempImgViews addObject:imgView];
            [scrollView addSubview:imgView];
        } else {
            [scrollView addSubview:[imgViews objectAtIndex:i-1]];
        }
    }
    [scrollView setContentSize:CGSizeMake(836 * curatorImageCount, 554)];
    
    if(tempImgViews.count > 0) {
        [(MainNav *)self.navigationController setImgViews:tempImgViews];
    }
    
    //scroll to this index
    [scrollView scrollRectToVisible:CGRectMake((imageId-1) * 836, 0, 836, 554) animated:NO];
    
    self.photographerNameLabel.text = [[photographerNames objectAtIndex:(imageId -1)] uppercaseString];
    self.secondaryTextLabel.text = [NSString stringWithFormat:@"from %@'s curated collection", [curatorName uppercaseString]];
    
    [UIView animateWithDuration:0.25 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        tapCover.alpha = 0.0;
    } completion:^(BOOL finished) {}];
}

-(void)viewDidAppear:(BOOL)animated {
    [self startTimer];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self stopTimer];
}

#pragma mark -
#pragma Buttons and Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowCurator"]) {
        [[segue destinationViewController] setCuratorId:curatorId];
    } 
}

-(IBAction)handleBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)handleProjectButton:(id)sender {
    int pageNumber = (int)(scrollView.contentOffset.x / 836);
    NSString *hostName = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"hostname"];
    NSString *fullUrl = [NSString stringWithFormat:@"http://%@:3000/update/%@-%d", hostName, curatorId, (pageNumber + 1)];
    NSURL *url = [NSURL URLWithString:fullUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation start];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [self resetTimer];
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(stopHUDTimer)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)stopHUDTimer {
    [SVProgressHUD dismiss];
}

-(IBAction)handleCuratorButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Timer
- (void)increaseTimerCount {
    timerCount++;
    if(timerCount == MAX_SECONDS_BEFORE_GOING_BACK_TO_CURATOR) { [self.navigationController popToRootViewControllerAnimated:YES]; }
}
- (void)startTimer {
    [self resetTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
}
- (void)resetTimer { timerCount = 0; }
- (void)stopTimer { [timer invalidate]; }

#pragma mark -
#pragma mark Scrolling

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resetTimer];
    if(tapCover.alpha == 0) {
        [UIView animateWithDuration:0.25 animations:^{tapCover.alpha = 1.0;}];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self resetTimer];
    [UIView animateWithDuration:0.25 animations:^{tapCover.alpha = 0.0;}];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
    [self resetTimer];
    int pageNumber = (int)(sv.contentOffset.x / 836);
    self.photographerNameLabel.text = [[photographerNames objectAtIndex:pageNumber] uppercaseString];
}

@end
