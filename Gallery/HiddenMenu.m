//
//  HiddenMenu.m
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "HiddenMenu.h"
#import "MenuNav.h"

@implementation HiddenMenu

@synthesize curatorPicker, changeCuratorButton, hostname, doneButton;

NSMutableArray *curatorIds;
NSMutableArray *curatorNames;

#pragma mark -
#pragma View

-(void)viewDidLoad {
    
    curatorIds = [NSMutableArray new];
    curatorNames = [NSMutableArray new];
    
    //load the images file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Curators" ofType:@"txt"];
    if (filePath) {
        NSString *contentOfFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *curatorsArray = [contentOfFile componentsSeparatedByString:@"\n"];
        
        for(NSString *curator in curatorsArray) {
            NSArray *lineArray = [curator componentsSeparatedByString:@"|"];
            [curatorIds addObject:[lineArray objectAtIndex:0]];
            [curatorNames addObject:[lineArray objectAtIndex:1]];
        }
    }
    
    //load the hostname
    hostname.text = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"hostname"];
    
    //select the proper curator
    NSString *curatorId = [(MenuNav *)self.navigationController curatorId];
    [self.curatorPicker selectRow:([curatorId intValue]-1) inComponent:0 animated:NO];
}

#pragma mark -
#pragma Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return curatorIds.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@ (%d)", [curatorNames objectAtIndex:row], (row + 1)];
}

#pragma mark -
#pragma Buttons

-(IBAction)handleChangeCuratorButton:(id)sender {
    //get the current Curator
    NSUInteger selectedRow = [curatorPicker selectedRowInComponent:0];
    NSString *id = [curatorIds objectAtIndex:selectedRow];
    
    // call the notification center, which is being listened to by the Gallery class
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:id forKey:@"curatorId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CuratorChanged" object:self userInfo:dict];
}

-(IBAction)handleDoneButton:(id)sender {
    //save the hostname
    [[NSUserDefaults standardUserDefaults] setValue:hostname.text forKey:@"hostname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
