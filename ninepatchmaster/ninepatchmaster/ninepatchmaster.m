//
//  ninepatchmaster.m
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

#import "ninepatchmaster.h"

@interface ninepatchmaster (Private)

+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count;

@end

@implementation ninepatchmaster

+ (NSMutableArray *)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count size:(NSInteger )arraySize shiftFactor:(NSInteger)factor{
    
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char* rawData = (unsigned char*)calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (int)((bytesPerRow * yy) + xx * bytesPerPixel);
    for (int ii = 0; ii < arraySize; ++ii) {
        CGFloat red = (rawData[byteIndex] * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4 * factor;
        
        NSArray* aColor = [NSArray arrayWithObjects:[NSNumber numberWithFloat:red], [NSNumber numberWithFloat:green], [NSNumber numberWithFloat:blue], [NSNumber numberWithFloat:alpha], nil];
        [result addObject:aColor];
    }
    
    free(rawData);
    
    return result;
}


+ (UIImage*)createResizableNinePatchImageNamed:(NSString*)name {
    
    NSAssert([name hasSuffix:@".9"], @"The image name is not ended with .9");
    
    NSString* fixedImageFilename = [NSString stringWithFormat:@"%@%@", name, @".png"];
    UIImage* oriImage = [UIImage imageNamed:fixedImageFilename];
    
    NSAssert(oriImage != nil, @"The input image is incorrect: ");
    
    NSString* fixed2xImageFilename = [NSString stringWithFormat:@"%@%@", [name substringWithRange:NSMakeRange(0, name.length - 2)], @"@2x.9.png"];
    UIImage* ori2xImage = [UIImage imageNamed:fixed2xImageFilename];
    if (ori2xImage != nil) {
        oriImage = ori2xImage;
        NSLog(@"NinePatchImageFactory[Info]: Using 2X image: %@", fixed2xImageFilename);
    } else {
        NSLog(@"NinePatchImageFactory[Info]: Using image: %@", fixedImageFilename);
    }
    
    return [self returnNinePatchImageByImage:oriImage];
}


+ (UIImage*)createResizableNinePatchImage:(UIImage*)ninePatchImage {
    
    return [self returnNinePatchImageByImage:ninePatchImage];
}


+ (UIImage *)returnNinePatchImageByImage:(UIImage *)ninePatchImage {
    
    UIImage* cropImage = [ninePatchImage crop:CGRectMake(1, 1, ninePatchImage.size.width - 2, ninePatchImage.size.height - 2)];
    
    return cropImage;
}

+ (NSMutableDictionary *)returnCapInsetsForTextPadding:(UIImage *)ninePatchImage {
    
    NSMutableDictionary *dictEdgeInsets = [[NSMutableDictionary alloc] init];
    
    NSMutableArray* bottomBarRgba =[self getRGBAsFromImage:ninePatchImage atX:0 andY:(ninePatchImage.size.height - 1) count:ninePatchImage.size.width * ninePatchImage.size.height size:ninePatchImage.size.width shiftFactor:1];
    NSMutableArray* rightBarRgba = [self getRGBAsFromImage:ninePatchImage atX:(ninePatchImage.size.width - 1) andY:0 count:ninePatchImage.size.width * ninePatchImage.size.height size:ninePatchImage.size.height shiftFactor:ninePatchImage.size.width];
    
    int top = -1, left = -1, bottom = -1, right = -1;
    
    for (int i = 0; i <= bottomBarRgba.count - 1; i++) {
        NSArray* aColor = bottomBarRgba[i];
        if ([aColor[3] floatValue] == 1) {
            left = i;
            break;
        }
    }
    
    for (int i = (int)bottomBarRgba.count - 1; i >= 0; i--) {
        NSArray* aColor = bottomBarRgba[i];
        if ([aColor[3] floatValue] == 1) {
            right = i;
            break;
        }
    }
    
    for (int i = left + 1; i <= right - 1; i++) {
        NSArray* aColor = bottomBarRgba[i];
        if ([aColor[3] floatValue] < 1) {
            NSAssert(NO, @"The 9-patch PNG format is not supported.");
        }
    }
    
    for (int i = 0; i <= rightBarRgba.count - 1; i++) {
        NSArray* aColor = rightBarRgba[i];
        if ([aColor[3] floatValue] == 1) {
            top = i;
            break;
        }
    }
    
    for (int i = (int)rightBarRgba.count - 1; i >= 0; i--) {
        NSArray* aColor = rightBarRgba[i];
        if ([aColor[3] floatValue] == 1) {
            bottom = i;
            break;
        }
    }
    
    for (int i = top + 1; i < bottom; i++) {
        NSArray* aColor = rightBarRgba[i];
        if ([aColor[3] floatValue] == 0) {
            NSAssert(NO, @"The 9-patch PNG format is not supported.");
        }
    }
    
    [dictEdgeInsets setValue:[NSString stringWithFormat:@"%ld",(long)top] forKey:@"top"];
    [dictEdgeInsets setValue:[NSString stringWithFormat:@"%ld",(long)bottom] forKey:@"bottom"];
    [dictEdgeInsets setValue:[NSString stringWithFormat:@"%ld",(long)left] forKey:@"left"];
    [dictEdgeInsets setValue:[NSString stringWithFormat:@"%ld",(long)right] forKey:@"right"];
    
    
    float bottomNew = (ninePatchImage.size.height - [[dictEdgeInsets valueForKey:@"bottom"] floatValue]);
    float rightNew = (ninePatchImage.size.width - [[dictEdgeInsets valueForKey:@"right"] floatValue]);
    
    [dictEdgeInsets setValue:[NSString stringWithFormat:@"%ld",(long)bottomNew] forKey:@"bottom"];
    [dictEdgeInsets setValue:[NSString stringWithFormat:@"%ld",(long)rightNew] forKey:@"right"];
    
    return dictEdgeInsets;
}

+ (UILabel *) returnRichInstructionTextForLabel:(UILabel *) label :(NSString *) inputString overWrite: (BOOL)overWriteStyleFromGameConfig fontSize:(float ) fontSize  maxLabelWidth:(float) maxWidth maxLabelHeight:(float) maxHeight {
    
    NSString * strigAfterFontWrapper =  [NSString stringWithFormat:@"<style type='text/css'> body {font-size: %fpx}</style><font face='%@'>%@</font>", fontSize , @"" , inputString];
    
    label.numberOfLines = 0;
    
    NSAttributedString *attributedstring = [self returnRichTextForString:strigAfterFontWrapper];
    
    label.attributedText = attributedstring;
    
    //Recalulate the label size
    CGSize maximumLabelSize = CGSizeMake( maxWidth , maxHeight);
    
    CGSize requiredSize = [label sizeThatFits:maximumLabelSize];
    
    //Now adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = requiredSize.height;
    newFrame.size.width = requiredSize.width;
    newFrame.origin.x = 0;
    newFrame.origin.y = 0;
    label.frame = newFrame;
    
    return label;
}

+ (NSAttributedString *) returnRichTextForString:(NSString *) inputString {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[inputString dataUsingEncoding:NSUTF8StringEncoding]  options:@{
                                                                                                                                                                  NSDocumentTypeDocumentAttribute:  NSHTMLTextDocumentType,
                                                                                                                                                                  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                                                                                                  }
                                                                               documentAttributes:nil
                                                                                            error:nil];
    
    
    return attributedString;
}

+ (void) applyNinePathImageForLabel:(UILabel *) labelView scrollView:(UIScrollView *) scrollView imageView:(UIImageView *) imageView availableHeight:(float) availableHeight instructionText:(NSString *) instructionText ninePatchImageName:(NSString *) ninePatchImageName  imageViewOrigin:(float) imageViewOrigin  forView:(UIView *) targetView  {
    
    UIImage * ninePatchImage = [UIImage imageNamed:ninePatchImageName];
    
    float left   =  0.0;
    float top    =  0.0;
    float bottom =  0.0;
    float right  =  0.0;
    
    float kPadding = 20.0;
    
    float screenWidth = targetView.frame.size.width - kPadding * 2; //Not mandatory : Avoid background image using complete width of the screen
    
    float backgroundViewWidth = screenWidth ;
    
    //  if ( instructionText.length < 1)   return; Uncomment this if you don't want diplay when no text present
    
    BOOL isNinePatch = NO;
    
    if ([ninePatchImageName rangeOfString:@".9"].location == NSNotFound)  { //Not a nine patch image
        
        isNinePatch = NO;
    }
    else if(ninePatchImageName.length < 1) {
        
        isNinePatch = NO;
    }else {
        
        isNinePatch = YES;
    }
    
    if (ninePatchImage == nil) return;
    
    scrollView.clipsToBounds = YES;
    imageView.contentMode  = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES;
     
    NSDictionary * edges   = [self returnCapInsetsForTextPadding:ninePatchImage];
    
    if (isNinePatch) {
        
        left  = [edges[@"left"] floatValue];
        
        right = [edges[@"right"] floatValue];
        
        //If image scale greater than the size, then scale it down
        left  =  (left * backgroundViewWidth ) / ninePatchImage.size.width;
        right = (right * backgroundViewWidth) / ninePatchImage.size.width;
        
    }
    
    if ( left < 0.0)  left = 0.0;
    
    if ( right < 0.0)   right = 0.0;
    
    float orginX = left;
    
    //[1] content & background frame : width calculation
    
    float contentViewWidth = backgroundViewWidth - right - orginX;
    
    //Calculate Available Height
    NSString * lineHeightString = @"<style type='text/css'>  div, span, p {  line-height:1.33em; } </style>";
    
    NSString * resultString =  [instructionText stringByAppendingString:lineHeightString];
    
    labelView =  [self returnRichInstructionTextForLabel:labelView :resultString overWrite:YES fontSize:12.0f maxLabelWidth:contentViewWidth maxLabelHeight:9999];
    
    //Force the labelView width to be equal to contentWidth. or else, center attributte will not effect.
    if (labelView.frame.size.width < contentViewWidth) {
        CGRect labelViewFrame = labelView.frame;
        labelViewFrame.size.width = contentViewWidth;
        labelView.frame = labelViewFrame;
    }
    
    //[2] content & background frame : Height calculation
    float labelHeight = labelView.frame.size.height;
    float contentViewHeight = ( labelHeight > availableHeight ) ? availableHeight : labelHeight ;
    
    if (isNinePatch) {
        
        imageView.image = [self createResizableNinePatchImage:ninePatchImage];
        
    }
    else{
        
        imageView.image = ninePatchImage;
    }
    
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES;
    
    if (isNinePatch) {
        
        top    = [edges[@"top"] floatValue];
        bottom = [edges[@"bottom"] floatValue];
        
        top    = (top    * availableHeight ) / ninePatchImage.size.height;
        bottom = (bottom * availableHeight ) / ninePatchImage.size.height;
    }
    
    if (top < 0.0) {
        top = 0.0;
    }
    
    if (bottom < 0.0) {
        bottom = 0.0;
    }
    
    float originY = top;
    
    float backgroundHeight = contentViewHeight + bottom + top;
    
    if (backgroundHeight > availableHeight) {
        
        backgroundHeight  = availableHeight;
        contentViewHeight = backgroundHeight - top - bottom;
    }
        
    imageView.frame = CGRectMake(kPadding, imageViewOrigin, backgroundViewWidth , backgroundHeight);
    
    scrollView.frame = CGRectMake(orginX, originY, contentViewWidth, contentViewHeight );
    
    scrollView.contentSize = CGSizeMake(contentViewWidth, labelView.frame.size.height);
}


@end

