//
//  EditorViewController.m
//  SVG-MASK
//
//  Created by Nurbolat Yerdikul on 10/19/16.
//  Copyright © 2016 Nurbolat Yerdikul. All rights reserved.
//

#import "EditorViewController.h"
#import <SVGgh/SVGDocumentView.h>
#import <SVGgh/SVGRenderer.h>
#import "SVGViewerViewController.h"
#import "SegueIdentifiers.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVGViewerViewController.h"

@interface EditorViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet SVGDocumentView *svgDocumentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewCenterY;

@property (nonatomic) CGPoint trayOriginalCenter;

@end

@implementation EditorViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDesign];
}

- (void)setupDesign {
    _svgDocumentView.backgroundColor = [UIColor clearColor];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:kImageURLString]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self showSVG];
}

- (void)showSVG {
    if (_svgDocumentView.renderer == nil) {
        _svgDocumentView.renderer =  [[SVGRenderer alloc] initWithString:[self generateSVGStringWithView:_svgDocumentView imageTagString:nil]];
    }
}

- (NSString *)generateSVGStringWithView:(UIView *)view imageTagString:(NSString *)imageTagString  {
    NSString *svgString = [self getSVGFileString];
    NSString *imageTag = imageTagString == nil ? @"" : imageTagString;
    CGFloat width = _svgDocumentView.frame.size.width;
    CGFloat height = _svgDocumentView.frame.size.height;
    
    NSString *result = [NSString stringWithFormat:svgString, width, height, width, height, imageTag, width, height, width, height, (int)round(width / 2), (int)round(height / 2)];
    return result;
}

- (NSString *)getSVGFileString {
    NSString *svgFilePath = [[NSBundle mainBundle] pathForResource:kSVGFileName ofType:@"svg"];
    
    NSError* error = nil;
    NSString* svgString = [NSString stringWithContentsOfFile:svgFilePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    if(error) {
        NSLog(@"ERROR while loading from file: %@", error);
    }
    return svgString;
}

#pragma mark - Action

- (IBAction)didPanGestrure:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _trayOriginalCenter = CGPointMake(_imageViewCenterX.constant, _imageViewCenterY.constant);
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        _imageViewCenterX.constant = _trayOriginalCenter.x + translation.x;
        _imageViewCenterY.constant = _trayOriginalCenter.y + translation.y;
        [_imageView layoutIfNeeded];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowSVGViewerViewController]) {
        [self prepareForShowSVGViewerViewControllerSegue:segue sender:sender];
    }
}

- (void)prepareForShowSVGViewerViewControllerSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SVGViewerViewController *svgViewerViewController = [segue destinationViewController];
    NSURL *filePath = [self generateSVGFileAndSave];
    svgViewerViewController.openFilePath = filePath;
}

#pragma mark - Helper

- (NSURL *)generateSVGFileAndSave {
    NSString *imageTag = [NSString stringWithFormat:@"<image xlink:href=\"%@\" x=\"%f\" y=\"%f\" height=\"%fpx\" width=\"%fpx\"/>", kImageURLString, _imageView.frame.origin.x, _imageView.frame.origin.y, _imageView.frame.size.height, _imageView.frame.size.width];
    NSString *svgFinaleGenerated = [self generateSVGStringWithView:_svgDocumentView imageTagString:imageTag];

    NSURL *documentsPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *path = [documentsPath URLByAppendingPathComponent:kExportFileName];
    NSError* error = nil;

    [svgFinaleGenerated writeToURL:path atomically:false encoding:NSUTF8StringEncoding error:&error];
    
    if(error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Что-то пошло не так...", comment: @"") message:NSLocalizedString(@"Ошибка при записи SVG файла", comment: @"") preferredStyle:UIAlertControllerStyleActionSheet];
        [self presentViewController:alertController animated:true completion:nil];
    } else {
        return path;
    }
    return nil;
}


@end
