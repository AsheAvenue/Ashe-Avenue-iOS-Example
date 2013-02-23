//
//  Photographer.m
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Photographer.h"

@implementation Photographer

@synthesize photographerId, photographerNameLabel, image, text, backButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set up a photographer query
    PFQuery *photographerQuery = [PFQuery queryWithClassName:@"Photographer"];
    photographerQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    //get the photographer info
    PFObject *photographer = [photographerQuery getObjectWithId:photographerId];
    self.photographerNameLabel.text = [photographer objectForKey:@"Name"];
    self.text.text = [photographer objectForKey:@"Text"];
    
    //load the image
    self.image.file = [photographer objectForKey:@"Image"];
    [self.image loadInBackground];
}


-(IBAction)handleBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
