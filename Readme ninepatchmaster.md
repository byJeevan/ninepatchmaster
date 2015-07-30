# Nine Patch Master
Nine patch master is a fully functional Objectve-C library for iOS. It make use of left, right, top, bottom edge values from given nine patch image and creates expandable area according to text size/frame.
 
### Version
1.0.0

### Usage
Create  3 key views in your ViewController.
     
    UIImageView * imageView;
    UIScrollView * scrollView;
    UILabel * lableView;

Note : Don't forget to add scroll view delegate !

In viewDidLoad, allocate these views.

    imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    scrollView = [[UIScrollView alloc] init];
    [imageView addSubview:scrollView];
    scrollView.delegate = self;
    lableView = [[UILabel alloc] init];
    [scrollView addSubview:lableView];

In viewDidLayoutSubviews, call the applyNinePathImageForLabel method

    + (void) applyNinePathImageForLabel:(UILabel *) labelView scrollView:(UIScrollView *) scrollView imageView:(UIImageView *) imageView availableHeight:(float) availableHeight instructionText:(NSString *) instructionText ninePatchImageName:(NSString *) ninePatchImageName  imageViewOrigin:(float) imageViewOrigin  forView:(UIView *) targetView


### Installation
Add the `ninepatchmaster.h` and `ninepatchmaster.m`  files into your project. Import ninePatchMaster class.
 