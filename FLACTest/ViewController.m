//
//  ViewController.m
//  FLAC
//
//  Created by bismark on 8/1/15.
//
//

@import AVFoundation;

#import "ViewController.h"

#define filename @"recit16bit"
#define flac @"flac"
#define wav @"wav"

extern int decode (int argc, const char *argv[]); // decode.c

@interface ViewController () <AVAudioPlayerDelegate>

@property AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row) {
    case 0:
      {
        NSString *input = [[NSBundle mainBundle] pathForResource:filename ofType:flac];
        NSString* output = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", filename, wav]];
        const char *parameter[] = {"decode", [input cStringUsingEncoding:NSUTF8StringEncoding], [output cStringUsingEncoding:NSUTF8StringEncoding]};
        int result = decode (3, parameter);
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Decode" message:[NSString stringWithFormat:@"%d", result] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
          [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
        [controller addAction:ok];
        [self presentViewController:controller animated:YES completion:^{}];
      }
      break;
    case 1:
      {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        if (self.player) {
          if (self.player.isPlaying) {
            [self.player stop];
            [session setActive:NO error:NULL];
          }
        }

        NSString* output = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", filename, wav]];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:output] error:NULL];
        if (player) {
          [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
          [session setActive:YES error:NULL];
          
          [player play];
          self.player = player;
        }
        else {
          UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Play" message:@"Can not start playback" preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
          }];
          [controller addAction:ok];
          [self presentViewController:controller animated:YES completion:^{}];
          break;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
      }
      break;
  }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
  AVAudioSession *session = [AVAudioSession sharedInstance];
  [session setActive:NO error:NULL];
}

@end
