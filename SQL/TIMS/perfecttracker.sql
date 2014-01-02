/*
SELECT TRACKING_ID, CUSTOM_TEXT1, TITLE, STATUS,
       PRODUCT, VERSION1_NAME, VERSION2_NAME, MODULE_NAME, 
       PRIORITY, SUBMITTED_TO, SUBMITTED_BY, SUBMITTED_ON, 
       DEADLINE, ASSIGNED_TO, ASSIGNED_BY, ASSIGNED_ON,
       RESOLVED_BY, RESOLVED_ON, CLOSED_BY, CLOSED_ON
FROM PT35_TRACK_VIEW 
WHERE STATUS <> "closed"
ORDER BY TRACKING_ID ASC
*/
select "Title" = convert(char(60),title),
       "Status" = convert(char(15),status),
       "Priority" = convert(char(15),priority),
       "Type" = convert(char(15),custom_text1),
       "Dead Line" = convert(char(8),deadline,1)
from pt35_track_view
order by deadline, priority