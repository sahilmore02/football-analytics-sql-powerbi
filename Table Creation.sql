create database prem;
use prem;

-- #1 teams table
create table teams (
	team_id int unique,
    team_name varchar(100) unique,
    home_ground varchar(150) unique,
    city varchar(25));

-- #2 players table
create table players(
	player_id int unique,
    player_name varchar(100) unique ,
    player_age int not null,
    playing_role varchar(20),
    team_name varchar(100),
    jersey_no int not null,
    foreign key (team_name) references teams(team_name));
    
-- #3 matches table
create table matches(
	match_no int primary key,
    GW int,
    home_team varchar(100),
    HTG int,
    ATG int,
    away_team varchar(100),
    winner varchar(100),
    potm varchar(100),
    stadium varchar(150),
    city varchar(100),
    referee varchar(100),
    foreign key (home_team) references teams(team_name),
    foreign key (away_team) references teams(team_name),
    foreign key (stadium) references teams(home_ground),
    foreign key (potm) references players(player_name));

-- #4 goals table
create table goals(
	goal_no int primary key,
    scored_for varchar(150),
    scored_by varchar(150),
    minute int,
    half varchar(6),
    assist_by varchar(150),
    goal_type varchar(25),
    scored_ag varchar(150),
    match_no int,
    foreign key (scored_for) references teams(team_name),
    foreign key (scored_ag) references teams(team_name),
    foreign key (scored_by) references players(player_name),
    foreign key (assist_by) references players(player_name),
    foreign key (match_no) references matches(match_no)
    );