DROP TABLE sp_wa_dyen.report_data;

SELECT *
INTO sp_wa_dyen.report_data
FROM (

--Walk Attempts	
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Walk Attempts' as 'Metric',
			CASE WHEN sta.id IS NOT NULL THEN 'x' ELSE NULL END as 'staff vs vol',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_voter_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_turf as b 	
			on con.precinctid = b.precinctid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = con.canvasserid
	WHERE con.committeeid = 59691
		AND DATE (con.datecanvassed) >= '2018-06-01'
		AND b.committeeid = 59691
		AND con.contacttype_name LIKE 'Walk'
	GROUP BY 1,2,3,4,5
UNION
--Walk Contacts	
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Walk Contacts' as 'Metric',
			CASE WHEN sta.id IS NOT NULL THEN 'x' ELSE NULL END as 'staff vs vol',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_voter_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_turf as b 	
			on con.precinctid = b.precinctid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = con.canvasserid
	WHERE con.committeeid = 59691
		AND DATE (con.datecanvassed) >= '2018-06-01'
		AND b.committeeid = 59691
		AND con.contacttype_name LIKE 'Walk'
		AND con.successful_contact = 1
	GROUP BY 1,2,3,4,5
UNION
--DVC Phone Attempts	
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'DVC Phone Attempts' as 'Metric',
			CASE WHEN sta.id IS NOT NULL THEN 'x' ELSE NULL END as 'staff vs vol',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_voter_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_turf as b 	
			on con.precinctid = b.precinctid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = con.canvasserid
	WHERE con.committeeid = 59691
		AND DATE (con.datecanvassed) >= '2018-06-01'
		AND b.committeeid = 59691
		AND con.contacttype_name LIKE 'Phone'
	GROUP BY 1,2,3,4,5
UNION
--DVC Phone Contacts	
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'DVC Phone Contacts' as 'Metric',
			CASE WHEN sta.id IS NOT NULL THEN 'x' ELSE NULL END as 'staff vs vol',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_voter_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_turf as b 	
			on con.precinctid = b.precinctid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = con.canvasserid	
	WHERE con.committeeid = 59691
		AND DATE (con.datecanvassed) >= '2018-06-01'
		AND b.committeeid = 59691
		AND con.contacttype_name LIKE 'Phone'
		AND con.successful_contact = 1
	GROUP BY 1,2,3,4,5
UNION
--Active Volunteers		
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Active Vols' as 'Metric',
			NULL as 'staff vs vol',
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
			NULL as 'staff vs vol',
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
			CASE WHEN sta.id IS NOT NULL THEN 'x' ELSE NULL END as 'staff vs vol',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_myc_live as con 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
			on b.vanid = con.myc_vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = con.canvasserid	
	WHERE con.committeeid = 59691
		AND DATE (con.datecanvassed) >= '2018-06-01'
		AND con.call_attempt = 1
		AND b.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION
--Vol Rec Contacts	
	SELECT 	b.regionname, b.foname, 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Vol Rec Contacts' as 'Metric',
			CASE WHEN sta.id IS NOT NULL THEN 'x' ELSE NULL END as 'staff vs vol',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_myc_live as con 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
			on b.vanid = con.myc_vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = con.canvasserid	
	WHERE con.committeeid = 59691
		AND DATE (con.datecanvassed) >= '2018-06-01'
		AND con.successful_contact = 1
		AND con.call_attempt = 1
		AND b.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION
-- Host Conveyer Belt
SELECT b.regionname, b.foname, 
            DATE (rep.reporting_week)as 'Reporting Week',
            sub.active_type as 'Metric',
			NULL as 'staff vs vol',
            COUNT (*) as 'progress'
    FROM (SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid',
                CASE WHEN MAX (eve.eventdate) >= CURRENT_DATE - INTERVAL '7 Days' THEN 'Vol Activity 1 Week Ago'
                    WHEN MAX (eve.eventdate) BETWEEN CURRENT_DATE - INTERVAL '14 Days' and CURRENT_DATE - INTERVAL '8 Days' THEN 'Vol Activity 2 Weeks Ago'
                    WHEN MAX (eve.eventdate) BETWEEN CURRENT_DATE - INTERVAL '21 Days' and CURRENT_DATE - INTERVAL '15 Days' THEN 'Vol Activity 3 Weeks Ago'
                    WHEN MAX (eve.eventdate) <= CURRENT_DATE - INTERVAL '22 Days' THEN 'Vol Activity 4+ Weeks Ago'
                    END as 'active_type'
            FROM org_sp_wa_vansync_live.event_attendees_live as eve
            WHERE eve.committeeid = 59691
                AND eve.eventcalendarname IN ('Canvass', 'Phone Banks')
                AND eve.mrr_statusname IN ('Completed', 'Walk In')
               -- AND eve.eventdate > CURRENT_DATE - INTERVAL '30 Days'
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
			NULL as 'staff vs vol',
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
-- Shifts Completed By Week
SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week', 
		CASE WHEN a.eventcalendarname LIKE '1:1s' THEN '1:1s Completed'
		     WHEN a.eventcalendarname LIKE 'Phone Banks' THEN 'DVC Phonebank Shifts Completed'
			ELSE CONCAT (a.eventcalendarname, ' Shifts Completed') END as 'Metric',
		NULL as 'staff vs vol',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.eventdate 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.attended = 1
		AND a.committeeid = 59691
		AND a.eventcalendarname IN  ('Canvass', 'Phone Banks','1:1s','Vol Recruitment')
		AND DATE (con.datecanvassed) >= '2018-06-01'
		AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5 
UNION
-- Shifts Completed Yesterday
SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week', 
		CASE WHEN a.eventcalendarname LIKE '1:1s' THEN '1:1s Completed Yesterday'
		     WHEN a.eventcalendarname LIKE 'Phone Banks' THEN 'DVC Phonebank Shifts Completed Yesterday'
			ELSE CONCAT (a.eventcalendarname, ' Shifts Completed Yesterday') END as 'Metric',
		NULL as 'staff vs vol',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.eventdate 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.attended = 1
		AND a.committeeid = 59691
		AND a.eventcalendarname IN  ('Canvass', 'Phone Banks','1:1s','Vol Recruitment')
		AND a.eventdate = CURRENT_DATE - INTERVAL '1 Days'
		AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
	
) as sub;