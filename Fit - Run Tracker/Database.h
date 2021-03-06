//
//  Database.h
//  CG4 Coursework
//
//  Created by William Ray on 22/12/2014.
//  Copyright (c) 2014 William Ray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>

@interface Database : NSObject {
    sqlite3 *_database; //Local instance variable
}

@property NSString *databasePath; //Property that stores the path to the database

/* Declare the public functions */
+(Database*)init;

//Runs
-(void)saveRun:(NSObject *)Run;
-(NSArray *)loadRunsWithQuery:(NSString *)query;

-(BOOL)saveShoe:(NSObject *)shoe ToRun:(NSObject *)run;

-(BOOL)deleteRun:(NSObject *)run;

//Plans
-(NSObject *)createNewPlanWithName:(NSString*)name startDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;
-(BOOL)savePlannedRun:(NSObject *)plannedRun ForPlan:(NSObject *)plan;

-(NSArray *)loadAllTrainingPlans;
-(NSArray *)loadPlannedRunsForPlan:(NSObject *)plan;

-(BOOL)deletePlan:(NSObject *)plan;
-(BOOL)deletePlannedRun:(NSObject *)plannedRun;

//Shoes
-(NSArray *)loadAllShoes;

-(void)saveShoe:(NSObject *)shoe;
-(void)increaseShoeMiles:(NSObject *)shoe byAmount:(double)amount;
-(void)decreaseShoeMiles:(NSObject *)shoe byAmount:(double)amount;

-(BOOL)shoeNameExists:(NSString *)shoeName;

-(BOOL)deleteShoe:(NSObject *)shoe;

@end
