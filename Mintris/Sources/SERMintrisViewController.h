//
//  SERMintrisViewController.h
//  Mintris
//
//  Created by Stanley Rost on 15.09.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SERMintrisViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

- (IBAction)startButtonPressed:(id)sender;
- (IBAction)stopButtonPressed:(id)sender;

- (IBAction)leftButtonPressed:(id)sender;
- (IBAction)righButtonPressed:(id)sender;
- (IBAction)downButtonPressed:(id)sender;
- (IBAction)rotateLeftButtonPressed:(id)sender;
- (IBAction)rotateRightButtonPressed:(id)sender;

@end
