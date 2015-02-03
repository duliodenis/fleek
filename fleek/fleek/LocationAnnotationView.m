//
//  LocationAnnotationView.m
//  fleek
//
//  Created by Dulio Denis on 2/3/15.
//  Copyright (c) 2015 ddApps. All rights reserved.
//

#import "LocationAnnotationView.h"

@interface CircleView : UIView {

}

@end

@implementation CircleView
    
- (void)drawRect:(CGRect)rect {
    CGContextRef context= UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetAlpha(context, 0.5);
    CGContextFillEllipseInRect(context, CGRectMake(0,0,self.frame.size.width,self.frame.size.height));
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(0,0,self.frame.size.width,self.frame.size.height));
}

@end

@interface LocationAnnotationView () {
    UIImageView *_imageView;
    CircleView *_circleView;
}

@end

@implementation LocationAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // make sure the x and y of the CGRect are half it's
        // width and height, so the callout shows when user clicks
        // in the middle of the image
        CGRect  viewRect = CGRectMake(-30, -30, 60, 60);
        
        CircleView* circleView = [[CircleView alloc] initWithFrame:viewRect];
        _circleView = circleView;
        [self addSubview:circleView];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:viewRect];
        
        // keeps the image dimensions correct
        // so if you have a rectangle image, it will show up as a rectangle,
        // instead of being resized into a square
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _imageView = imageView;
        
        [self addSubview:imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    // when an image is set for the annotation view,
    // it actually adds the image to the image view
    _imageView.image = image;
}

- (void)stickerColor:(float)color {
    [_circleView setNeedsDisplay];
}

@end
