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
NSMutableArray *imageArray;
NSMutableArray *toDisplayArray;

int leftSwipes = 0;
int rightSwipes = 0;

int timerCount;
int MAX_SECONDS_BEFORE_GOING_BACK = 15;
NSTimer *timer;

#pragma mark -
#pragma mark View

-(void)viewDidLoad {
    [super viewDidLoad];
        
    [curatorNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    [secondaryTextLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:17]];
    [self selectCurator];
}

- (void)handleChangeCurator: (NSNotification *) notification {
    
    //get the notification's userInfo and parse out the curatorId
    NSDictionary *dict = notification.userInfo;
    self.curatorId = [dict objectForKey:@"curatorId"];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.curatorId forKey:@"curatorId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self selectCurator];
    [self.collectionView reloadData];
}

- (void)selectCurator {
    //instantiate the images
    images = [NSMutableArray new];
    imageArray = [NSMutableArray new];
    toDisplayArray = [NSMutableArray new];
    
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
    [imagesQuery orderByAscending:@"Order"];
    [imagesQuery whereKey:@"Curator" equalTo:curator];
    imagesQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    images = [NSMutableArray arrayWithArray:[imagesQuery findObjects]];
    
    //store just the image ids
    for(PFObject *image in images) {
        [imageArray addObject:image.objectId];
        
        //photographer name
        NSString *photographer = [image objectForKey:@"Photographer"];
        NSString *agency = [image objectForKey:@"Agency"];
        NSString *toDisplay;
        
        if(photographer == nil || [photographer isEqualToString:@""]) {
            if (agency != nil && ![agency isEqualToString:@""]) {
                toDisplay = agency;
            }
        } else {
            if (agency != nil && ![agency isEqualToString:@""]) {
                toDisplay = [NSString stringWithFormat:@"%@, %@", photographer, agency];
            } else {
                toDisplay = photographer;
            }
        }
        
        [toDisplayArray addObject:[toDisplay uppercaseString]];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleChangeCurator:)
                                                 name:@"CuratorChanged"
                                               object:nil];
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CuratorChanged" object:nil];
    [self stopTimer];
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
    cell.positionInImageIds = indexPath.item;
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
    if([[segue identifier] isEqualToString:@"ShowImage"]) {
        GalleryCell *cell = (GalleryCell *)sender;
        [[segue destinationViewController] setImageId:cell.imageId];
        [[segue destinationViewController] setImageArray:imageArray];
        [[segue destinationViewController] setToDisplayArray:toDisplayArray];
        [[segue destinationViewController] setPositionInArrays:cell.positionInImageIds];
    }
}

-(IBAction)handleCuratorButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Gesture

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self resetTimer];
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    leftSwipes++;
    [self handleSwipes];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    rightSwipes++;
    [self handleSwipes];
}

- (void)handleSwipes {
    if(leftSwipes > 3 && rightSwipes > 3) {
        [self performSegueWithIdentifier:@"ShowMenu" sender:self];
        leftSwipes = 0;
        rightSwipes = 0;
    }
}

#pragma mark -
#pragma mark Timer
- (void)increaseTimerCount {
    timerCount++;
    if(timerCount == MAX_SECONDS_BEFORE_GOING_BACK) { [self.navigationController popViewControllerAnimated:YES]; }
}
- (void)startTimer {
    [self resetTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
}
- (void)resetTimer { timerCount = 0; }
- (void)stopTimer { [timer invalidate]; }


@end
