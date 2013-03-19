//
//  Image.h
//  Gallery
//
//  Created by Tim Boisvert on 2/21/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Image : UIViewController

@property (nonatomic, retain) NSString *imageId;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableArray *toDisplayArray;
@property (assign) int positionInArrays;
@property (nonatomic, retain) NSString *curatorId;
@property (nonatomic, retain) NSString *photographerId;
@property (nonatomic, retain) IBOutlet UILabel *secondaryTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *photographerNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *curatorButton;
@property (nonatomic, retain) IBOutlet UIButton *displayButton;
@property (nonatomic, retain) IBOutlet PFImageView *image;
@property (nonatomic, retain) IBOutlet PFImageView *leftImage;
@property (nonatomic, retain) IBOutlet PFImageView *rightImage;
@property (nonatomic, retain) IBOutlet UIView *tapCover;
@property (nonatomic, retain) IBOutlet UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, retain) IBOutlet UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

-(IBAction)handleBackButton:(id)sender;
-(IBAction)handleProjectButton:(id)sender;
-(IBAction)showTapCover:(id)sender;
-(IBAction)hideTapCover:(id)sender;

-(IBAction)swipeRight:(UISwipeGestureRecognizer *)UISwipeGestureRecognizer;
-(IBAction)swipeLeft:(UISwipeGestureRecognizer *)UISwipeGestureRecognizer;

@end
