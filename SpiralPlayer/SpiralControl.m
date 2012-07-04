#import "SpiralControl.h"

#define DEGREES_PER_UNIT_VALUE 1 // how many degress are per second of audio for example
#define ARCLENGTH_PER_UNIT_VALUE 2                                                                                                                                                                                                                                                                                    

@interface SpiralControl(PrivateMethods)
- (void) setCurrentAngleDegrees: (double) angleDeg;
- (void) setCurrentAngleRadians: (double) angleRad;
- (void) setCurrentArcLength:    (double) arclength;
- (void) updateNeedlePosition;
- (void) drawSpiral;
- (void) numOfTurns;
@end

@implementation SpiralControl     

@synthesize value = value_, maximumValue = maximumValue_, samples = samples_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
               
        self.backgroundColor = [UIColor lightGrayColor];        
        
        //centerX_ = 380; // x-coordinate of the center of the spiral
        //centerY_ = 512; // y-coordinate of the center of the spiral 
        centerX_ = 360/2;
        centerY_ = 480/2;
        dSpace_ = 50.0; // space between succesive turns of the spiral
        currentAngleRad_ = 0;
        currentAngleDeg_ = 0;
        currentLevel_ = 0;
        dataReady_ = NO;

        //Player thumb needle
        thumb_ = [UIButton buttonWithType:UIButtonTypeCustom];
        thumb_.frame=CGRectMake(0, 0, 50, 52);
        thumb_.center = CGPointMake(centerX_, centerY_);         
        [thumb_ addTarget:self action:@selector(dragThumbBegan:withEvent:) forControlEvents:UIControlEventTouchDown];
        [thumb_ addTarget:self action:@selector(dragThumbContinue:withEvent:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragOutside];
        [thumb_ addTarget:self action:@selector(dragThumbEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [thumb_ setImage:[UIImage imageNamed:@"handle"] forState:UIControlStateNormal];
        [self addSubview:thumb_];
     
    }
    return self;
}

#pragma mark - THUMB NEEDLE TOUCH EVENT HANDLERS

/*Handle event of first touch of the thumb needle*/
- (void) dragThumbBegan:(UIControl *)control withEvent:(UIEvent *)event {
    currentLevel_ = (int)ceil(currentAngleDeg_/360.0) - 1;
    degreeAtCurrentLevel_ = currentAngleDeg_ - currentLevel_*360;
    radianAtCurrentLevel_ = currentAngleRad_ - currentLevel_*2*M_PI;
    
    if (degreeAtCurrentLevel_ <= 90) {
        currentQuarter_ = 1;
    } else if (degreeAtCurrentLevel_>90 && degreeAtCurrentLevel_<=180) {
        currentQuarter_ = 2;
    } else if (degreeAtCurrentLevel_>180 && degreeAtCurrentLevel_ <=270) {
        currentQuarter_ = 3;
    } else if (degreeAtCurrentLevel_>270 && degreeAtCurrentLevel_<=360){
        currentQuarter_ = 4;
    }
    NSLog(@"Began Drag Thumb -- Degree:%f Rad:%f Level:%i", degreeAtCurrentLevel_, radianAtCurrentLevel_, currentLevel_);
}

/*       
 * Handle events of dragging the thumb needle
 */
- (void) dragThumbContinue:(UIControl*)control withEvent:(UIEvent *)event {
    CGPoint p =[[[event allTouches] anyObject] locationInView:self];
    
    //Move the (x,y) coordinates back to the origin
    double x = p.x - centerX_;
    double y = p.y - centerY_;
  
    //Determine which quarter of the circle we touched. Adjust angle accordingly.
    double cur_level_angle = atan((double)abs(y)/abs(x)); //angle at teh current level only
    if  (x >= 0 && y >= 0) {
        cur_level_angle = cur_level_angle; //I quarter - do nothing.
        if (currentQuarter_ == 4) currentLevel_ += 1;
        currentQuarter_ = 1;
    } else if (x <= 0 && y > 0) {
        cur_level_angle = M_PI - cur_level_angle; //II
        currentQuarter_ = 2;
    } else if (x < 0 && y <= 0) { 
        cur_level_angle = M_PI + cur_level_angle; //III
        currentQuarter_ = 3;
    } else if (x > 0 && y < 0) { 
        cur_level_angle = 2*M_PI - cur_level_angle; //IV
        if (currentQuarter_ == 1) currentLevel_ -= 1;
        currentQuarter_ = 4;
    }     
    
    // Add number of 360 degree turns depending on the turn number
    double total_angle = cur_level_angle + 2*currentLevel_*M_PI;  
    
    // Calculate total arclength
    float arclength = 0;  
    for (int cur = 0; cur < currentLevel_ ; cur++) {
        arclength += 2*M_PI*currentLevel_*dSpace_;
    }
    arclength += cur_level_angle * (currentLevel_ + 1) * dSpace_; //arclength at current level
    
    
    NSLog(@"LEVEL: %i, ANGLE: %f, ARCLENGTH: %f, MAXARCLENTGH: %f", currentLevel_, cur_level_angle*(180.0/M_PI), arclength, maxArcLength_);
    if (arclength > maxArcLength_ || total_angle < 0) return;   
    // If (angle > maxAngleRad_ || angle<0) return; // exceed turn number limit
               
    // Calculate the final coordinates
    [self setCurrentAngleRadians:total_angle]; //update metrics
    [self setCurrentArcLength:arclength];
    [self updateNeedlePosition]; 
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/* Handle event of final touch of the thumb needle */
- (void) dragThumbEnded:(UIControl *)control withEvent:(UIEvent *)event {
    NSLog(@"DRAG ENDED");
}
   

#pragma mark - UIControl TOUCH EVENTS

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Touch Began");
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"Touch Continued");
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //NSLog(@"Touch Ended");
    CGPoint p = [touch locationInView:self];
    
    //Move the (x,y) coordinates back to the origin
    double x = p.x - centerX_;
    double y = p.y - centerY_;
    //Calculate turn number based on the distance from the of origin
    currentLevel_ = floor(sqrt(pow(x,2) + pow(y,2)) / dSpace_); 
    
    //Determine which quarter of the circle we touched. Adjust angle accrodingly.
    double cur_level_angle = atan((double)abs(y)/abs(x));
    
    if  (x>=0 && y>=0) {
        cur_level_angle = cur_level_angle; //I quarter - do nothing.
        currentQuarter_ = 1;
    } else if (x<=0 && y>0) {
        cur_level_angle = M_PI - cur_level_angle; //II
        currentQuarter_ = 2;
    } else if (x<0 && y<=0) { 
        cur_level_angle = M_PI + cur_level_angle; //III
        currentQuarter_ = 3;
    } else if (x>0 && y<0) { 
        cur_level_angle = 2*M_PI - cur_level_angle; //IV
        currentQuarter_ = 4;
    }      
    
    // Add number of 360 degree turns depending on the turn number
    double total_angle = cur_level_angle + 2*currentLevel_*M_PI;  
    // Calculate total arclength
    float arclength = 0;  
    for (int cur = 0; cur < currentLevel_ ; cur++) {
        arclength += 2*M_PI*currentLevel_*dSpace_;
    }
    arclength += cur_level_angle * (currentLevel_ + 1) * dSpace_; //arclength at current level
    
    NSLog(@"LEVEL: %i, ANGLE: %f, ARCLENGTH: %f, MAXARCLENTGH: %f", currentLevel_, cur_level_angle*(180.0/M_PI), arclength, maxArcLength_);
    if (arclength > maxArcLength_ || total_angle < 0) return;    
 
    //Calculate the final coordinates
    [self setCurrentAngleRadians:total_angle]; // update metrics 
    [self setCurrentArcLength:arclength];
    [self updateNeedlePosition];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {[super touchesBegan:touches withEvent:event];}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {[super touchesMoved:touches withEvent:event];}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {[super touchesEnded:touches withEvent:event];}

#pragma mark - DRAWING THE SPIRAL

/*
 * Draw Spiral by drawing a line between each points. (slower method)
 */

- (void)drawSpiralSlow {
    double angle = 0.0;	// Cumulative radians while stepping.
	double newX = centerX_;
    double newY = centerY_;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath (context);
    
    CGColorRef leftcolor = [[UIColor whiteColor] CGColor]; 
    CGColorRef rightcolor = [[UIColor redColor] CGColor];
    
    NSLog(@"SampleCount: %i MaxArc:%f", sampleCount_, maxArcLength_);
         
    int level = 0;
    double currentArc = 0.0;
    int j = 0;
    SInt16* temp_sample = (SInt16*) self.samples.bytes;

    
    for (int i = 0; i <= floor(maxArcLength_); i += ARCLENGTH_PER_UNIT_VALUE) {
        
        if (i > sampleCount_ * ARCLENGTH_PER_UNIT_VALUE) {
            NSLog(@"ERROR: Current Arc Length exceeds sample count");
            break;
        }
                
        // Find current level based on arclength
        j = i;
        level = 0;
        while (j >= 0) {
            level += 1;
            currentArc = j;
            j = j - 2*M_PI*(level*dSpace_); 
        }   
        
        angle = currentArc/(level*dSpace_) + 2*M_PI*(level-1); //total angle
        
        CGContextMoveToPoint(context, newX, newY);
        newX = (dSpace_*angle*cos(angle))/(2*M_PI) + centerX_;
        newY = (dSpace_*angle*sin(angle))/(2*M_PI) + centerY_;
        NSLog(@"Drawing:level:%i i:%i angle:%f newX: %0.0f newY: %0.0f", level, i, angle , newX, newY);
        
        SInt16 left = *temp_sample++;
        NSLog(@"Sample:%i Avergae:%i", left, averageSample_);
        CGColorRef middleColor = [[UIColor colorWithRed:left/32767.0 green:0 blue:0 alpha:1] CGColor];
        CGContextSetStrokeColorWithColor(context, middleColor);
        CGContextSetLineWidth(context, 10*(left/32767.0));
        
//        if (left < averageSample_) {
//            CGContextSetStrokeColorWithColor(context, leftcolor);
//        } else {
//            CGContextSetStrokeColorWithColor(context, rightcolor);
//        }
                   
        if (channelCount_==2) {
            SInt16 right = *temp_sample++;
        } 
                        
        CGContextAddLineToPoint(context, newX, newY);
        CGContextStrokePath(context);
    }
    //CGContextStrokePath(context);
}


- (void)drawRect:(CGRect)rect {
    //UIBezierPath *path = [self spiralPath]; // get your bezier path, perhaps from an ivar?
 
    //[path stroke];
    //CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);



    if (dataReady_ == YES) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        [self drawSpiralSlow];
    }
    
}

#pragma mark - CUSTOM PUBLIC GETTERS AND SETTERS 
-(double) value {
    return value_/ARCLENGTH_PER_UNIT_VALUE;
}

-(void) setValue:(double)value {
    value_ = value * ARCLENGTH_PER_UNIT_VALUE;
    double arclen_temp = value_;
    int level_temp = 0;
    //NSLog(@"%f %f %f", value, value_, arclen_temp);
    //calculete angle using arclength given
    currentAngleRad_ = 0;
    while (arclen_temp >= 0) {
        if (arclen_temp - 2*M_PI*((level_temp+1)*dSpace_) <= 0) {
            currentAngleRad_ += arclen_temp/((level_temp+1)*dSpace_);
        } else  {
            currentAngleRad_ += 2*M_PI;
        }    
        arclen_temp -= 2*M_PI*((level_temp+1)*dSpace_); // decrease full circle of arclength
        level_temp++; // advance to next level
    }
    //currentAngleDeg_ = value * DEGREES_PER_UNIT_VALUE;
    //currentAngleRad_ = value_ * (M_PI/180.0);
    currentAngleDeg_ = currentAngleRad_ * (180.0/M_PI);
    //NSLog(@"Upadated Angle Rad: %f", currentAngleRad_);
    [self updateNeedlePosition];
}

-(double) maximumValue { 
    return maximumValue_;
}

-(void) setMaximumValue:(double)maximumValue {
    maximumValue_ = maximumValue; 
    
    maxAngleDeg_ = maximumValue * DEGREES_PER_UNIT_VALUE; // convert value to degrees
    maxAngleRad_ = maxAngleDeg_ * (M_PI/180.0); // convert to radians
    maxArcLength_ = maximumValue * ARCLENGTH_PER_UNIT_VALUE;
    NSLog(@"maxiumValue:%f maxArcLength:%f", maximumValue, maxArcLength_);
}

#pragma mark - CUSTOM PRIVATE METHODS

- (void) setCurrentAngleDegrees: (double) angleDeg {
    //value_ = angleDeg;
    currentAngleDeg_ = angleDeg;
    currentAngleRad_ = angleDeg * (180.0/M_PI);
}

- (void) setCurrentAngleRadians: (double) angleRad {
    //value_ = (angleRad *(180.0/M_PI));
    currentAngleDeg_ = value_;
    currentAngleRad_ = angleRad;    
}

-(void) setCurrentArcLength: (double) arclength {
    value_ = arclength;
}

/*
 * Update needle position depending on the current angle 
 */
-(void) updateNeedlePosition {
    double newX = (dSpace_*currentAngleRad_*cos(currentAngleRad_))/(2*M_PI) + centerX_;
    double newY = (dSpace_*currentAngleRad_*sin(currentAngleRad_))/(2*M_PI) + centerY_;
    thumb_.center = CGPointMake(newX, newY);
    //NSLog(@"Continue --    turn:%i newX:%0.0f newY:%0.0f x:%0.0f y:%0.0f", turnNum, newX, newY, p.x, p.y);
}

#pragma mark - READ DATA
- (void) drawSpiralForAsset: (AVURLAsset*) songAsset {
    NSError * error = nil;
     
    AVAssetReader * reader = [[AVAssetReader alloc] initWithAsset:songAsset error:&error];
    AVAssetTrack * songTrack = [songAsset.tracks objectAtIndex:0];
    NSDictionary* outputSettingsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                        //     [NSNumber numberWithInt:44100.0],AVSampleRateKey, /*Not Supported*/
                                        //     [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,    /*Not Supported*/
                                        [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsNonInterleaved,
                                        nil];
        
    AVAssetReaderTrackOutput* output = [[AVAssetReaderTrackOutput alloc] initWithTrack:songTrack outputSettings:outputSettingsDict];
    [reader addOutput:output];
    [output release];
    
    UInt32 sampleRate,channelCount;
    NSArray* formatDesc = songTrack.formatDescriptions;
    for(unsigned int i = 0; i < [formatDesc count]; ++i) {
        CMAudioFormatDescriptionRef item = (CMAudioFormatDescriptionRef)[formatDesc objectAtIndex:i];
        const AudioStreamBasicDescription* fmtDesc = CMAudioFormatDescriptionGetStreamBasicDescription (item);
        if(fmtDesc ) {
            sampleRate = fmtDesc->mSampleRate;
            channelCount = fmtDesc->mChannelsPerFrame;
            //    NSLog(@"channels:%u, bytes/packet: %u, sampleRate %f",fmtDesc->mChannelsPerFrame, fmtDesc->mBytesPerPacket,fmtDesc->mSampleRate);
        }
    }
        
    UInt32 bytesPerSample = 2 * channelCount;
    SInt16 normalizeMax = 0;
    NSMutableData * fullSongData = [[NSMutableData alloc] init];
    [reader startReading];    
               
    UInt64    totalBytes = 0;   
    SInt64    totalLeft  = 0;
    SInt64    totalRight = 0;
    NSInteger sampleTally = 0;
    NSInteger maxTally = -1*INFINITY;
    NSInteger totalAmplitude = 0;
    NSInteger totalNumberOfSamples = 0;
    NSInteger samplesPerPixel = sampleRate*2;
     
    while (reader.status == AVAssetReaderStatusReading) {
        
        AVAssetReaderTrackOutput * trackOutput = (AVAssetReaderTrackOutput *)[reader.outputs objectAtIndex:0];
        CMSampleBufferRef sampleBufferRef = [trackOutput copyNextSampleBuffer];
        
        if (sampleBufferRef) {
            CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBufferRef);
            size_t length = CMBlockBufferGetDataLength(blockBufferRef);
            totalBytes += length;
            
            NSAutoreleasePool *wader = [[NSAutoreleasePool alloc] init];
            NSMutableData * data = [NSMutableData dataWithLength:length];
            CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, data.mutableBytes);
            
            SInt16 * samples = (SInt16 *) data.mutableBytes;
            int sampleCount = length / bytesPerSample;
            for (int i = 0; i < sampleCount ; i ++) {
                SInt16 left = *samples++;
                totalLeft  += left;  
               
                SInt16 right;
                if (channelCount==2) {
                    right = *samples++;
                    totalRight += right;
                }
               
                sampleTally++;
                if (left>maxTally) maxTally = left;
                
                //Rinat added this for calculating areas 
                if (sampleTally > samplesPerPixel) {
                    //left  = totalLeft / sampleTally; 
                    left = maxTally;
                    totalAmplitude += left;
                    totalNumberOfSamples += 1;
                    
                    SInt16 fix = abs(left);
                    if (fix > normalizeMax) {
                        normalizeMax = fix;
                    }
                    //NSLog(@"LEFT: %i", left);
                    [fullSongData appendBytes:&left length:sizeof(left)];
                    
                    if (channelCount==2) {
                        right = totalRight / sampleTally; 
                        SInt16 fix = abs(right);
                        if (fix > normalizeMax) normalizeMax = fix;
                        [fullSongData appendBytes:&right length:sizeof(right)];
                    }
                    
                    totalLeft   = 0;
                    totalRight  = 0;
                    sampleTally = 0;
                    maxTally = -1*INFINITY;
                }
            }
            
            [wader drain];
            CMSampleBufferInvalidate(sampleBufferRef);
            CFRelease(sampleBufferRef);
        }
    }    
    
    if (reader.status == AVAssetReaderStatusFailed || reader.status == AVAssetReaderStatusUnknown){
        // Something went wrong. return nil
        NSLog(@"ERROR: ASSET READER FAILED");
        return;
    }
    
    if (reader.status == AVAssetReaderStatusCompleted){
        NSLog(@"rendering output graphics using normalizeMax %d",normalizeMax);
        
        self.samples = fullSongData;
        normalizeMax_ = normalizeMax;
        sampleCount_ = fullSongData.length / 4;
        channelCount_ = channelCount;
        averageSample_ = totalAmplitude/totalNumberOfSamples;
        dataReady_ = YES;
        
    }
       
    [fullSongData release];
    [reader release];
    [self setNeedsDisplay];
    
}


@end
