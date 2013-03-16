//
//  Curator.m
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Curator.h"

@implementation Curator

@synthesize curatorId, curatorNameLabel, secondaryTextLabel, image, text, backButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [curatorNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    [secondaryTextLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:17]];
    [text setFont:[UIFont fontWithName:@"OpenSans" size:17]];
    
    //Set up a curator query
    PFQuery *curatorQuery = [PFQuery queryWithClassName:@"Curator"];
    curatorQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    //get the curator info
    PFObject *curator = [curatorQuery getObjectWithId:curatorId];
    self.curatorNameLabel.text = [[curator objectForKey:@"Name"] uppercaseString];
    self.secondaryTextLabel.text = [curator objectForKey:@"SecondaryText"];
    self.text.text = [curator objectForKey:@"Text"];

    //load the image
    self.image.file = [curator objectForKey:@"Image"];
    [self.image loadInBackground];
}

-(IBAction)handleBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
