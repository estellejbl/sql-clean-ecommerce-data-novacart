
/* -------------------------------------------------------------------------
   📍 E-commerce Dataset Cleaning
   Company: Nova Cart (E-commerce Retailer)
   -------------------------------------------------------------------------
   🎯 Context:
  	 This SQL project focuses on cleaning and standardizing an AI-generated 
	 e-commerce dataset to make it reliable and ready for analysis.

   Business objectives an questions:
   - Ensure the uniqueness and integrity of key identifiers 
     (user_id, session_id, email).
   - Standardize tracking dimensions (source, campaign, device, country, etc.)
     to enable consistent acquisition and attribution analysis.
   - Normalize dates and engagement metrics (bounce_rate, session_duration,
     conversions, revenue) for accurate reporting.
   - Deliver a clean base table that can be used for funnel analysis,
     channel performance, and customer behavior insights.
   
   🧪 Dataset Overview:
    Rows: 50   columns: 20  
   - User Information: user_id, email, country, city, age, gender, loyalty_status
   - Session Data: session_id, page_views, session_duration, bounce_rate
   - Acquisition: source, medium, campaign
   - Dates: date, signup_date, last_purchase_date
   - Performance: conversions, revenue
   
   
   Analysis Roadmap:
	STEP 1 — Remove duplicates (user_id, email, session_id).  
	STEP 2 — Clean acquisition fields (source, medium, campaign).  
	STEP 3 — Standardize user attributes (device, country, city, gender, loyalty and dates).  
	STEP 4 — Clean performance metrics (bounce_rate, session_duration, conversions).  
	STEP 5 — Produce a fully cleaned final dataset.
   
   ------------------------------------------------------------------------- */


ALTER TABLE public.jeu_de_donn_es_e_commerce_r_aliste 
RENAME TO ecommerce;

SELECT * FROM public.ecommerce LIMIT 10;

-- STEP 1 — Remove duplicates (user_id, email, session_id).   -------------------------------

select user_id 
from public.ecommerce
group by user_id
having count(user_id) <> 1 -- two user_id duplicates (user_300 and user_36)

select *
from public.ecommerce
where user_id = 'user_300' or  user_id = 'user_36'
order by 1

select *  
from public.ecommerce
where  user_id = 'user_298' or  user_id = 'user_299'  or  user_id = 'user_300'  or  user_id = 'user_301'
order by 1 -- user_301 availble → replace one user_300 with user_301

select *  
from public.ecommerce
where  user_id = 'user_35' or  user_id = 'user_36'  or  user_id = 'user_36'  or  user_id = 'user_37'
order by 1 -- all user selected is availble → replace one user_36 with user_37

select Replace(user_id,'user_300','user_301') as user_id
from public.ecommerce
where email = 'tracey198@yahoo.com'
select Replace(user_id,'user_36','user_37') as user_id
from public.ecommerce
where email = 'jason178@hotmail.com'


update public.ecommerce  
set user_id = Replace(user_id,'user_300','user_301') 
where email = 'tracey198@yahoo.com'

update public.ecommerce  
set user_id = Replace(user_id,'user_36','user_37')
where email = 'jason178@hotmail.com'


select user_id 
from public.ecommerce
group by user_id
having count(user_id) <> 1 -- no more user_id duplicates 

select session_id 
from public.ecommerce
group by session_id
having count(session_id) <> 1 -- no session_id duplicates

select email 
from public.ecommerce
group by email
having count(email) <> 1 -- no email duplicates




-- STEP 2 — Clean acquisition fields (source, medium, campaign)   -------------------------------

-- Clean source: incorrect words and inconsistent casing, empty values, and unify social media platforms
select 
	case
		when replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook') = 'Instagram'  
		or  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook')  = 'Facebook'
		or  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook')  = 'Linkedin' then 'Social media'
		when  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook') = '' then 'Unknown'
		else  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook')
	end as source
from public.ecommerce
group by 1

-- Clean email: replace "@example" with "@gmail.com" and deleted empty values
select REPLACE(email, 'example', 'gmail.com')
from public.ecommerce
where email  != ''


-- clean medium :  mix of upper and lower case and white spaces and one empty value 
SELECT trim(initcap(medium)) as medium
from public.ecommerce
where trim(medium) != ''
group by 1


-- clean campaing : empty value and Unknown campaigns
select case when campaign is null then 'Unknown' else campaign end as campaign
from  public.ecommerce
where trim(campaign) != ''
group by 1

-- Clean the relationship between source, medium
select  
	case
		when replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook') = 'Instagram'  
		or  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook')  = 'Facebook'
		or  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook')  = 'Linkedin' then 'Social media'
		when  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook') = '' then 'Unknown'
		else  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook')
	end as source,
	medium
from  public.ecommerce
where medium  != ''  and source  != ''
group by 1,2
/* 
	We will not include medium in the final dataset because its relationship 
	with source is inconsistent. There is no reliable way to determine the correct medium,
	and deleting rows with incorrect source–medium pairs would cause unnecessary data loss. 
	So, the medium field is excluded from the final output.
*/


-- STEP 3 — Standardize user attributes (device, country, city, gender, loyalty and date)  -------------------------------

-- clean device and and empty values to 'Unknown'
select trim(initcap(device))
from  public.ecommerce
where device  != '' 
group by 1

-- Clean and standardize country: convert 'france' to 'FR' and empty values to 'Unknown'
case when country ='france' then 'FR' when country = ''  then 'Unknown' else country end  as country,
from public.ecommerce
group by 1

-- clean city empty values to 'Unknown'
select 
case when city = ''  then 'Unknown' else city end as city
from public.ecommerce
group by 1

-- clean gender empty values to 'Unknown'
select  case when gender = ''  then 'Unknown' else gender end as gender
from public.ecommerce
group by 1

-- clean loyalty_status empty values to 'Unknown'
select case when loyalty_status = ''  then 'Unknown' else loyalty_status end as loyalty_status,
from public.ecommerce
group by 1
	
-- clean date
select 
 CASE
    WHEN replace(replace(date,'/','-'),'2025-??---','2025-01-01') ~ '^\d{4}-\d{2}-\d{2}$' THEN replace(replace(date,'/','-'),'2025-??---','2025-01-01')
    WHEN replace(replace(date,'/','-'),'2025-??---','2025-01-01') ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_CHAR(TO_DATE(replace(replace(date,'/','-'),'2025-??---','2025-01-01'), 'DD-MM-YYYY'), 'YYYY-MM-DD')
    ELSE replace(replace(date,'/','-'),'2025-??---','2025-01-01')end as date
from  public.ecommerce


-- STEP 4 — Clean performance metrics (bounce_rate, session_duration, conversions).-------------------------------

-- clean conversions null -> 0 
select case when conversions is null then 0 else conversions end
from public.ecommerce
group by 1


-- clean bounce_rate
select case when bounce_rate not like '%\%' then concat(bounce_rate,'%') else bounce_rate end as bounce_rate
from public.ecommerce
group by 1

-- clean session_duration
select concat(session_duration,' sec')session_duration
from public.ecommerce
group by 1



-- STEP 5 — Cleaned final dataset.  -------------------------------

select
	user_id,
	session_id,
	case when email = ''  then 'Unknown' else REPLACE(email, 'example', 'gmail.com') end as email,
	case
		when replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook') = 'Instagram'  
		or  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook')  = 'Facebook'
		or  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook')  = 'Linkedin' then 'Social media'
		when  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook') = '' then 'Unknown'
		else  replace(replace(initcap(source),'Gooogle','Google'),'Facebok','Facebook')
	end as source,
	case when campaign = ''  then 'Unknown' else campaign end as campaign,
	case when device = ''  then 'Unknown' else trim(initcap(device)) end as device,
	CASE
    	WHEN replace(replace(date,'/','-'),'2025-??---','2025-01-01') ~ '^\d{4}-\d{2}-\d{2}$' THEN replace(replace(date,'/','-'),'2025-??---','2025-01-01')
   		WHEN replace(replace(date,'/','-'),'2025-??---','2025-01-01') ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_CHAR(TO_DATE(replace(replace(date,'/','-'),'2025-??---','2025-01-01'), 'DD-MM-YYYY'), 'YYYY-MM-DD')
    ELSE replace(replace(date,'/','-'),'2025-??---','2025-01-01')end as date,
	case when country ='france' then 'FR' when country = ''  then 'Unknown' else country end  as country,
	case when city = ''  then 'Unknown' else city end as city,
	age,
	case when gender = ''  then 'Unknown' else gender end as gender,
	case when loyalty_status = ''  then 'Unknown' else loyalty_status end as loyalty_status,
	page_views,
	concat(session_duration,' sec') as session_duration,
	case when bounce_rate not like '%\%' then concat(bounce_rate,'%') else bounce_rate end as bounce_rate,
	case when conversions is null then 0 else conversions end as conversions,
	revenue,
	signup_date,
	last_purchase_date
from public.ecommerce
