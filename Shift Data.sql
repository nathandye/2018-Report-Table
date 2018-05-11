DROP TABLE IF EXISTS sp_wa_dyen.shift_data;

      SELECT * INTO sp_wa_dyen.shift_data
      FROM (  
        --Shifts scheduled by week
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
	WHERE a.RSVP_date > CURRENT_DATE - INTERVAL '18 Days'
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training', 'Meeting','1:1s', 'Voter Reg','Vol Recruitment')
		AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
UNION	
        --Shifts scheduled yesterday
         SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week',
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
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training', 'Meeting','1:1s', 'Voter Reg','Vol Recruitment')
		AND c.foname IS NOT NULL
	GROUP BY 1,2,3,4,5
 UNION    
        --Upcoming shifts by week
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
	WHERE a.eventdate >= CURRENT_DATE 
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training', 'Meeting','1:1s', 'Voter Reg','Vol Recruitment')
		AND c.foname IS NOT NULL
		AND (a.RSVP IS NOT NULL OR a.confirmed IS NOT NULL)
	GROUP BY 1,2,3,4,5
 UNION     
        --Shifts Coming In Tomorrow
        SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week',
		'Shifts Coming In Tomorrow' as 'Metric',
		a.eventcalendarname as 'Event Type',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.eventdate
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.eventdate = CURRENT_DATE + INTERVAL '1 Days'
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training', 'Meeting','1:1s', 'Voter Reg','Vol Recruitment')
		AND c.foname IS NOT NULL
		AND (a.RSVP IS NOT NULL OR a.confirmed IS NOT NULL)
	GROUP BY 1,2,3,4,5    
UNION
       --Shifts Coming In Today
        SELECT c.regionname, c.foname, 
		DATE (rep.reporting_week) as 'Reporting Week',
		'Shifts Coming In Today' as 'Metric',
		a.eventcalendarname as 'Event Type',
		COUNT (*) as 'progress'
	FROM org_sp_wa_vansync_live.event_attendees_live as a 
		LEFT JOIN sp_wa_dyen.reporting_weeks as rep 
			on rep.days = a.eventdate
		LEFT JOIN org_sp_wa_vansync_live.dnc_activityregions as c
			on c.vanid = a.myc_vanid
	WHERE a.eventdate = CURRENT_DATE 
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training', 'Meeting','1:1s', 'Voter Reg','Vol Recruitment')
		AND c.foname IS NOT NULL
		AND (a.RSVP IS NOT NULL OR a.confirmed IS NOT NULL)
	GROUP BY 1,2,3,4,5    
UNION       
       --Shifts Completed Yesterday
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
	WHERE a.eventdate = CURRENT_DATE - INTERVAL '1 Days'
		AND a.committeeid = 59691
		AND a.eventcalendarname IN ('Canvass', 'Phone Banks', 'In Person Training', 'Meeting','1:1s', 'Voter Reg','Vol Recruitment')
		AND c.foname IS NOT NULL
		AND a.attended = 1
	GROUP BY 1,2,3,4,5       
) as sub1;