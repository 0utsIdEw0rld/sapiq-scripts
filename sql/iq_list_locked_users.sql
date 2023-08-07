select      upper(u.user_name) as login_name,     
cast(@@servername as varchar(50)) as server_name,     
'locked by login policy' as reason_locked,     
cast(SUSER_NAME() as varchar(250)) as updated_by,     
cast(getdate() as datetime) as updated_dttm 
from      sysuser u,      
(select lp.login_policy_id, lp.login_policy_name       
from  sys.sysloginpolicy lp,             
sys.sysloginpolicyoption lpo      
where           lp.login_policy_id = lpo.login_policy_id  
and lpo.login_option_name = 'locked'       
and login_option_value = 'On') locked 
where      u.login_policy_id = locked.login_policy_id  

union all  select   
   upper(u.user_name) as login_name,     
cast(@@servername as varchar(50)) as server_name,     
'password expired' as reason_locked,     
cast(SUSER_NAME() as varchar(250)) as updated_by,     
cast(getdate() as datetime) as updated_dttm 
from  
    sysuser u,      
(select lp.login_policy_id, lpo.login_option_name, 
cast(lpo.login_option_value as integer) as password_life_time     
from  sys.sysloginpolicy lp,          
sys.sysloginpolicyoption lpo     
where lp.login_policy_id = lpo.login_policy_id     
and lpo.login_option_name = 'password_life_time'     
and lpo.login_option_value != 'unlimited') password_life_time, 
where      u.login_policy_id = password_life_time.login_policy_id 
and u.password_creation_time + password_life_time < cast(getdate() as date)  
union all  select      upper(u.user_name) 
as login_name,     cast(@@servername as varchar(50)) as server_name,     
'maximum failed logins exceeded' as reason_locked,     
cast(SUSER_NAME() as varchar(250)) as updated_by,     
cast(getdate() as datetime) as updated_dttm 
from      sysuser u,      (select lp.login_policy_id, lpo.login_option_name, 
cast(lpo.login_option_value as integer) as max_failed_login_attempts     
from
    sys.sysloginpolicy lp, 
    sys.sysloginpolicyoption lpo     
where lp.login_policy_id = lpo.login_policy_id     
and lpo.login_option_name = 'max_failed_login_attempts'     
and lpo.login_option_value != 'unlimited') max_failed_login_attempts 
where      u.login_policy_id = max_failed_login_attempts.login_policy_id 
and u.failed_login_attempts > max_failed_login_attempts

