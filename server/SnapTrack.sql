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

INSERT INTO food VALUES
	("apple" , "fruits" , 20 ),
    ("apricot", "fruits", 20),
    ("banana", "fruits", 20),
    ("avocado", "fruits", 20),
    ("cherry", "fruits", 20),
    ("chestnut", "fruits", 20),
    ("coconut", "fruits", 20),
    ("grape", "fruits", 20),
    ("grapefruit", "fruits", 20),
    ("hazelnut", "fruits", 20),
    ("kiwi", "fruits", 20),
    ("lemon", "fruits", 20),
    ("mango", "fruits", 20),
    ("orange", "fruits", 20),
    ("peach", "fruits", 20),
    ("pear", "fruits", 20),
    ("pineapple", "fruits", 20),
    ("plum", "fruits", 20),
    ("raspberry", "fruits", 20),
    ("strawberry", "fruits", 20),
    ("tomato", "fruits", 20),
    ("walnut", "fruits", 20);