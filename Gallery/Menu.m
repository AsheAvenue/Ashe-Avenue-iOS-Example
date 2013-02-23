//
//  Menu.m
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Menu.h"

@implementation Menu

@synthesize cancelButton, row1, row2, row3, row4;

-(IBAction)handleCombination:(id)sender {
    
    int row1Val = row1.selectedSegmentIndex != -1 ? [[row1 titleForSegmentAtIndex:row1.selectedSegmentIndex] intValue] : 0;
    int row2Val = row2.selectedSegmentIndex != -1 ? [[row2 titleForSegmentAtIndex:row2.selectedSegmentIndex] intValue] : 0;
    int row3Val = row3.selectedSegmentIndex != -1 ? [[row3 titleForSegmentAtIndex:row3.selectedSegmentIndex] intValue] : 0;
    int row4Val = row4.selectedSegmentIndex != -1 ? [[row4 titleForSegmentAtIndex:row4.selectedSegmentIndex] intValue] : 0;
    
    if(row1Val == 2 && row2Val == 5 && row3Val == 11 && row4Val == 15) {
        [self performSegueWithIdentifier:@"ShowHiddenMenu" sender:self];
    }
}

-(IBAction)handleCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
