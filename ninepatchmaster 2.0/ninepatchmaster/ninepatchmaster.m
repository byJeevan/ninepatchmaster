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
    
    for (int index = 0; index <= bottomBarRgba.count - 1; index++) {
        NSArray* aColor = bottomBarRgba[index];
        if ([aColor[3] floatValue] == 1) {
            left = index;
            break;
        }
    }
    
    for (int index = (int)bottomBarRgba.count - 1; index >= 0; index--) {
        NSArray* aColor = bottomBarRgba[index];
        if ([aColor[3] floatValue] == 1) {
            right = index;
            break;
        }
    }
    
    for (int index = left + 1; index <= right - 1; index++) {
        NSArray* aColor = bottomBarRgba[index];
        if ([aColor[3] floatValue] < 1) {
            NSAssert(NO, @"The 9-patch PNG format is not supported.");
        }
    }
    
    for (int index = 0; index <= rightBarRgba.count - 1; index++) {
        NSArray* aColor = rightBarRgba[index];
        if ([aColor[3] floatValue] == 1) {
            top = index;
            break;
        }
    }
    
    for (int index = (int)rightBarRgba.count - 1; index >= 0; index--) {
        NSArray* aColor = rightBarRgba[index];
        if ([aColor[3] floatValue] == 1) {
            bottom = index;
            break;
        }
    }
    
    for (int index = top + 1; index < bottom; index++) {
        NSArray* aColor = rightBarRgba[index];
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


+ (NSAttributedString *) returnRichTextForString:(NSString *) inputString {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[inputString dataUsingEncoding:NSUTF8StringEncoding]  options:@{
                                                                                                                                                                  NSDocumentTypeDocumentAttribute:  NSHTMLTextDocumentType,
                                                                                                                                                                  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                                                                                                  }
                                                                               documentAttributes:nil
                                                                                            error:nil];
    
    
    return attributedString;
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

+ (void) applyNinePatchImage : (UIImage *)imageNinePatch withText:(NSString *) text forView:(UIView *) view {
    
    if (text.length > 0 ) {
        
        if (imageNinePatch != nil) {
            
            //Prepare the elements
            
            UIImageView * imageView = [[UIImageView alloc] init];
            
            [view addSubview:imageView];
            
            UILabel * labelView = [[UILabel alloc] init];
            
            [imageView addSubview:labelView];
            
            
            UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] init];
            activityIndicator.center = view.center;
            [view addSubview:activityIndicator];
            [activityIndicator startAnimating];
            activityIndicator.hidesWhenStopped = YES;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
                
                //Get the edges from the nine patch image.
                
                NSDictionary * edges   = [self returnCapInsetsForTextPadding:imageNinePatch];
                
                float edgeTop = [edges[@"top"] floatValue];
                float edgeLeft = [edges[@"left"] floatValue];
                float edgeBottom = [edges[@"bottom"] floatValue];
                float edgeRight = [edges[@"right"] floatValue];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    

                    [activityIndicator startAnimating];
                    
                    //Dynamic frame calculation for the lable.
                     [self returnRichInstructionTextForLabel:labelView :text overWrite:YES fontSize:25.0f maxLabelWidth:view.frame.size.width -  edgeLeft - edgeRight  maxLabelHeight:999.0];
                    
                    
                    //Use edges from nine patch image to create resizable image background
                    UIImage * imageFromNinePatch = [[self createResizableNinePatchImage:imageNinePatch] resizableImageWithCapInsets:UIEdgeInsetsMake(edgeTop, edgeLeft, edgeBottom, edgeRight) resizingMode:UIImageResizingModeStretch];
                    
                    imageView.image = imageFromNinePatch;
                    
                    imageView.frame = CGRectMake(0, 0, edgeLeft + edgeRight + labelView.frame.size.width , labelView.frame.size.height + edgeTop + edgeBottom  );
                    
                    //Set new labelview position for its frame.
                    CGRect lableFrameNew  = labelView.frame;
                    lableFrameNew.origin.x = edgeLeft;
                    lableFrameNew.origin.y = edgeTop;
                    labelView.frame  = lableFrameNew;
                    
           
                });
                
            });
            
        }
        else NSLog(@"Nine Image not found ! ");
        
    }
    else NSLog(@"Text is empty string !");
    
}



@end

