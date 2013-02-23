//
//  HiddenMenu.m
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "HiddenMenu.h"

@implementation HiddenMenu

@synthesize curatorPicker, cancelButton;

NSArray *curators;

#pragma mark -
#pragma View

-(void)viewDidLoad {
    PFQuery *curatorQuery = [PFQuery queryWithClassName:@"Curator"];
    curatorQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    //Get all curators
    curators = [curatorQuery findObjects];
}

#pragma mark -
#pragma Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return curators.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    PFObject *curator = [curators objectAtIndex:row];
    return [curator objectForKey:@"Name"];
}

#pragma mark -
#pragma Buttons

-(IBAction)handleCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
