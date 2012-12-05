//
//  WorkoutCreationCompletedViewController.m
//  Fitness4Me
//
//  Created by Ciby  on 05/12/12.
//
//

#import "WorkoutCreationCompletedViewController.h"
#import "FitnessServerCommunication.h"
;
@interface WorkoutCreationCompletedViewController ()

@end

@implementation WorkoutCreationCompletedViewController
@synthesize workout;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickLetsGo:(id)sender {
    
    
    FitnessServerCommunication *fitness= [FitnessServerCommunication sharedState];
    [fitness saveCustomWorkout:workout userID:@"117" userLevel:@"1" language:2 activityIndicator:nil progressView:nil onCompletion:^(NSString *workoutID) {
        if (workoutID>0) {
            
        }
    
     }onError:^(NSError *error) {
        // [self getExcersices];
     }];
    
//    FitnessServerCommunication *fitness =[[FitnessServerCommunication alloc]init];
//    [fitness parserExcersiceDetailsForWorkoutID:self.workoutID userLevel:@"1" language:2 activityIndicator:nil progressView:nil onCompletion:^(NSString *responseString) {
//        NSMutableArray *object = [responseString JSONValue];
//        excersices = [[NSMutableArray alloc]init];
//        [self getWorkoutVideoData:object];
//        [self insertExcersices];
//        [self getExcersices];
//    }onError:^(NSError *error) {
//        [self getExcersices];
//    }];
//
    
}


//- (void)getWorkoutVideoData:(NSMutableArray *)object {
//    
//    NSMutableArray *itemsarray =[object valueForKey:@"items"];
//    NSString *workoutID =self.workoutID;
//    int workouts =[workoutID intValue];
//    [itemsarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSDictionary* item = obj;
//        [excersices addObject: [[Excersice alloc]initWithData:workouts:[item objectForKey :@"poster_video"]:[item objectForKey:@"poster_name"]:[item objectForKey:@"poster_rep"]:[item objectForKey:@"main_video"]:[item objectForKey:@"video_name"]:[item objectForKey:@"main_rep"]:[item objectForKey:@"stop_video"]:[ item objectForKey:@"stop_name"]:[item objectForKey:@"stop_rep"]:[item objectForKey:@"otherside_poster"]:[item objectForKey:@"otherside_postername"]:[item objectForKey:@"otherside_posterrep"]:[item objectForKey:@"otherside_video"]:[item objectForKey:@"otherside_name"]:[item objectForKey:@"otherside_rep"]:[ item objectForKey:@"recovery_video"]:[ item objectForKey:@"recovery_video_name"]:[item objectForKey :@"next_video"]:[item objectForKey:@"next_name"]:[item objectForKey :@"next_rep"]:[item objectForKey:@"completed_video"]:[item objectForKey :@"completed_name"]:[ item valueForKey:@"completed_rep"]]];
//    }];
//    
//    
//}
//
//
//-(void)insertExcersices
//{
//    [self initilaizeDatabase];
//    [excersiceDB insertExcersices:excersices];
//    
//}
//
////method to get Excersices related to a workout
//-(void)getExcersices
//{
//    excersicesList = [[NSMutableArray alloc]init];
//    [self initilaizeDatabase];
//    NSString *workoutID =[self workoutID];
//    int workouts =[workoutID intValue];
//    [excersiceDB getExcersices:workouts];
//    
//    if([excersiceDB.Excersices count]>0){
//        excersicesList =excersiceDB.Excersices;
//    }
//    [NSThread detachNewThreadSelector:@selector(startDownload) toTarget:self withObject:nil];
//}
//
//
//-(void)initilaizeDatabase
//{
//    excersiceDB =[[ExcersiceDB alloc]init];
//    [excersiceDB setUpDatabase];
//    [excersiceDB createDatabase];
//}
//
//
//
//-(void)startDownload
//{
//    
//    
//    
//    NSString *videoPath=[NSString getVideoPath];
//    
//    dataPath = [Fitness4MeUtils path];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
//        //Create Folder
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//    
//    for (int i=0; i<[excersicesList count]; i++) {
//        NSString *PosterUrl= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"PosterUrl"]];
//        NSString *PosterName= [[excersicesList objectAtIndex: i] valueForKey: @"PosterName"];
//        [self downloadVideos:PosterUrl:PosterName];
//        
//        NSString *videoUrl = [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"VideoUrl"]];
//        NSString *Name =  [[excersicesList objectAtIndex: i] valueForKey: @"Name"];
//        [self downloadVideos:videoUrl:Name];
//        
//        NSString *stopVideo= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i]  valueForKey: @"StopVideo"]];
//        NSString *stopName= [[excersicesList objectAtIndex: i]  valueForKey: @"StopName"];
//        if ([stopName length]>0) {
//            [self downloadVideos:stopVideo:stopName];
//        }
//        
//        NSString *otherSidePoster= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"OtherSidePoster"]];
//        NSString *othersidePosterName= [[excersicesList objectAtIndex: i] valueForKey: @"OthersidePosterName"];
//        if ([othersidePosterName length]>0) {
//            [self downloadVideos:otherSidePoster:othersidePosterName];
//        }
//        
//        NSString *othersideVideo= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"OthersideVideo"]];
//        NSString *othersideName= [[excersicesList objectAtIndex: i] valueForKey: @"OthersideName"];
//        if ([othersideName length]>0) {
//            [self downloadVideos:othersideVideo:othersideName];
//        }
//        
//        NSString *recoveryVideoUrl= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"RecoveryVideoUrl"]];
//        NSString *recoveryVideoName= [[excersicesList objectAtIndex: i] valueForKey: @"RecoveryVideoName"];
//        if ([recoveryVideoName length]>0) {
//            [self downloadVideos:recoveryVideoUrl:recoveryVideoName];
//        }
//        
//        NSString *nextVideo= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"NextVideo"]];
//        NSString *nextName= [[excersicesList objectAtIndex: i] valueForKey: @"NextName"];
//        if ([nextName length]>0) {
//            [self downloadVideos:nextVideo:nextName];
//        }
//        
//        NSString *completedVideo= [videoPath stringByAppendingString:[[excersicesList objectAtIndex: i] valueForKey: @"CompletedVideo"]];
//        NSString *completedName= [[excersicesList objectAtIndex: i] valueForKey: @"CompletedName"];
//        if ([completedName length]>0) {
//            [self downloadVideos:completedVideo:completedName];
//        }
//        
//    }
//    stop=stop+1;
//    if ([excersicesList count]>0){
//        //[self.letsgoButton setEnabled:YES];
//        //[self.letsgoButton  setHidden:NO];
//      //  [self.backButton  setEnabled:YES];
//    }
//    else {
//        [self performSelectorOnMainThread:@selector(ShowVideounAvaialableMessage)
//                               withObject:nil
//                            waitUntilDone:YES];
//        
//    }
//    
//    if (stop==[excersicesList count]) {
//       // [signUpView removeFromSuperview];
//        
//    }
//    
//    
//}
//
//
////method to Download videos related to a workout
//-(void)downloadVideos:(NSString *)url:(NSString*)name{
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//    NSString *dataPath1 = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
//    NSString  *filepath =[dataPath1 stringByAppendingPathComponent :name];
//    
//    BOOL isReachable =[Fitness4MeUtils isReachable];
//    
//    if (isReachable){
//        
//        // Check If File Does Exists if not download the video
//        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]){
//            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//            [request setDownloadDestinationPath:filepath];
//            [request setDelegate:self];
//            [request setTimeOutSeconds:15];
//            [request startSynchronous];
//        }else {
//            stop=stop+1;
//            if (stop==[excersicesList count]) {
//               // if([signUpView superview]!=nil){
//               //     [signUpView removeFromSuperview];
//                //}
//                if ([excersicesList count]>0){
//                  //  [letsgoButton setEnabled:YES];
//                   // [letsgoButton setHidden:NO];
//                  //  [backButton setEnabled:YES];
//                }
//                
//            }
//        }
//    }
//    else {
//        
//        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]){
//            //
//            
//            stopz=stopz+1;
//            if (stopz==1) {
//                
//                //[letsgoButton setEnabled:NO];
//                //[letsgoButton setHidden:YES];
//                //[backButton setEnabled:NO];
//                //[self performSelectorOnMainThread:@selector(navigateToHome)
//                                       withObject:nil
//                                    waitUntilDone:YES];
//                // [self navigateToHome];
//                
//                return;
//                
//            }
//            
//        }
//        else {
//            stop=stop+1;
//            if (stop==[excersicesList count]) {
//                if ([excersicesList count]>0){
//                //    [letsgoButton setEnabled:YES];
//                //    [letsgoButton setHidden:NO];
//                //    [backButton setEnabled:YES];
//                }
//            }
//        }
//    }
//}
//


@end
