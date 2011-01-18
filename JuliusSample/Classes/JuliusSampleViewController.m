//
//  JuliusSampleViewController.m
//  JuliusSample
//
//  Created by Watanabe Toshinori on 11/01/15.
//  Copyright 2011 FLCL.jp. All rights reserved.
//

#import "JuliusSampleViewController.h"

@interface JuliusSampleViewController ()
- (void)recording;
- (void)recognition;
@end


@implementation JuliusSampleViewController

@synthesize recordButton;
@synthesize textView;
@synthesize HUD;
@synthesize recorder;
@synthesize julius;
@synthesize filePath;
@synthesize processing;


#pragma mark -
#pragma mark Actions

- (IBAction)startOrStopRecording:(id)sender {
	if (!processing) {
		[self recording];

		[recordButton setTitle:@"Stop" forState:UIControlStateNormal];

	} else {
		[recorder stop];

		[recordButton setTitle:@"Record" forState:UIControlStateNormal];
	}
	
	self.processing = !processing;
}


#pragma mark -
#pragma mark Private methods

- (void)recording {
	
	// Create file path.
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yMMddHHmmss"];
	NSString *fileName = [NSString stringWithFormat:@"%@.wav", [formatter stringFromDate:[NSDate date]]];
	[formatter release];

	self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];

	// Change Audio category to Record.
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];

	// Settings for AVAAudioRecorder.
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM], AVFormatIDKey,
							  [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
							  [NSNumber numberWithUnsignedInt:1], AVNumberOfChannelsKey,
							  [NSNumber numberWithUnsignedInt:16], AVLinearPCMBitDepthKey,
							  nil];

	self.recorder = [[[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:filePath] settings:settings error:nil] autorelease];
	recorder.delegate = self;

	[recorder prepareToRecord];
	[recorder record];
}

- (void)recognition {
	if (!julius) {
		self.julius = [Julius new];
		julius.delegate = self;
	}
	
	[julius recognizeRawFileAtPath:filePath];
}


#pragma mark -
#pragma mark AVAudioRecorder delegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
	if (flag) {
		if (!HUD) {
			self.HUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
			HUD.labelText = @"Processing...";
			[self.view addSubview:HUD];
		}
		
		[HUD show:YES];
		
		[self performSelector:@selector(recognition) withObject:nil afterDelay:0.1];
	}
}


#pragma mark -
#pragma mark Julius delegate

- (void)callBackResult:(NSArray *)results {
	[HUD hide:YES];

	// Show results.
	textView.text = [results componentsJoinedByString:@""];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.recorder = nil;
	self.julius = nil;
    self.filePath = nil;
	
	self.recordButton = nil;
	self.textView = nil;
	self.HUD = nil;
    [super dealloc];
}

@end
