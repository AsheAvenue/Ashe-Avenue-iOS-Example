//
//  Photographer.h
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Photographer : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *photographerNameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UITextView *text;
@property (nonatomic, retain) IBOutlet UIButton *backButton;

-(IBAction)handleBackButton:(id)sender;

@end
