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

@synthesize curatorId, curatorNameLabel, curatorButton, secondaryTextLabel, iButton;

NSMutableArray *images;
int leftSwipes = 0;
int rightSwipes = 0;

#pragma mark -
#pragma mark View

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //fake the curator ID for now
    curatorId = @"HhGseMJbOA";
    
    [curatorNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    [secondaryTextLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:17]];
    [self selectCurator];    
}

- (void)handleChangeCurator: (NSNotification *) notification {
    
    //get the notification's userInfo and parse out the curatorId
    NSDictionary *dict = notification.userInfo;
    self.curatorId = [dict objectForKey:@"curatorId"];
    [self selectCurator];
    [self.collectionView reloadData];
}

- (void)selectCurator {
    //instantiate the images
    images = [NSMutableArray new];
    
    //Set up a query to get the curator info
    PFQuery *curatorQuery = [PFQuery queryWithClassName:@"Curator"];
    curatorQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    //Get the curator info for the top of the page, plus the button click over to the curator page
    PFObject *curator = [curatorQuery getObjectWithId:curatorId];
    
    self.curatorNameLabel.text = [[curator objectForKey:@"Name"] uppercaseString];
    
    //position the "i" button
    CGRect frame = iButton.frame;
    CGSize curatorSize = [curatorNameLabel.text sizeWithFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    frame.origin.x = curatorNameLabel.frame.origin.x + curatorSize.width + 12;
    iButton.frame = frame;
    
    self.secondaryTextLabel.text = [curator objectForKey:@"SecondaryText"];
    self.curatorId = curator.objectId;
    
    //Get the images for this curator
    PFQuery *imagesQuery = [PFQuery queryWithClassName:@"Image"];
    [imagesQuery whereKey:@"Curator" equalTo:curator];
    imagesQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    images = [NSMutableArray arrayWithArray:[imagesQuery findObjects]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleChangeCurator:)
                                                 name:@"CuratorChanged"
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CuratorChanged" object:nil];
}

#pragma mark -
#pragma mark Data Source

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
#pragma mark Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCell *cell = (GalleryCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowImage" sender:cell];
}

#pragma mark -
#pragma mark Buttons and Segues

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

#pragma mark -
#pragma mark Gesture

- (void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    leftSwipes++;
    [self handleSwipes];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    rightSwipes++;
    [self handleSwipes];
}

- (void)handleSwipes {
    NSLog([NSString stringWithFormat:@"Left: %i, Right: %i", leftSwipes, rightSwipes]);
    if(leftSwipes > 3 && rightSwipes > 3) {
        [self performSegueWithIdentifier:@"ShowMenu" sender:self];
        leftSwipes = 0;
        rightSwipes = 0;
    }
}

@end
