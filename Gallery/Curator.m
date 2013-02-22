//
//  Curator.m
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Curator.h"

@implementation Curator

@synthesize curatorId, curatorNameLabel, image, text, backButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set up a curator query
    PFQuery *curatorQuery = [PFQuery queryWithClassName:@"Curator"];
    curatorQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    //get the curator info
    PFObject *curator = [curatorQuery getObjectWithId:curatorId];
    self.curatorNameLabel.text = [curator objectForKey:@"Name"];
    self.text.text = [curator objectForKey:@"Text"];

    //load the image
    self.image.file = [curator objectForKey:@"Image"];
    [self.image loadInBackground];
}

-(IBAction)handleBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
