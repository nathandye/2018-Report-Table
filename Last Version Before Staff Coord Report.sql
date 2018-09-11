DROP TABLE IF EXISTS sp_wa_dyen.coord_report_data;

SELECT *
INTO sp_wa_dyen.coord_report_data
FROM (

--Walk Attempts	
	SELECT 	b.regionname, b.foname, CAST (con.state_senate_district_latest as INT) as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			'Walk Attempts' as 'Metric',
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
	SELECT 	b.regionname, b.foname, CAST (con.state_senate_district_latest as INT) as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			'Walk Contacts' as 'Metric',
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
	SELECT 	b.regionname, b.foname, CAST (con.state_senate_district_latest as INT) as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			'DVC Phone Attempts' as 'Metric',
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
	SELECT 	b.regionname, b.foname, CAST (con.state_senate_district_latest as INT) as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			'DVC Phone Contacts' as 'Metric',
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
--DVC Text Attempts	
	SELECT 	b.regionname, b.foname, CAST (con.state_senate_district_latest as INT) as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			'DVC Texts' as 'Metric',
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
		AND con.contacttype_name LIKE 'Text'
	GROUP BY 1,2,3,4,5
UNION
--DVC Text + Call Attempts	
	SELECT 	b.regionname, b.foname, CAST (con.state_senate_district_latest as INT) as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			'DVC Texts + Call Attempts' as 'Metric',
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
		AND con.contacttype_name IN ('Text','Phone')
	GROUP BY 1,2,3,4,5	
UNION
--Active Volunteers		
	SELECT 	b.regionname, b.foname, ld.ld as 'LD', 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Active Vols' as 'Metric',
			COUNT (*) as 'progress'
	FROM (SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid'
			FROM org_sp_wa_vansync_live.event_attendees_live as eve
			WHERE eve.committeeid = 59691
				AND eve.eventcalendarname IN  ('Canvass', 'DVC Phone Banks','1:1s','Vol Rec Phone Banks')
				AND eve.mrr_statusname IN ('Completed', 'Walk In')
				AND eve.eventdate > CURRENT_DATE - INTERVAL '30 Days'	
		) as sub
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 	
			on sub.myc_vanid = b.vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = CURRENT_DATE 
	       LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	               on ld.teamname = b.teamname
		WHERE b.foname IS NOT NULL
		GROUP BY 1,2,3,4
Union
-- Lapsed Vols
	SELECT 	b.regionname, b.foname, ld.ld as 'LD', 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Lapsed Vols' as 'Metric',
			COUNT (*) as 'progress'
	FROM (SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid'
			FROM org_sp_wa_vansync_live.event_attendees_live as eve
			WHERE eve.committeeid = 59691
				AND eve.eventcalendarname IN  ('Canvass', 'DVC Phone Banks','1:1s','Vol Rec Phone Banks')
				AND eve.mrr_statusname IN ('Completed', 'Walk In')
				AND eve.eventdate < CURRENT_DATE - INTERVAL '30 Days'	
			) as sub1
		LEFT JOIN 
			(SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid'
			FROM org_sp_wa_vansync_live.event_attendees_live as eve
			WHERE eve.committeeid = 59691
				AND eve.eventcalendarname IN  ('Canvass', 'DVC Phone Banks','1:1s','Vol Rec Phone Banks')
				AND eve.mrr_statusname IN ('Completed', 'Walk In')
				AND eve.eventdate > CURRENT_DATE - INTERVAL '30 Days'	
			) as sub2
				on sub1.myc_vanid = sub2.myc_vanid 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 	
			on sub1.myc_vanid = b.vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = CURRENT_DATE 
	       LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	               on ld.teamname = b.teamname
		WHERE sub2.myc_vanid IS NULL
			AND b.foname IS NOT NULL
		GROUP BY 1,2,3,4		
UNION 
--Vol Rec Calls	
	SELECT 	b.regionname, b.foname, ld.ld as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			'Vol Rec Attempts' as 'Metric',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_myc_live as con 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
			on b.vanid = con.myc_vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = con.canvasserid
		LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	               on ld.teamname = b.teamname	
	WHERE con.committeeid = 59691
		AND DATE (con.datecanvassed) >= '2018-06-01'
		AND con.call_attempt = 1
		AND b.foname IS NOT NULL
	GROUP BY 1,2,3,4
UNION
--Vol Rec Contacts	
	SELECT 	b.regionname, b.foname, ld.ld as 'LD', 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Vol Rec Contacts' as 'Metric',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_myc_live as con 
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
		      on b.vanid = con.myc_vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
		      on rep.days = con.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
		      on sta.id = con.canvasserid	
		LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	              on ld.teamname = b.teamname
	WHERE con.committeeid = 59691
		AND DATE (con.datecanvassed) >= '2018-06-01'
		AND con.successful_contact = 1
		AND con.call_attempt = 1
		AND b.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION
-- Host Conveyer Belt
SELECT b.regionname, b.foname, ld.ld as 'LD', 
            DATE (rep.reporting_week)as 'Reporting Week',
            sub.active_type as 'Metric',
            COUNT (*) as 'progress'
    FROM (SELECT DISTINCT (eve.myc_vanid) as 'myc_vanid',
                CASE WHEN MAX (eve.eventdate) >= CURRENT_DATE - INTERVAL '7 Days' THEN 'Vol Activity 1 Week Ago'
                    WHEN MAX (eve.eventdate) BETWEEN CURRENT_DATE - INTERVAL '14 Days' and CURRENT_DATE - INTERVAL '8 Days' THEN 'Vol Activity 2 Weeks Ago'
                    WHEN MAX (eve.eventdate) BETWEEN CURRENT_DATE - INTERVAL '21 Days' and CURRENT_DATE - INTERVAL '15 Days' THEN 'Vol Activity 3 Weeks Ago'
                    WHEN MAX (eve.eventdate) <= CURRENT_DATE - INTERVAL '22 Days' THEN 'Vol Activity 4+ Weeks Ago'
                    END as 'active_type'
            FROM org_sp_wa_vansync_live.event_attendees_live as eve
            WHERE eve.committeeid = 59691
                AND eve.eventcalendarname IN ('Canvass', 'DVC Phone Banks','Vol Rec Phone Banks')
                AND eve.mrr_statusname IN ('Completed', 'Walk In')
                AND eve.eventdate >= '2018-04-01'
            GROUP BY 1
        ) as sub
        LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b     
            on sub.myc_vanid = b.vanid
        LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
            on rep.days = CURRENT_DATE 
        LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	              on ld.teamname = b.teamname
        WHERE b.foname IS NOT NULL
        GROUP BY 1,2,3,4,5
UNION 
 --Vol Rec Calls Yesterday	
SELECT b.regionname, b.foname, ld.ld as 'LD', 
			DATE (rep.reporting_week) as 'Reporting Week',
			'Vol Rec Calls Yesterday' as 'Metric',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_myc_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
		 on b.vanid = con.myc_vanid
	LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
	LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	              on ld.teamname = b.teamname
	WHERE con.committeeid = 59691
		AND con.call_attempt = 1
		AND con.datecanvassed = CURRENT_DATE - INTERVAL '1 days'
		AND b.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION
--DVC Attempts Yesterday
	SELECT 	b.regionname, b.foname, CAST (con.state_senate_district_latest as INT) as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			CASE WHEN con.contacttype_name LIKE 'Phone' THEN 'DVC Phone Attempts Yesterday'
			     WHEN con.contacttype_name LIKE 'Walk' THEN 'Walk Attempts Yesterday'
			     WHEN con.contacttype_name LIKE 'Text' THEN 'DVC Texts Yesterday'
			   END as 'Metric',
			COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.contacts_voter_live as con 
	LEFT JOIN org_sp_wa_vansync_live.dnc_turf as b 	
			on con.precinctid = b.precinctid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = con.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = con.canvasserid
	WHERE con.committeeid = 59691
		AND DATE (con.datecanvassed) = CURRENT_DATE - INTERVAL '1 Days'
		AND b.committeeid = 59691
		AND con.contacttype_name IN ('Walk','Phone','Text')
	GROUP BY 1,2,3,4,5
UNION	
-- Shifts Completed By Week
SELECT c.regionname, c.foname, ld.ld as 'LD', 
		DATE (rep.reporting_week) as 'Reporting Week', 
		CASE WHEN a.eventcalendarname LIKE '1:1s' THEN '1:1s Completed'
		     WHEN a.eventcalendarname LIKE 'DVC Phone Banks' THEN 'DVC Phonebank Shifts Completed'
		     WHEN a.eventcalendarname LIKE 'Vol Rec Phone Banks' THEN 'Vol Recruitment Shifts Completed'
			ELSE CONCAT (a.eventcalendarname, ' Shifts Completed') END as 'Metric',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
	        LEFT JOIN org_sp_wa_vansync_live.dnc_events as eve
                      on eve.eventid = a.eventid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = DATE(to_timestamp(eve.dateoffsetbegin, 'YYYY MM DD HH') - INTERVAL '7 Hours')
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
		LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	              on ld.teamname = c.teamname
	WHERE a.attended = 1
		AND a.committeeid = 59691
		AND a.eventcalendarname IN  ('Canvass', 'DVC Phone Banks','1:1s','Vol Rec Phone Banks')
		AND DATE (a.eventdate) >= '2018-06-01'
		AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION
-- CTM Progress Weekly
     SELECT b.regionname, b.foname, ld.ld as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			CASE 
			     WHEN respons.surveyresponseid = 1238934 THEN 'CTM Prospect This Week'
                             WHEN respons.surveyresponseid = 1238935 THEN 'CTM Testing This Week'
                             WHEN respons.surveyresponseid IN (1238936,1238937,1238938,1238939,1238940) THEN 'CTM Confirmed/Placed This Week'
                             WHEN respons.surveyresponseid = 1238941 THEN 'Removed CTM This Week'
                             END as 'Metric',
			COUNT (*)
     FROM org_sp_wa_vansync_live.responses_myc_live as res
        LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
			on b.vanid = res.myc_vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = res.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = res.canvasserid
		LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	               on ld.teamname = b.teamname	
	        LEFT JOIN org_sp_wa_vansync_live.dnc_surveyresponses as respons
	               on res.surveyresponseid = respons.surveyresponseid
     WHERE res.committeeid = 59691
                AND res.surveyquestionid = 299092
                AND res.sq_currency = 1
     GROUP BY 1,2,3,4,5			
UNION
-- Cumulative CTM Progress Weekly
     SELECT b.regionname, b.foname, ld.ld as 'LD',
			current_date as 'Reporting Week',
			CASE 
			     WHEN respons.surveyresponseid = 1238934 THEN 'Current CTM Prospects'
                             WHEN respons.surveyresponseid = 1238935 THEN 'Current CTM In Testing'
                             WHEN respons.surveyresponseid = 1238936 THEN 'Current CTM Confirmeds'
                             WHEN respons.surveyresponseid = 1238937 THEN 'Current Phone CTMs'
                             WHEN respons.surveyresponseid = 1238938 THEN 'Current Canvass CTMs'
                             WHEN respons.surveyresponseid = 1238939 THEN 'Current Vol Rec CTMs'
                             WHEN respons.surveyresponseid = 1238940 THEN 'Current Data CTMs'
                             WHEN respons.surveyresponseid = 1238941 THEN 'Current Removed CTMs'
                             END as 'Metric',
			COUNT (*)
     FROM org_sp_wa_vansync_live.responses_myc_live as res
        LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
			on b.vanid = res.myc_vanid
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = res.canvasserid
		LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	               on ld.teamname = b.teamname	
	        LEFT JOIN org_sp_wa_vansync_live.dnc_surveyresponses as respons
	               on res.surveyresponseid = respons.surveyresponseid
     WHERE res.committeeid = 59691
                AND res.surveyquestionid = 299092
                AND res.sq_currency = 1
     GROUP BY 1,2,3,4,5	
UNION
       -- NTL Progress Weekly
     SELECT b.regionname, b.foname, ld.ld as 'LD',
			DATE (rep.reporting_week) as 'Reporting Week',
			CASE 
			     WHEN respons.surveyresponseid = 1280286 THEN 'NTL Prospect This Week'
                             WHEN respons.surveyresponseid = 1280287 THEN 'NTL Testing This Week'
                             WHEN respons.surveyresponseid = 1280288 THEN 'CTM Confirmed/Placed This Week'
                             WHEN respons.surveyresponseid = 1280289 THEN 'Removed CTM This Week'
                             END as 'Metric',
			COUNT (*)
     FROM org_sp_wa_vansync_live.responses_myc_live as res
        LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
			on b.vanid = res.myc_vanid
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = res.datecanvassed	
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = res.canvasserid
		LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	               on ld.teamname = b.teamname	
	        LEFT JOIN org_sp_wa_vansync_live.dnc_surveyresponses as respons
	               on res.surveyresponseid = respons.surveyresponseid
     WHERE res.committeeid = 59691
                AND res.surveyquestionid = 309589
                AND res.sq_currency = 1
     GROUP BY 1,2,3,4,5			
UNION
-- Cumulative NTL Progress Weekly
     SELECT b.regionname, b.foname, ld.ld as 'LD',
			current_date as 'Reporting Week',
			CASE 
			     WHEN respons.surveyresponseid = 1280286 THEN 'Current NTL Prospects'
                             WHEN respons.surveyresponseid = 1280287 THEN 'Current NTL In Testing'
                             WHEN respons.surveyresponseid = 1280288 THEN 'Current NTL Confirmeds'
                             WHEN respons.surveyresponseid = 1280289 THEN 'Current Removed NTL'
                             END as 'Metric',
			COUNT (*)
     FROM org_sp_wa_vansync_live.responses_myc_live as res
        LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as b 
			on b.vanid = res.myc_vanid
		LEFT JOIN sp_wa_dyen.fo_user_ids as sta 
			on sta.id = res.canvasserid
		LEFT JOIN sp_wa_dyen.turf_to_ld as ld
	               on ld.teamname = b.teamname	
	        LEFT JOIN org_sp_wa_vansync_live.dnc_surveyresponses as respons
	               on res.surveyresponseid = respons.surveyresponseid
     WHERE res.committeeid = 59691
                AND res.surveyquestionid = 309589
                AND res.sq_currency = 1
     GROUP BY 1,2,3,4,5					
) as sub;