//
//  GalleryCell.h
//  Gallery
//
//  Created by Tim Boisvert on 2/22/13.
//  Copyright (c) 2013 Shutterstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GalleryCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet PFImageView *image;
@property (nonatomic, retain) NSString *imageId;

@end
