//
//  HiddenMenu.h
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiddenMenu : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) IBOutlet UIPickerView *curatorPicker;
@property (nonatomic, retain) IBOutlet UIButton *changeCuratorButton;
@property (nonatomic, retain) IBOutlet UITextField *hostname;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;

-(IBAction)handleChangeCuratorButton:(id)sender;
-(IBAction)handleDoneButton:(id)sender;

@end
