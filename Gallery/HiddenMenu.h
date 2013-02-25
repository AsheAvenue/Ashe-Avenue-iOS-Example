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
@property (nonatomic, retain) IBOutlet UIButton *changeCuratorButton;
@property (nonatomic, retain) IBOutlet UIButton *wipeOutCacheButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

-(IBAction)handleChangeCuratorButton:(id)sender;
-(IBAction)handleWipeOutCacheButton:(id)sender;
-(IBAction)handleCancelButton:(id)sender;

@end
