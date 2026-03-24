delimiter //
    create trigger assist
    before insert on goals for each row
    begin
    if new.scored_by = new.assist_by
    then signal sqlstate '11500'
    set message_text = "One can't assist himself";
    end if;
    end;
    //


  
  delimiter +
  create trigger penalty
  before insert on goals for each row
  begin
  if new.goal_type = 'Penalty'
  and new.assist_by is not null
  then signal sqlstate '11600'
  set message_text = "Penalties can't be assisted";
  end if;
  end;
  +
  delimiter ;