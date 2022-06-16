#use the database 
USE capstonedb;
# create table 
CREATE TABLE IF NOT EXISTS bike_trips
(ride_id varchar(255),
rideable_type varchar(255),
started_at TIMESTAMP NOT NULL,
ended_at TIMESTAMP NOT NULL,
started_at_date DATE NOT NULL,
started_at_time TIME NOT NULL,
ended_at_date DATE NOT NULL,
ended_at_time TIME NOT NULL,
ride_length TIME NOT NULL,
ride_day VARCHAR(255),
ride_month VARCHAR(50),
start_station_name VARCHAR(255),
start_station_id VARCHAR(255),
end_station_name VARCHAR(255),
end_station_id VARCHAR(255),
start_lat DOUBLE,
start_lng DOUBLE,
end_lat DOUBLE,
end_lng DOUBLE,
member_type VARCHAR(255));
#
# verfiy if table has been added tables
SHOW TABLES;
#
#import data into table using data import wizard
#check if the data has been loaded up right 
SELECT *
FROM capstonedb.bike_trips;
#
#Create index for the data 
CREATE INDEX ride_index ON bike_trips(ride_id);
#
# Assigning unique and primary key
ALTER TABLE capstonedb.bike_trips
ADD column unique_id int NOT NULL auto_increment primary key;
#
#total count of the rides
SELECT COUNT(ride_id) AS total_rides
FROM capstonedb.bike_trips;
#
#find duplicates in ride_id
SELECT COUNT(DISTINCT ride_id)
FROM capstonedb.bike_trips;
#
#rideable_type count based on bike type and membership
SELECT member_type,rideable_type,
COUNT(*) AS total_rideables
FROM capstonedb.bike_trips
GROUP BY member_type,rideable_type;
#
#monthly count of rides
SELECT ride_month,
Count(*) AS monthy_rides
FROM capstonedb.bike_trips
GROUP BY ride_month;
#
#ride counts based on days
SELECT
ride_day,
COUNT(*) AS ride_count_days
FROM capstonedb.bike_trips
GROUP BY ride_day;
#
#ride counts for weekends
SELECT
ride_day,
COUNT(ride_day) as day_count
FROM capstonedb.bike_trips
WHERE ride_day = 'saturday' OR ride_day = 'sunday'
GROUP BY ride_day
ORDER BY day_count desc;
#
#ride counts for weekdays
SELECT
ride_day,
COUNT(ride_day) as day_count
FROM capstonedb.bike_trips
WHERE ride_day = 'monday' OR ride_day = 'tuesday' OR ride_day = 'wednesday'
OR ride_day = 'thursday' OR ride_day = 'friday'
GROUP BY ride_day
ORDER BY day_count desc;

#extracting ride month name 
SELECT ride_id,started_at_date,unique_id,MONTHNAME(started_at_date) AS month_name
FROM capstonedb.bike_trips;
#
#add a new column with month name
ALTER TABLE table_1 
ADD ride_month varchar(255) NOT NULL
AFTER ride_day;
#
#update month name column
UPDATE table_1
SET ride_month = MONTHNAME(started_at_date);
#
#ride count per hour
SELECT member_type,EXTRACT(HOUR FROM started_at) AS time_of_day, count(*) as num_of_rides
FROM capstonedb.bike_trips
GROUP BY member_type, time_of_day;
#
#rideables and days relationship  
SELECT ride_day,rideable_type,
COUNT(rideable_type) AS total_rideables
FROM capstonedb.bike_trips
GROUP BY ride_day,rideable_type;
#
#rideables and months 
SELECT ride_month,rideable_type,
COUNT(rideable_type) AS total_rideables
FROM capstonedb.bike_trips
GROUP BY ride_month,rideable_type;
#
#membership and days relationship  
SELECT ride_day,rideable_type, member_type,
COUNT(rideable_type) AS total_rideables
FROM capstonedb.bike_trips
GROUP BY ride_day,rideable_type,member_type;
#
#membership and months relationship  
SELECT ride_month,rideable_type, member_type,
COUNT(rideable_type) AS total_rideables
FROM capstonedb.bike_trips
GROUP BY ride_month,rideable_type,member_type;
#
#MAX rides station counts
SELECT COUNT(ride_id),start_station_name
FROM capstonedb.bike_trips
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY COUNT(ride_id) DESC;
#
#Rides for station count 
SELECT COUNT(start_station_name) AS ride_count_stn,
start_station_name
FROM capstonedb.bike_trips
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name;
#
#Average ride duration
SELECT member_type, 
      ride_day, 
      ROUND(AVG(ride_length), 0) AS avg_ride_length,
      AVG(AVG(ride_length)) OVER(PARTITION BY member_type) AS combined_avg_ride_time
FROM capstonedb.bike_trips
GROUP BY member_type, ride_day;
#
#Docking Station locations casual
SELECT start_station_name, 
      ROUND(AVG(start_lat), 4) AS start_lat, 
      ROUND(AVG(start_lng), 4) AS start_lng,  
      count(*) AS num_of_rides
   FROM capstonedb.bike_trips
   WHERE member_type = 'casual' AND start_station_name <> 'On Bike Lock' 
   GROUP BY start_station_name;
#
#Docking Station locations member
SELECT start_station_name,
      ROUND(AVG(start_lat), 4) AS start_lat, 
      ROUND(AVG(start_lng), 4) AS start_lng,  
      count(*) AS num_of_rides
   FROM capstonedb.bike_trips
   WHERE member_type = 'member' AND start_station_name <> 'On Bike Lock' 
   GROUP BY start_station_name;
#
#Ending bike station for members
SELECT end_station_name,
      ROUND(AVG(start_lat), 4) AS end_lat, 
      ROUND(AVG(start_lng), 4) AS end_lng,  
      count(*) AS num_of_rides
   FROM capstonedb.bike_trips
   WHERE member_type = 'member' AND end_station_name <> 'On Bike Lock'
   GROUP BY end_station_name;
#
#Ending bike station for casual
SELECT end_station_name,
      ROUND(AVG(start_lat), 4) AS end_lat, 
      ROUND(AVG(start_lng), 4) AS end_lng,  
      count(*) AS num_of_rides
   FROM capstonedb.bike_trips
   WHERE member_type = 'casual' AND end_station_name <> 'On Bike Lock'
   GROUP BY end_station_name;
#
#### THE END ###