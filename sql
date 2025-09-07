-- information about messages
with message as(
select date_add(s.date, interval es.sent_date day) as date,
sp.country,
a.send_interval,
a.is_verified,
a.is_unsubscribed,
0 as account_cnt,
count(distinct es.id_message) AS sent_msg,
count(distinct eo.id_message) AS open_msg,
count(distinct ev.id_message) AS vist_msg 
from `data-analytics-mate.DA.email_sent` es
left join `data-analytics-mate.DA.email_open` eo
ON es.id_message = eo.id_message
left join `data-analytics-mate.DA.email_visit` ev
on es.id_message = ev.id_message
join `data-analytics-mate.DA.account_session` acs
on es.id_account = acs.account_id
join `data-analytics-mate.DA.account` a
on a.id = acs.account_id
join `data-analytics-mate.DA.session_params` sp
ON acs.ga_session_id = sp.ga_session_id
join `data-analytics-mate.DA.session` s
on s.ga_session_id = sp.ga_session_id
group by date, sp.country, a.send_interval,
a.is_verified,
a.is_unsubscribed),


-- information about accounts
account as(
select s.date, sp.country,
send_interval,
is_verified,
is_unsubscribed,
count(a.id) as account_cnt,
0 AS sent_msg,
0 AS open_msg,
0 AS vist_msg
from `data-analytics-mate.DA.account_session` acs
join `data-analytics-mate.DA.account` a
on a.id = acs.account_id
join `data-analytics-mate.DA.session_params` sp
ON acs.ga_session_id = sp.ga_session_id
join `data-analytics-mate.DA.session` s
on s.ga_session_id = sp.ga_session_id
group by s.date, sp.country,
send_interval,
is_verified,
is_unsubscribed),


-- join message and accounts
message_account as (
select *
from message
union all
select *
from account
),


-- total count created accounts and send messages 
total_cnt as(
select date, country,
send_interval,
is_verified,
is_unsubscribed,
sum(account_cnt) as total_account_cnt,
sum(sent_msg) as total_sent_cnt,
sum(open_msg) as open_msg,
sum(vist_msg) as visit_msg,
from message_account
group by 1,2,3,4,5
),


-- total number of accounts created and emails sent per country
total_country_cnt as (
select date, country,
send_interval,
is_verified,
is_unsubscribed,
total_account_cnt,
total_sent_cnt,
open_msg,
visit_msg,
sum (total_account_cnt) over (partition by country) as total_country_account_cnt,
sum (total_sent_cnt) over (partition by country) as total_country_sent_cnt
from total_cnt
),


--counting up the accounts and letters
rank_total as(
select date, country,
send_interval,
is_verified,
is_unsubscribed,
total_account_cnt as account_cnt,
total_sent_cnt as sent_msg,
open_msg,
visit_msg,
total_country_account_cnt,
total_country_sent_cnt,
dense_rank() over (order by total_country_account_cnt desc) as rank_total_country_account_cnt,
dense_rank() over (order by total_country_sent_cnt desc) as rank_total_country_sent_cnt
from total_country_cnt
)


-- main query
select *
from rank_total
where rank_total_country_account_cnt <= 10
or rank_total_country_sent_cnt <= 10
