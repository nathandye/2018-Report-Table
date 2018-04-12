SELECT *
INTO sp_wa_dyen.report_data
FROM (
-- Active Hosts		
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Active Hosts' as 'Metric',
			NULL as 'Event Type',
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
		WHERE b.foname IS NOT NULL
		GROUP BY 1,2,3
UNION
-- Lapsed Hosts
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Lapsed Hosts' as 'Metric',
			NULL as 'Event Type',
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
			AND  b.foname IS NOT NULL
		GROUP BY 1,2,3
UNION
--Walk Attempts	
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Walk Attempts' as 'Metric',
			NULL as 'Event Type',
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
	GROUP BY 1,2,3,4,5
UNION
--Walk Contacts	
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Walk Contacts' as 'Metric',
			NULL as 'Event Type',
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
		AND con.successful_contact = 1
	GROUP BY 1,2,3,4,5
UNION
--Active Volunteers		
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Active Vols' as 'Metric',
			NULL as 'Event Type',
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
		WHERE b.foname IS NOT NULL
		GROUP BY 1,2,3
Union
-- Lapsed Vols
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Lapsed Vols' as 'Metric',
			NULL as 'Event Type',
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
			AND b.foname IS NOT NULL
		GROUP BY 1,2,3		
UNION 
--Vol Rec Calls	
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Vol Rec Calls' as 'Metric',
			NULL as 'Event Type',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_myc_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
		 on b.vanid = con.myc_vanid
	LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
	WHERE con.committeeid = 59691
		AND YEAR (con.datecanvassed) = 2018
		AND con.call_attempt = 1
		AND b.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION
--Vol Rec Contacts	
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Vol Rec Contacts' as 'Metric',
			NULL as 'Event Type',
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
		AND b.foname IS NOT NULL
	GROUP BY 1,2,3,4,5	
UNION
-- Shifts Scheduled By Week
	SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week',
		'Shifts Scheduled By Week' as 'Metric',
		a.eventcalendarname as 'Event Type',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.RSVP_date 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.RSVP_date > CURRENT_DATE - INTERVAL '30 Days'
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training', 'Meeting')
		AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION	
-- Shifts Scheduled Yesterday
	SELECT c.regionname, c.foname, 
		DATE (CURRENT_DATE - INTERVAL '1 Days') as 'Reporting Week',
		'Shifts Scheduled Yesterday' as 'Metric',
		a.eventcalendarname as 'Event Type',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.RSVP_date 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.RSVP_date = CURRENT_DATE - INTERVAL '1 Days'
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training','Meeting')
		AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5	
UNION	
-- Upcoming Shifts
	SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week',
		'Upcoming Shifts' as 'Metric',
		a.eventcalendarname as 'Event Type',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep
			on rep.days = a.eventdate
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.eventdate BETWEEN CURRENT_DATE AND  CURRENT_DATE + INTERVAL '20 Days'
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training','Meeting')
        AND a.RSVP IS NOT NULL
        AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5	
UNION 
--Shifts Coming In Today
	SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week',
		'Shifts Today' as 'Metric',
		a.eventcalendarname as 'Event Type',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep
			on rep.days = a.eventdate
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.eventdate = CURRENT_DATE
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks')
        AND a.RSVP IS NOT NULL
        AND c.foname IS NOT NULL
        AND a.closed IS NULL
	GROUP BY 1,2,3,4,5
UNION
--Volunteer Turnout Rate
SELECT c.regionname, c.foname, 
		CURRENT_DATE as 'Reporting Week',
		CONCAT (a.eventcalendarname, ' Turnout Rate') as 'Metric',
		NULL as 'Event Type',
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
	AND c.foname IS NOT NULL
GROUP BY 1,2,3,4,5
UNION
--DVC Shifts Completed By Week
SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week', 
		'DVC Shifts Completed' as 'Metric',
		a.eventcalendarname as 'Event Type',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.eventdate 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.attended = 1
		AND a.committeeid = 59691
		AND a.eventcalendarname IN  ('Canvass', 'Phone Banks','1:1')
		AND YEAR (a.eventdate) = 2018
		AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5 
UNION
--DVC Shifts Completed Yesterday
SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week', 
		'Shifts Completed Yesterday' as 'Metric',
		a.eventcalendarname as 'Event Type',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.eventdate 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.attended = 1
		AND a.committeeid = 59691
		AND a.eventcalendarname IN  ('Canvass', 'Phone Banks', '1:1')
		AND a.eventdate = CURRENT_DATE - INTERVAL '1 Days'
		AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION
--Trained Hosts never active
SELECT c.regionname, c.foname, 
			CURRENT_DATE as 'Reporting Week',
			'Trained Never Hosted' as 'Metric',
			NULL as 'Event Type',
			COUNT (*) as 'progress'
FROM org_sp_wa_vansync_live.event_attendees_live as a
		LEFT JOIN (SELECT DISTINCT (a.myc_vanid)
					FROM org_sp_wa_vansync_live.event_attendees_live as a
					WHERE a.committeeid = 59691
						AND a.eventcalendarname LIKE 'Canvass'
						AND a.volunteeractivityname LIKE 'Host'
						AND a.RSVP IS NOT NULL
						AND a.attended = 1
					) sub1 
					ON sub1.myc_vanid = a.myc_vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep
			on rep.days = a.eventdate
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
WHERE a.committeeid = 59691
	AND a.eventcalendarname LIKE 'Training'
	AND a.attended = 1
	AND sub1.myc_vanid IS NULL
	AND c.foname IS NOT NULL
GROUP BY 1,2,3,4,5
-- Host Conveyer Belt
UNION       
SELECT b.regionname, b.foname, 
            DATE (rep.reporting_week)as 'Reporting Week',
            sub.active_type as 'Metric',
            NULL as 'Event Type',
            COUNT (*) as 'progress'
    FROM (SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid',
                CASE WHEN MAX (eve.eventdate) >= CURRENT_DATE - INTERVAL '7 Days' THEN 'Hosted 1 Week Ago'
                    WHEN MAX (eve.eventdate) BETWEEN CURRENT_DATE - INTERVAL '14 Days' and CURRENT_DATE - INTERVAL '8 Days' THEN 'Hosted 2 Weeks Ago'
                    WHEN MAX (eve.eventdate) BETWEEN CURRENT_DATE - INTERVAL '21 Days' and CURRENT_DATE - INTERVAL '15 Days' THEN 'Hosted 3 Weeks Ago'
                    WHEN MAX (eve.eventdate) <= CURRENT_DATE - INTERVAL '22 Days' THEN 'Hosted 4+ Weeks Ago'
                    END as 'active_type'
            FROM org_sp_wa_vansync_live.event_attendees_live as eve
            WHERE eve.committeeid = 59691
                AND eve.eventcalendarname LIKE 'Canvass'
                AND eve.volunteeractivityname LIKE 'Host'
                AND eve.mrr_statusname IN ('Completed', 'Walk In')
                AND eve.eventdate > CURRENT_DATE - INTERVAL '30 Days'
            GROUP BY 1
        ) as sub
        LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b     
            on sub.myc_vanid = b.vanid
        LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
            on rep.days = CURRENT_DATE 
        WHERE b.foname IS NOT NULL
        GROUP BY 1,2,3,4,5
UNION
 --Vol Rec Calls Yesterday	
SELECT b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Vol Rec Calls Yesterday' as 'Metric',
			NULL as 'Event Type',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_myc_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
		 on b.vanid = con.myc_vanid
	LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
	WHERE con.committeeid = 59691
		AND con.call_attempt = 1
		AND con.datecanvassed = CURRENT_DATE - INTERVAL '1 days'
		AND b.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION
--Vol Turnout this Week      
SELECT c.regionname, c.foname, 
		rep.reporting_week as 'Reporting Week',
		'Turnout Rate This Week' as 'Metric',
		NULL as 'Event Type',
		SUM (a.attended)/COUNT (*) as 'progress'
FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep
			on rep.days = a.eventdate
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
WHERE a.RSVP IS NOT NULL
	AND a.committeeid = 59691
	AND rep.reporting_week BETWEEN CURRENT_DATE - INTERVAL '7 days' AND CURRENT_DATE - INTERVAL '1 days'
	AND a.eventcalendarname IN ('Canvass', 'Phone Banks')
	AND c.foname IS NOT NULL
GROUP BY 1,2,3,4,5
) as sub;