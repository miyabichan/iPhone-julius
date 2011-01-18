//
//  JuliusSampleViewController.h
//  JuliusSample
//
//  Created by Watanabe Toshinori on 11/01/15.
//  Copyright 2011 FLCL.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "MBProgressHUD.h"
#import "Julius.h"

@interface JuliusSampleViewController : UIViewController<AVAudioRecorderDelegate, JuliusDelegate> {
	
	// UI
	UIButton *recordButton;
	UITextView *textView;
	MBProgressHUD *HUD;

	AVAudioRecorder *recorder;
	Julius *julius;
	NSString *filePath;
	BOOL processing;
}

@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) Julius *julius;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, assign) BOOL processing;

- (IBAction)startOrStopRecording:(id)sender;

@end

