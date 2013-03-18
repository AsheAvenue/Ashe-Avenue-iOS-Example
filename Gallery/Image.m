//
//  Image.m
//  Gallery
//
//  Created by Tim Boisvert on 2/21/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Image.h"
#import "AFNetworking.h"

@implementation Image

@synthesize imageId, curatorId, photographerId, secondaryTextLabel, photographerNameLabel, curatorButton, displayButton, image, tapCover;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [photographerNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    [secondaryTextLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:17]];
    
    //Set up an image query
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"Image"];
    [imageQuery includeKey:@"Curator"];
    [imageQuery includeKey:@"Photographer"];
    imageQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    //get the image info
    PFObject *imageObject = [imageQuery getObjectWithId:imageId];
    self.image.file = [imageObject objectForKey:@"Image"];
    [self.image loadInBackground];

    //get the curator info
    PFObject *curator = [imageObject objectForKey:@"Curator"];
    curatorId = [curator objectId];
    self.secondaryTextLabel.text = [NSString stringWithFormat:@"from %@'s curated collection", [[curator objectForKey:@"Name"] uppercaseString]];
    
    //get the photographer info
    PFObject *photographer = [imageObject objectForKey:@"Photographer"];
    photographerId = [photographer objectId];
    self.photographerNameLabel.text = [[photographer objectForKey:@"Name"] uppercaseString];

}

#pragma mark -
#pragma Buttons and Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowCurator"]) {
        [[segue destinationViewController] setCuratorId:curatorId];
    } else if([[segue identifier] isEqualToString:@"ShowPhotographer"]) {
        [[segue destinationViewController] setPhotographerId:photographerId];
    }
}


-(IBAction)handlePhotographerButton:(id)sender {
    //[self performSegueWithIdentifier:@"ShowPhotographer" sender:photographerButton];
}


-(IBAction)handleBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)handleProjectButton:(id)sender {
    NSURL *url = [NSURL URLWithString:(NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"hostname"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation start];
}

#pragma mark -
#pragma Tap Cover

-(IBAction)showTapCover:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{tapCover.alpha = 1.0;}];
}

-(IBAction)hideTapCover:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{tapCover.alpha = 0.0;}];
}


@end
