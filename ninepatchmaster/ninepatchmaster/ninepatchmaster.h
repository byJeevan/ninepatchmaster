//
//  ninepatchmaster.h
//  ninepatchmaster
//
//  Created by jeevanRao7 on 30/07/15.
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

/** Returns the normal image from the nine patch image by croping the black corner lines from the nine patch image.
  * @param `ninePatchImage` is the nine patch image
  * @return normal image that can be assigned to image view.
  */
+ (UIImage*)createResizableNinePatchImage:(UIImage*)ninePatchImage;

/** Returns the edges 'top', 'left', 'bottom', 'right' from the lines of the nine patch.
 * @param `ninePatchImage` is the nine patch image
 * @return Mutable array containing nine patch corners.
 */
+ (NSMutableDictionary *)returnCapInsetsForTextPadding:(UIImage *)ninePatchImage;

/**  Will use edge values from nine patch image and expands or shrinks according to text size.
  *  @param `labelView` is the place where text added is gets occupied in expandable area of nine patch image.
  *  @param `scrollView` is the parent of labelview and it manages the scrolling of lable view when text lines exceeded from expandable area of nine patch image. also it is the subview of the image view.
  *  @param `imageView` is the image view object where nine patch image will be assigned after removing its black lines/marks at the corners.
  *  @param `availableHeight` is a float value upon which image view height decided.
  *  @param `instructionText` string for the lable view. This can be normal text or attributes text.
  *  @param `ninePatchImageName` nine patch image name in the format of "myphoto.9" if the image file 'myphoto.9.png'.
  *  @param `imageViewOrigin` Y value of image view frame.
  *  @param `targetView` target view is the parent view of all these views.
  *
  */
+ (void) applyNinePathImageForLabel:(UILabel *) labelView scrollView:(UIScrollView *) scrollView imageView:(UIImageView *) imageView availableHeight:(float) availableHeight instructionText:(NSString *) instructionText ninePatchImageName:(NSString *) ninePatchImageName  imageViewOrigin:(float) imageViewOrigin  forView:(UIView *) targetView;

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
