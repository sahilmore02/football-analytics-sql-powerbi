-- STANDINGS
CREATE VIEW big as
	select
		team_name as Team,
        home_team AS Home,
        htg,
        atg,
        away_team as Away,
        Winner
        from teams
        join matches on teams.team_name=matches.home_team or
        teams.team_name=matches.away_team;      

CREATE VIEW standings as
	select
		rank() over(order by count(case when winner = Team then 1 end)*3+count(case when winner = 'draw' then 1 end)*1 DESC,
					(ifnull(sum(case when home = Team then htg end),0) + ifnull(sum(case when away = Team then atg end),0))-(ifnull(sum(case when home = Team then atg end),0) + ifnull(sum(case when away = team then htg end),0)) desc,
                    (ifnull(sum(case when home = Team then atg end),0) + ifnull(sum(case when away = team then htg end),0)) desc,
                    Team) as '#',
		Team as TEAM,
		count(*) as M,
		count(case when winner = Team then 1 end) as W,
		count(case when winner = 'draw' then 1 end) as D,
		count(case when winner <> Team and Winner <> 'draw' then 1 end) as L,
		(ifnull(sum(case when home = Team then htg end),0) + ifnull(sum(case when away = Team then atg end),0)) as GF,
		(ifnull(sum(case when home = Team then atg end),0) + ifnull(sum(case when away = team then htg end),0)) as GA,
		(ifnull(sum(case when home = Team then htg end),0) + ifnull(sum(case when away = Team then atg end),0))-(ifnull(sum(case when home = Team then atg end),0) + ifnull(sum(case when away = team then htg end),0)) as GD,
		count(case when winner = Team then 1 end)*3+count(case when winner = 'draw' then 1 end)*1 as PTS
		from big
		group by Team
		order by
        PTS desc,
        GD desc,
        GF desc,
        TEAM;

-- MOST GOALS
CREATE VIEW Most_Goals as
	select
		scored_by,
        scored_for,
        count(*) as Goals
        from goals
        where goal_type <> 'own goal'
        group by scored_by,scored_for
        order by Goals desc,scored_by,scored_for;
    
-- MOST ASSISTS
CREATE VIEW Most_Assists as
	select
		assist_by,
        scored_for,
        count(*) as Assists
        from goals
        where assist_by is not null
        group by assist_by,scored_for
        order by Assists desc,assist_by,scored_for;
        
-- MOST GA
CREATE VIEW Most_GA as
	select
		player_name as Player,
		team_name as Team,
		IFNULL(Goals,0) as Goals,
		IFNULL(Assists,0) as Assists,
		IFNULL(Goals,0)+IFNULL(Assists,0) as GA 
		from players
		left join most_goals on players.player_name=most_goals.scored_by
		left join most_assists on players.player_name=most_assists.assist_by
		where IFNULL(Goals,0)+IFNULL(Assists,0) <> 0
		order by GA desc,Goals desc,Player,Team;
        
-- MOST OWN GOALS        
create view Most_OG as
select
	scored_by,
    count(*) as 'Own Goals'
    from goals
    where goal_type = 'Own Goal'
    group by scored_by;