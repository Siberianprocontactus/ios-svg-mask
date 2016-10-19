//
//  SVGViewerViewController.m
//  SVG-MASK
//
//  Created by Nurbolat Yerdikul on 10/19/16.
//  Copyright © 2016 Nurbolat Yerdikul. All rights reserved.
//

#import "SVGViewerViewController.h"

@interface SVGViewerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation SVGViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSVGFile];
}

- (void)loadSVGFile {
    [_webView loadRequest:[NSURLRequest requestWithURL:_openFilePath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
