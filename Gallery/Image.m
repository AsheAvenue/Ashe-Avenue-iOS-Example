//
//  Image.m
//  Gallery
//
//  Created by Tim Boisvert on 2/21/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Image.h"
#import "AFNetworking.h"

@implementation Image

@synthesize curatorId, imageId, curatorName, curatorImageCount, photographerNames, secondaryTextLabel, photographerNameLabel, curatorButton, displayButton, scrollView, tapCover;

int timerCount;
int MAX_SECONDS_BEFORE_GOING_BACK_TO_CURATOR = 15;
NSTimer *timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [photographerNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    [secondaryTextLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:17]];
    
    //add the images
    for(int i = 1; i <= curatorImageCount; i++) {
        NSString *fileName = [NSString stringWithFormat:@"Full-%@-%d.jpg", curatorId, i];
        UIImage *img = [UIImage imageNamed:fileName];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setFrame:CGRectMake((i-1) * 836, 0, 836, 554)];
        [scrollView addSubview:imgView];
    }
    [scrollView setContentSize:CGSizeMake(836 * curatorImageCount, 554)];
    
    //scroll to this index
    [scrollView scrollRectToVisible:CGRectMake((imageId-1) * 836, 0, 836, 554) animated:NO];
    
    self.photographerNameLabel.text = [[photographerNames objectAtIndex:(imageId -1)] uppercaseString];
    self.secondaryTextLabel.text = [NSString stringWithFormat:@"from %@'s curated collection", [curatorName uppercaseString]];
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
    NSURL *url = [NSURL URLWithString:(NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"hostname"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation start];
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resetTimer];
    if(tapCover.alpha == 0) {
        [UIView animateWithDuration:0.25 animations:^{tapCover.alpha = 1.0;}];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self resetTimer];
    [UIView animateWithDuration:0.25 animations:^{
        tapCover.alpha = 0.0;
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
    [self resetTimer];
    int pageNumber = (int)(sv.contentOffset.x / 836);
    self.photographerNameLabel.text = [[photographerNames objectAtIndex:pageNumber] uppercaseString];
}



@end
