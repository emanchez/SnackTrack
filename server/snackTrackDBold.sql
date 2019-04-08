 drop database SnapTrack;
 create database SnapTrack;
 use SnapTrack;

create table food (

food_name	varchar(50),
food_group	varchar(50),
calories	int,
primary key (food_name)

);

create table user_profile(
/* Login s*/
email 			varchar(50),
usr_password 	varchar(200),
/* Profile Information */
firstname		varchar(50),
lastname		varchar(50),
dateOfBirth		Date, /* YYYY-MM-DD*/
weight 			double,
height 			float,

primary key(email)
);

create table log(
/*Going to be updates whenever a user confirms food consumption*/
email 	varchar(50),
food_name	varchar(50),
time_stamp	datetime,

foreign key(email) references user_profile(email),
foreign key(food_name) references food(food_name)

/* Metric function will take an email and  optional date range,
ex: one week, or 2 months etc. The function will then query this table based on the input 
and gather calorie count based on of food_name */
);
