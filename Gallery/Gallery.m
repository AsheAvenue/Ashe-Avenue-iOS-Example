//
//  Gallery.m
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import "Gallery.h"
#import "GalleryCell.h"
#import "Curator.h"
#import "Image.h"

@implementation Gallery

@synthesize curatorId, curatorNameLabel, curatorButton, secondaryTextLabel;

NSMutableArray *images;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //instantiate the images
    images = [NSMutableArray new];
    
    //fake the curator ID for now
    curatorId = @"HhGseMJbOA";
    
    //Set up a query to get the curator info
    PFQuery *curatorQuery = [PFQuery queryWithClassName:@"Curator"];
    curatorQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    //Get the curator info for the top of the page, plus the button click over to the curator page
    PFObject *curator = [curatorQuery getObjectWithId:curatorId];
    self.curatorNameLabel.text = [curator objectForKey:@"Name"];
    self.secondaryTextLabel.text = [curator objectForKey:@"SecondaryText"];
    self.curatorId = curator.objectId;
    
    //Get the images for this curator
    PFQuery *imagesQuery = [PFQuery queryWithClassName:@"Image"];
    [imagesQuery whereKey:@"Curator" equalTo:curator];
    imagesQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    images = [NSMutableArray arrayWithArray:[imagesQuery findObjects]];
}

#pragma mark -
#pragma Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    PFObject *imageObject = [images objectAtIndex:indexPath.item];
    cell.image.file = [imageObject objectForKey:@"Image"];
    cell.imageId = [imageObject objectId];
    [cell.image loadInBackground];
    return cell;
}

#pragma mark -
#pragma Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCell *cell = (GalleryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowImage" sender:cell];
}

#pragma mark -
#pragma Buttons and Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowCurator"]) {
        [[segue destinationViewController] setCuratorId:curatorId];
    } else if([[segue identifier] isEqualToString:@"ShowImage"]) {
        GalleryCell *cell = (GalleryCell *)sender;
        [[segue destinationViewController] setImageId:cell.imageId];
    }

}

-(IBAction)handleCuratorButton:(id)sender {
    [self performSegueWithIdentifier:@"ShowCurator" sender:curatorButton];
}

@end
