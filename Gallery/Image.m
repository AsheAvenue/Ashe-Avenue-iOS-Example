//
//  Image.m
//  Gallery
//
//  Created by Tim Boisvert on 2/21/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Image.h"

@implementation Image

@synthesize imageId, curatorId, photographerId, curatorNameLabel, secondaryTextLabel, photographerNameLabel, imageNameLabel, curatorButton, backButton, displayButton, photographerButton, image;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set up an image query
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"Image"];
    [imageQuery includeKey:@"Curator"];
    [imageQuery includeKey:@"Photographer"];
    imageQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    //get the image info
    PFObject *imageObject = [imageQuery getObjectWithId:imageId];
    self.image.file = [imageObject objectForKey:@"Image"];
    [self.image loadInBackground];
    self.imageNameLabel.text = [imageObject objectForKey:@"Name"];

    //get the curator info
    PFObject *curator = [imageObject objectForKey:@"Curator"];
    curatorId = [curator objectId];
    self.curatorNameLabel.text = [curator objectForKey:@"Name"];
    self.secondaryTextLabel.text = [curator objectForKey:@"SecondaryText"];
    
    //get the photographer info
    PFObject *photographer = [imageObject objectForKey:@"Photographer"];
    photographerId = [photographer objectId];
    self.photographerNameLabel = [photographer objectForKey:@"Name"];
}

#pragma mark -
#pragma Buttons and Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowCurator"]) {
        [[segue destinationViewController] setCuratorId:curatorId];
    } else if([[segue identifier] isEqualToString:@"ShowPhotographer"]) {
        [[segue destinationViewController] setCuratorId:photographerId];
    }
}

-(IBAction)handleCuratorButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowCurator" sender:curatorButton];
}


-(IBAction)handlePhotographerButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowPhotographer" sender:photographerButton];
}


-(IBAction)handleBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
