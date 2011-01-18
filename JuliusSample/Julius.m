//
//  Julius.m
//  JuliusSample
//
//  Created by Watanabe Toshinori on 11/01/15.
//  Copyright 2011 FLCL.jp. All rights reserved.
//

#import "Julius.h"


@implementation Julius

@synthesize delegate;


#pragma mark -
#pragma mark Julis Callback methods

static void output_result(Recog *recog_, void *data) {

	WORD_INFO *winfo;
	WORD_ID *seq;
	int seqnum;
	int n,i;
	Sentence *s;
	RecogProcess *r;

	NSMutableArray *words = [NSMutableArray array];
	
	for(r = recog_->process_list; r; r = r->next) {
		
		if (! r->live) continue;
		
		if (r->result.status < 0) continue;
		
		winfo = r->lm->winfo;
		for(n = 0; n < r->result.sentnum; n++) {
			s = &(r->result.sent[n]);
			seq = s->word;
			seqnum = s->word_num;

			for(i = 0; i < seqnum; i++) {
				[words addObject:[NSString stringWithCString:winfo->woutput[seq[i]] encoding:NSJapaneseEUCStringEncoding]];
			}
		}
	}

	// Callback delegate.
	if (data) {
		Julius *julius = (Julius *)data;
		if (julius.delegate) {
			[julius.delegate callBackResult:[NSArray arrayWithArray:words]];
		}
	}
}

#pragma mark -
#pragma mark Initialize

- (id)init {
	if (self = [super init]) {
		
		Jconf *jconf;
		
		/* create a configuration variables container */
		NSString *path = [[NSBundle mainBundle] pathForResource:@"light" ofType:@"jconf"];
		jconf = j_jconf_new();
		if (j_config_load_file(jconf, (char *)[path UTF8String]) == -1) {
			NSLog(@"Error in loading file");
			return nil;
		}
		
		if (j_jconf_finalize(jconf) == FALSE) {
			NSLog(@"Error in finalize");
			return nil;
		}
		
		/* create a recognition instance */
		recog = j_recog_new();
		/* assign configuration to the instance */
		recog->jconf = jconf;
		/* load all files according to the configurations */
		if (j_load_all(recog, jconf) == FALSE) {
			NSLog(@"Error in loadn model");
			return nil;
		}
		
		/* checkout for recognition: build lexicon tree, allocate cache */
		if (j_final_fusion(recog) == FALSE) {
			NSLog(@"Error while setup work area for recognition");
			j_recog_free(recog);
			return nil;
		}
		
		if (j_adin_init(recog) == FALSE) {
			NSLog(@"Error while adin init");
			j_recog_free(recog);
			return nil;
		}
		
		/* output system information to log */
		j_recog_info(recog);
		
		/* if no grammar specified on startup, start with pause status */
		{
			RecogProcess *r;
			boolean ok_p;
			ok_p = TRUE;
			for(r=recog->process_list;r;r=r->next) {
				if (r->lmtype == LM_DFA) {
					if (r->lm->winfo == NULL) { /* stop when no grammar found */
						j_request_pause(recog);
					}
				}
			}
		}
		
		callback_add(recog, CALLBACK_RESULT, output_result, self);
	}
	
	return self;
}


#pragma mark -
#pragma mark Actions

- (void)recognizeRawFileAtPath:(NSString *)path {
	
	int ret = j_open_stream(recog, (char *)[path UTF8String]);
	if (ret == -1) {
		NSLog(@"Error in open stream");
		return;
	}
	
	ret = j_recognize_stream(recog);
	if (ret == -1) {
		NSLog(@"Error in regocnize stream");
		return;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	j_recog_free(recog);

	[super dealloc];
}

@end
