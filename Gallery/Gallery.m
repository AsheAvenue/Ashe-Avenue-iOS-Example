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

@synthesize curatorId, curatorName, curatorImageCount, curatorNameLabel, curatorButton, secondaryTextLabel, iButton;

NSMutableArray *images;

int timerCount;
int MAX_SECONDS_BEFORE_GOING_BACK = 30;
NSTimer *timer;

#pragma mark -
#pragma mark View

-(void)viewDidLoad {
    [super viewDidLoad];
        
    [curatorNameLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    [secondaryTextLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:17]];

    //instantiate the images
    images = [NSMutableArray new];
    
    self.curatorNameLabel.text = [self.curatorName uppercaseString];
    
    //position the "i" button
    CGRect frame = iButton.frame;
    CGSize curatorSize = [curatorNameLabel.text sizeWithFont:[UIFont fontWithName:@"OpenSans-Light" size:24]];
    frame.origin.x = curatorNameLabel.frame.origin.x + curatorSize.width + 12;
    iButton.frame = frame;
    
    //load the images file
    NSString *fileName = [NSString stringWithFormat:@"Images-%@", self.curatorId];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    if (filePath) {
        NSString *contentOfFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *imagesArray = [contentOfFile componentsSeparatedByString:@"\n"];
        
        for(NSString *image in imagesArray) {
            NSArray *lineArray = [image componentsSeparatedByString:@"|"];
            [images addObject:[lineArray objectAtIndex:1]];
        }
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
    
    int imageId = indexPath.item + 1;
    cell.imageId = imageId;
    cell.photographerName = [images objectAtIndex:imageId -1];
    
    //load the image
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"Thumb-%@-%d.jpg", curatorId, imageId]];
    [cell.image setImage:img];
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
        [[segue destinationViewController] setCuratorId:curatorId];
        [[segue destinationViewController] setCuratorName:curatorName];
        [[segue destinationViewController] setPhotographerNames:images];
        [[segue destinationViewController] setCuratorImageCount:curatorImageCount];
    }
}

-(IBAction)handleCuratorButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
