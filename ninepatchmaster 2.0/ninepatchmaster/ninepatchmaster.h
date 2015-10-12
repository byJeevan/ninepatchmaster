//
//  ninepatchmaster.h
//  ninepatchmaster
//  version 2.0
//
//  Created by jeevanRao7 on 30/07/15.
//
//  Updated by JeevanRao7 on 10/10/15
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface ninepatchmaster : NSObject

/**  Will use edge values from nine patch image and expands or shrinks according to text size.
  *
  *  @param `imageNinePatch` nine patch image in the format eg. of "myphoto.9" if the image file 'myphoto.9.png'.
  *  @param `text` text in the format of NSString that will be added over background image view.
  *  @param `view` parent view for the image view.
  *
  */

+ (void) applyNinePatchImage: (UIImage *)imageNinePatch withText:(NSString *) text forView:(UIView *) view;

@end

#pragma mark - UIImage Extension

@interface UIImage (Crop)

- (UIImage*)crop:(CGRect)rect;

@end

@implementation UIImage (Crop)

- (UIImage*)crop:(CGRect)rect
{
    rect = CGRectMake(rect.origin.x * self.scale,
                      rect.origin.y * self.scale,
                      rect.size.width * self.scale,
                      rect.size.height * self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end
