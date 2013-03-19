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

@synthesize imageId, imageArray, toDisplayArray, positionInArrays, curatorId, photographerId, secondaryTextLabel, photographerNameLabel, curatorButton, displayButton, image, rightImage, leftImage, tapCover, leftSwipeGestureRecognizer, rightSwipeGestureRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [photographerNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    [secondaryTextLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:17]];
    
    //Set up an image query
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"Image"];
    [imageQuery includeKey:@"Curator"];
    imageQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    //get the image info
    PFObject *imageObject = [imageQuery getObjectWithId:imageId];
    self.image.file = [imageObject objectForKey:@"Image"];
    [self.image loadInBackground];

    self.photographerNameLabel.text = [toDisplayArray objectAtIndex:positionInArrays];
    
    //left and right images
    int previousIndex = positionInArrays - 1;
    int nextIndex = positionInArrays + 1;
    bool showPrevious = YES;
    bool showNext = YES;
    
    if(previousIndex < 0) {
        showPrevious = NO;
        rightSwipeGestureRecognizer.enabled = NO;
    }
    if(nextIndex >= [imageArray count]) {
        showNext = NO;
    }
    
    if(showPrevious) {
        NSString *previousImageId = [imageArray objectAtIndex:previousIndex];
        PFObject *leftImageObject = [imageQuery getObjectWithId:previousImageId];
        self.leftImage.file = [leftImageObject objectForKey:@"Image"];
        [self.leftImage loadInBackground];
    }
    
    if(showNext) {
        NSString *nextImageId = [imageArray objectAtIndex:nextIndex];
        PFObject *rightImageObject = [imageQuery getObjectWithId:nextImageId];
        self.rightImage.file = [rightImageObject objectForKey:@"Image"];
        [self.rightImage loadInBackground];
    }
    
    //get the curator info
    PFObject *curator = [imageObject objectForKey:@"Curator"];
    curatorId = [curator objectId];
    self.secondaryTextLabel.text = [NSString stringWithFormat:@"from %@'s curated collection", [[curator objectForKey:@"Name"] uppercaseString]];
}

#pragma mark -
#pragma Buttons and Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowCurator"]) {
        [[segue destinationViewController] setCuratorId:curatorId];
    } else if([[segue identifier] isEqualToString:@"ShowPhotographer"]) {
        [[segue destinationViewController] setPhotographerId:photographerId];
    }
}


-(IBAction)handlePhotographerButton:(id)sender {
    //[self performSegueWithIdentifier:@"ShowPhotographer" sender:photographerButton];
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
#pragma Tap Cover

-(IBAction)showTapCover:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{tapCover.alpha = 1.0;}];
}

-(IBAction)hideTapCover:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{tapCover.alpha = 0.0;}];
}

#pragma mark -
#pragma mark Gesture

- (void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGRect leftImageFrame = self.leftImage.frame;
    CGRect rightImageFrame = self.rightImage.frame;
    CGRect imageFrame = self.image.frame;
    
    //turn the rightSwipeGestureRecognizer back on
    rightSwipeGestureRecognizer.enabled = YES;
    
    //animate the images
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    image.frame = leftImageFrame; //move image to the left position
    positionInArrays += 1;
    rightImage.alpha = 1;
    rightImage.frame = imageFrame; //move right image to the middle position
    leftImage.alpha = 0;
    tapCover.alpha = 0;
    photographerNameLabel.alpha = 0;
    [UIView commitAnimations];
    
    photographerNameLabel.text = [toDisplayArray objectAtIndex:positionInArrays];
    
    //animate the left
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    photographerNameLabel.alpha = 1.0;
    leftImage.frame = rightImageFrame; //move left image to the right position
    leftImage.alpha = 0;
    [UIView commitAnimations];
    
    PFImageView *newRight = leftImage;
    PFImageView *newMiddle = rightImage;
    PFImageView *newLeft = image;
    leftImage = newLeft;
    image = newMiddle;
    rightImage = newRight;
    
    //now load a new right image
    int nextIndex = positionInArrays + 1;
    bool showNext = YES;
    if(nextIndex > imageArray.count - 1) {
        showNext = NO;
    }
    
    if(showNext) {
        PFQuery *imageQuery = [PFQuery queryWithClassName:@"Image"];
        imageQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
        NSString *nextImageId = [imageArray objectAtIndex:nextIndex];
        PFObject *rightImageObject = [imageQuery getObjectWithId:nextImageId];
        rightImage.file = [rightImageObject objectForKey:@"Image"];
        [rightImage loadInBackground];
        rightImage.hidden = NO;
    } else {
        leftSwipeGestureRecognizer.enabled = NO;
    }
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGRect leftImageFrame = self.leftImage.frame;
    CGRect rightImageFrame = self.rightImage.frame;
    CGRect imageFrame = self.image.frame;

    //turn the lefttSwipeGestureRecognizer back on
    leftSwipeGestureRecognizer.enabled = YES;
    
    //animate the images
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    image.frame = rightImageFrame; //move image to the right position
    positionInArrays -= 1;
    leftImage.alpha = 1;
    leftImage.frame = imageFrame; //move left image to the middle position
    rightImage.alpha = 0;
    tapCover.alpha = 0;
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    rightImage.frame = leftImageFrame; //move right image to the left position
    rightImage.alpha = 0;
    [UIView commitAnimations];
    
    PFImageView *newLeft = rightImage;
    PFImageView *newMiddle = leftImage;
    PFImageView *newRight = image;
    leftImage = newLeft;
    image = newMiddle;
    rightImage = newRight;
    
    //now load a new left image
    int previousIndex = positionInArrays - 1;
    bool showPrevious = YES;
    if(previousIndex < 0) {
        showPrevious = NO;
    } 
    
    if(showPrevious) {
        PFQuery *imageQuery = [PFQuery queryWithClassName:@"Image"];
        imageQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
        NSString *previousImageId = [imageArray objectAtIndex:previousIndex];
        PFObject *leftImageObject = [imageQuery getObjectWithId:previousImageId];
        leftImage.file = [leftImageObject objectForKey:@"Image"];
        [leftImage loadInBackground];
        leftImage.hidden = NO;
    } else {
        rightSwipeGestureRecognizer.enabled = NO;
    }

}

@end
