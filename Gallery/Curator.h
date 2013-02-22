//
//  Curator.h
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Curator : UIViewController

@property (nonatomic, retain) NSString *curatorId;
@property (nonatomic, retain) IBOutlet UILabel *curatorNameLabel;
@property (nonatomic, retain) IBOutlet PFImageView *image;
@property (nonatomic, retain) IBOutlet UITextView *text;
@property (nonatomic, retain) IBOutlet UIButton *backButton;

-(IBAction)handleBackButton:(id)sender;

@end
