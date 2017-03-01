//
//  AudioPlayer.m
//  Swift Release
//
//  Created by beauty on 2/29/16.
//  Copyright © 2016 pixels. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

+(void) playButtonEffectSound
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"buttoneffect" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    
}

+(void) playDeleteEffectSound
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"delete" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    
}

+(void) playAlertEffectSound
{
    
}

@end
