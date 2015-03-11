//
//  ViewController.m
//  CameraDemo
//
//  Created by Erik Svedäng on 11/03/15.
//  Copyright (c) 2015 Erik Svedäng. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation ViewController

- (NSString*)cachePath {
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = dirs[0];
    NSString *completePath = [documentDirectory stringByAppendingPathComponent:@"cached2.png"];
    return completePath;
}

- (void)saveImageToCache:(UIImage*)image {
    NSData *data = UIImagePNGRepresentation(self.photo.image);
    BOOL success = [data writeToFile:[self cachePath] atomically:YES];
    if(!success) {
        NSLog(@"Failed to save image to cache");
    }
}

- (IBAction)onTakePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.photo.image = image;
    [self saveImageToCache:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    UIImage *image = [UIImage imageWithContentsOfFile:self.cachePath];
    if(image) {
        self.photo.image = image;
    } else {
        NSLog(@"Failed to fetch image %@ from file system", self.cachePath);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
