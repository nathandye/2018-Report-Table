--PCO Recruitment
SELECT tur.foname, DATE (rep.reporting_week) as 'Reporting Week', re.surveyresponsename as 'Metric', COUNT (*) as 'progress'
FROM org_sp_wa_vansync_live.responses_myc_live as a 
		LEFT JOIN org_sp_wa_vansync_live.dnc_surveyresponses as re 
			on re.surveyresponseid = a.surveyresponseid
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as tur 
			on tur.vanid = a.myc_vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep
			on rep.days = a.datecanvassed
	WHERE a.committeeid = 59691
		AND a.surveyquestionid = 270589
		AND re.surveyresponsename LIKE 'Returned Paperwork'
		AND DATE (a.datecanvassed) > '2017-11-08'
	GROUP BY 1,2,3
	Union
-- Active Hosts		
	SELECT 	b.foname, 
			DATE (rep.reporting_week)as 'Reporting Week',
			'Active Hosts' as 'Metric',
			COUNT (*) as 'progress'
	FROM (SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid'
			FROM org_sp_wa_vansync_live.event_attendees_live as eve
			WHERE eve.committeeid = 59691
				AND eve.eventcalendarname LIKE 'Canvass'
				AND eve.volunteeractivityname LIKE 'Host'
				AND eve.mrr_statusname IN ('Completed', 'Walk In')
				AND eve.eventdate > CURRENT_DATE - INTERVAL '30 Days'	
		) as sub
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 	
			on sub.myc_vanid = b.vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = CURRENT_DATE 
		GROUP BY 1,2
UNION
-- Lapsed Hosts
	SELECT 	b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Lapsed Hosts' as 'Metric',
			COUNT (*) as 'progress'
	FROM (SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid'
			FROM org_sp_wa_vansync_live.event_attendees_live as eve
			WHERE eve.committeeid = 59691
				AND eve.eventcalendarname LIKE 'Canvass'
				AND eve.volunteeractivityname LIKE 'Host'
				AND eve.mrr_statusname IN ('Completed', 'Walk In')
				AND eve.eventdate < CURRENT_DATE - INTERVAL '30 Days'	
			) as sub1
		LEFT JOIN 
			(SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid'
			FROM org_sp_wa_vansync_live.event_attendees_live as eve
			WHERE eve.committeeid = 59691
				AND eve.eventcalendarname LIKE 'Canvass'
				AND eve.volunteeractivityname LIKE 'Host'
				AND eve.mrr_statusname IN ('Completed', 'Walk In')
				AND eve.eventdate > CURRENT_DATE - INTERVAL '30 Days'	
			) as sub2
				on sub1.myc_vanid = sub2.myc_vanid 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 	
			on sub1.myc_vanid = b.vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = CURRENT_DATE 
		WHERE sub2.myc_vanid IS NULL
		GROUP BY 1,2
UNION
--Walk Attempts	
	SELECT 	b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Walk Attempts' as 'Metric',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_voter_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_turf as b 	
			on con.precinctid = b.precinctid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
	WHERE con.committeeid = 59691
		AND YEAR (con.datecanvassed) = 2018
		AND b.committeeid = 59691
		AND con.contacttype_name LIKE 'Walk'
	GROUP BY 1,2,3
UNION
--Active Volunteers		
	SELECT 	b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Active Vols' as 'Metric',
			COUNT (*) as 'progress'
	FROM (SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid'
			FROM org_sp_wa_vansync_live.event_attendees_live as eve
			WHERE eve.committeeid = 59691
				AND eve.eventcalendarname LIKE 'Canvass'
				AND eve.mrr_statusname IN ('Completed', 'Walk In')
				AND eve.eventdate > CURRENT_DATE - INTERVAL '30 Days'	
		) as sub
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 	
			on sub.myc_vanid = b.vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = CURRENT_DATE 
		GROUP BY 1,2
Union
-- Lapsed Vols
	SELECT 	b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Lapsed Vols' as 'Metric',
			COUNT (*) as 'progress'
	FROM (SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid'
			FROM org_sp_wa_vansync_live.event_attendees_live as eve
			WHERE eve.committeeid = 59691
				AND eve.eventcalendarname LIKE 'Canvass'
				AND eve.mrr_statusname IN ('Completed', 'Walk In')
				AND eve.eventdate < CURRENT_DATE - INTERVAL '30 Days'	
			) as sub1
		LEFT JOIN 
			(SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid'
			FROM org_sp_wa_vansync_live.event_attendees_live as eve
			WHERE eve.committeeid = 59691
				AND eve.eventcalendarname LIKE 'Canvass'
				AND eve.mrr_statusname IN ('Completed', 'Walk In')
				AND eve.eventdate > CURRENT_DATE - INTERVAL '30 Days'	
			) as sub2
				on sub1.myc_vanid = sub2.myc_vanid 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 	
			on sub1.myc_vanid = b.vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = CURRENT_DATE 
		WHERE sub2.myc_vanid IS NULL
		GROUP BY 1,2		
UNION 
--Vol Rec Calls	
	SELECT 	b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Vol Rec Calls' as 'Metric',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_myc_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
		 on b.vanid = con.myc_vanid
	LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
	WHERE con.committeeid = 59691
		AND YEAR (con.datecanvassed) = 2018
		AND con.call_attempt = 1
	GROUP BY 1,2,3
UNION
--Vol Rec Contacts	
	SELECT 	b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Vol Rec Contacts' as 'Metric',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_myc_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
		 on b.vanid = con.myc_vanid
	LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
	WHERE con.committeeid = 59691
		AND YEAR (con.datecanvassed) = 2018
		AND con.successful_contact = 1
		AND con.call_attempt = 1
	GROUP BY 1,2,3	
UNION
-- Shifts Scheduled By Week
	SELECT c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week',
		CONCAT (a.eventcalendarname, ' Shifts Scheduled By Week') as 'Metric',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.RSVP_date 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.RSVP_date > CURRENT_DATE - INTERVAL '30 Days'
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training', 'Meeting')
	GROUP BY 1,2,3
UNION	
-- Shifts Scheduled Yesterday
	SELECT c.foname, 
		DATE (CURRENT_DATE - INTERVAL '1 Days') as 'Reporting Week',
		CONCAT (a.eventcalendarname, ' Shifts Scheduled Yesterday') as 'Metric',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.RSVP_date 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.RSVP_date = CURRENT_DATE - INTERVAL '1 Days'
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training','Meeting')
	GROUP BY 1,2,3	
UNION	
-- Shifts Scheduled By Week
	SELECT c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week',
		CONCAT ('Upcoming Shifts: ',a.eventcalendarname) as 'Metric',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep
			on rep.days = a.eventdate
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.RSVP_date BETWEEN CURRENT_DATE AND  CURRENT_DATE + INTERVAL '20 Days'
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training','Meeting')
	GROUP BY 1,2,3	
UNION 
--Volunteer Turnout Rate
SELECT c.foname, 
		CURRENT_DATE as 'Reporting Week',
		CONCAT (a.eventcalendarname, ' Turnout Rate') as 'Metric',
		SUM (a.attended)/COUNT (*) as 'progress'
FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep
			on rep.days = a.eventdate
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
WHERE a.RSVP IS NOT NULL
	AND a.eventdate BETWEEN CURRENT_DATE - INTERVAL '40 DAYS' and CURRENT_DATE - INTERVAL '1 Days'
	AND a.committeeid = 59691
	AND a.eventcalendarname IN ('Canvass', 'Phone Banks')
GROUP BY 1,2,3