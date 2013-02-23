//
//  HiddenMenu.h
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HiddenMenu : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) IBOutlet UIPickerView *curatorPicker;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

-(IBAction)handleCancelButton:(id)sender;

@end
