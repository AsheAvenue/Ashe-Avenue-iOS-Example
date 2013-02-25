//
//  HiddenMenu.m
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "HiddenMenu.h"

@implementation HiddenMenu

@synthesize curatorPicker, changeCuratorButton, wipeOutCacheButton, cancelButton;

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

-(IBAction)handleChangeCuratorButton:(id)sender {
    //get the current Curator
    NSUInteger selectedRow = [curatorPicker selectedRowInComponent:0];
    PFObject *curator = [curators objectAtIndex:selectedRow];
    NSString *curatorId = [curator objectId];
    
    // call the notification center, which is being listened to by the Gallery class
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:curatorId forKey:@"curatorId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CuratorChanged" object:self userInfo:dict];
}

-(IBAction)handleWipeOutCacheButton:(id)sender {
    if([[wipeOutCacheButton titleForState:UIControlStateNormal] isEqualToString:@"Are you sure?"]) {
        
        [wipeOutCacheButton setTitle:@"Reloading" forState:UIControlStateNormal];
        
        //wipe out the queries
        [PFQuery clearAllCachedResults];
        
        //reload the curators on this page
        PFQuery *curatorQuery = [PFQuery queryWithClassName:@"Curator"];
        curatorQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
        [curatorQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            curators = objects;
            [curatorPicker reloadAllComponents];
            
            //now get all the images and photographers again
            PFQuery *imageQuery = [PFQuery queryWithClassName:@"Image"];
            imageQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
            [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                PFQuery *photographerQuery = [PFQuery queryWithClassName:@"Photographer"];
                photographerQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
                [photographerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    [wipeOutCacheButton setTitle:@"Reload" forState:UIControlStateNormal];                
                }];
            }];
        }];
        
    } else {
        [wipeOutCacheButton setTitle:@"Are you sure?" forState:UIControlStateNormal];
    }
}

-(IBAction)handleCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
