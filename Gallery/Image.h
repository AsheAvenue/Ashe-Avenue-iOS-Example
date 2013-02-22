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
@property (nonatomic, retain) NSString *curatorId;
@property (nonatomic, retain) NSString *photographerId;
@property (nonatomic, retain) IBOutlet UILabel *curatorNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *secondaryTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *photographerNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *imageNameLabel;
@property (nonatomic, retain) IBOutlet UIButton *curatorButton;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *displayButton;
@property (nonatomic, retain) IBOutlet UIButton *photographerButton;
@property (nonatomic, retain) IBOutlet PFImageView *image;

-(IBAction)handleBackButton:(id)sender;

@end
