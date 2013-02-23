//
//  Menu.h
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Menu : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *row1;
@property (nonatomic, retain) IBOutlet UISegmentedControl *row2;
@property (nonatomic, retain) IBOutlet UISegmentedControl *row3;
@property (nonatomic, retain) IBOutlet UISegmentedControl *row4;

-(IBAction)handleCombination:(id)sender;
-(IBAction)handleCancelButton:(id)sender;

@end
