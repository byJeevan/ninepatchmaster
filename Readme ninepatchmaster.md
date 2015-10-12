# Nine Patch Master
Nine patch master is a fully functional Objective-C library for iOS. It make use of left, right, top, bottom edge values from given nine patch image and creates expandable area according to text size/frame.
 
### Version
2.0.0

### Usage
 
In viewDidLayoutSubviews, 

Call applyNinePatchImage method with text and nine patch image as the parameters.

+ (void) applyNinePatchImage : (UIImage *)imageNinePatch withText:(NSString *) text forView:(UIView *) view

### Installation
Add the `ninepatchmaster.h` and `ninepatchmaster.m`  files into your project. Import ‘ninepatchmaster.h’ in your class.
 