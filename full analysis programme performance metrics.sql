use tracker;

/* 1. Participant Overview */
/* Purpose: Understand who is in the dataset before analysing performance hese are foundational counts used as denominators in later pass-rate calculations.*/
/* a. count total participants */
select count(distinct name) AS `Total Participants`
from exam;

/* b. count by status */
select status, count(distinct name) AS 'Total Participants'
from exam
group by status;

/* c. count by programme */
select programme, count(distinct name) AS 'Total Participants'
from exam
group by programme;

/* d. count by programme, cohort */
select programme, cohort, count(distinct name) AS 'Total Participants'
from exam
group by programme, cohort;

/* e. count by year */
select year, count(distinct name) AS 'Total Participants'
from exam
group by year;


/* 2. Exam Attempt Analysis */
/* Purpose: Understand how many times participants are sitting exam and at which attempt they are passing*/
/* a. Total number of exam records */
select count(exam) AS 'Total number of exam records'
from exam;

/* b. Exams attempted at least once */
select exam, count(*) AS `Total students attempted`
from exam
WHERE attempt_1 IS NOT NULL
   OR attempt_2 IS NOT NULL
   OR attempt_3 IS NOT NULL
   OR attempt_4 IS NOT NULL
   OR attempt_5 IS NOT NULL
   OR attempt_6 IS NOT NULL
group by exam
order by `Total students attempted`;

/* c. Average attempts per exam among students passed */
select exam, round(avg(case when attempt_1=1 then 1 
                  when attempt_2=1 then 2
                  when attempt_3=1 then 3
                  when attempt_4=1 then 4
                  when attempt_5=1 then 5
                  when attempt_6=1 then 6
			 else null end),2) AS avg_attempts_to_pass
from exam
group by exam
order by `avg_attempts_to_pass`DESC;

/* d. count of passes by attempt slot( shows at which sitting most students succeed) */
select exam,
       count(case when attempt_1=1 then 1 end) AS 'total_pass_on_first_attempt',
       count(case when attempt_2=1 then 1 end) AS 'total_pass_on_second_attempt',
       count(case when attempt_3=1 then 1 end) AS 'total_pass_on_third_attempt',
       count(case when attempt_4=1 then 1 end) AS 'total_pass_on_fourth_attempt',
       count(case when attempt_5=1 then 1 end) AS 'total_pass_on_fifth_attempt',
       count(case when attempt_6=1 then 1 end) AS 'total_pass_on_sixth_attempt'
from exam
group by exam;

/* e. First attempt pass rate per exam */
select exam, count(*) AS 'total_participants', count(case when attempt_1=1 then 1 end) AS 'total_pass_first_attempt', round(count(case when attempt_1=1 then 1 end) *100/count(*),2) AS 'First attempt pass rate per exam'
from exam
group by exam;

/* 3. Programme Performance */
/* Purpose: Compare how each programme is performning overall and track whether performance changes over time*/
/* a. Number of students who passed each exam per programme */
select programme, exam, count(*) AS 'Total Students Passed'
from exam
where attempt_1=1 OR attempt_2=1 OR attempt_3=1 OR attempt_4=1 OR attempt_5=1 OR attempt_6=1
group by programme, exam;

/* b. Average attempts before passing per programme and cohort */
select programme, cohort, round(avg(case when attempt_1=1 then 1
                                   when attempt_2=1 then 2
                                   when attempt_3=1 then 3
                                   when attempt_4=1 then 4
                                   when attempt_5=1 then 5
                                   when attempt_6=1 then 6 else null end),2) AS 'average attempt to pass'
from exam
group by programme, cohort
order by programme;

/* c. Overall pass rate per programme */
/* Out of all exam records in a programme,what percentage were passed? */
select programme, round(SUM(case when attempt_1=1 OR attempt_2=1 OR attempt_3=1 OR attempt_4=1 OR attempt_5=1 OR attempt_6=1 then 1 else 0 end) *100/count(*),2) AS `Pass rate`
from exam
group by programme
order by `Pass rate` DESC;

/* d. Pass rate per programme broken down by year */
/* [compares 2023 vs 2024 cohort performance within each programme to show whether results are improving over time] */
select year, programme, round(SUM(case when attempt_1=1 OR
									  attempt_2=1 OR
                                      attempt_3=1 OR
                                      attempt_4=1 OR
                                      attempt_5=1 OR
                                      attempt_6=1 then 1 else 0 end)*100/count(*),2) AS `Pass rate`
from exam
group by year, programme
order by year;

/* e. Cohort trend-average attempts to pass per cohort 
[ Within each programme, are later cohorts passing faster? Lower average attempts to pass in newer cohorts suggests improved delivery or support.]*/
select year, programme, cohort, count(distinct name) AS'Total Participants',
                          round(AVG(CASE when attempt_1=1 then 1
                                         when attempt_2=1 then 2
                                         when attempt_3=1 then 3
                                         when attempt_4=1 then 4
                                         when attempt_5=1 then 5
                                         when attempt_6=1 then 6 else NULL end),2) AS 'Average attempts to pass'
from exam
group by year, programme, cohort
order by year, programme,cohort;

/* 4. Exam Level Insights */
/* Purpose: Identify which specifics exam are the hardest and where the pass rates are differ across programmes */
/* a. Pass rate per exam 
[Ranks exam by difficulty. Low pass rate flags exam where participants may need additional support.]*/
select exam, count(distinct name) AS 'Total Participants', 
             round(sum(case when attempt_1=1 OR attempt_2=1 OR attempt_3=1 OR attempt_4=1 OR attempt_5=1 OR attempt_6=1 then 1 else 0 end)*100/count(*),2) AS `Total Pass Rate`
from exam
group by exam
order by `Total Pass Rate`;

/* b. Total sittings vs total passes per exam */
/* [ Previous version counted all NON NULL slots as "attempts", which mixed failed and passed attemopts to gather wihout distinction. 
    Fix: separates total sittings(any non NULL) from total passes (=1) for a clearer picture.]*/
select exam, 
       sum((attempt_1 IS NOT NULL) + (attempt_2 IS NOT NULL) + (attempt_3 IS NOT NULL) +(attempt_4 IS NOT NULL) + (attempt_5 IS NOT NULL) +(attempt_6 IS NOT NULL)) AS 'Total Sittings',
	   sum(coalesce (attempt_1,0)+ coalesce(attempt_2,0) + coalesce(attempt_3,0) + coalesce(attempt_4,0) + coalesce(attempt_5,0)+coalesce(attempt_6,0)) AS 'Total Passes',
       (sum((attempt_1 IS NOT NULL) + (attempt_2 IS NOT NULL) + (attempt_3 IS NOT NULL) +(attempt_4 IS NOT NULL) + (attempt_5 IS NOT NULL) +(attempt_6 IS NOT NULL))-sum(coalesce (attempt_1,0)+ coalesce(attempt_2,0) + coalesce(attempt_3,0) + coalesce(attempt_4,0) + coalesce(attempt_5,0)+coalesce(attempt_6,0))) AS 'Total Fails'
from exam
group by exam;

/* c. Hardest exam ranked by average attempts needed to pass */
/* Unlike pass rate (which shows who passed), this shows how much effort was required. An exam with 99% pass rate but average 2.5 attempts is still demanding. */
select exam, round(avg(case when attempt_1=1 then 1
                      when attempt_2=1 then 2
                      when attempt_3=1 then 3
                      when attempt_4=1 then 4
                      when attempt_5=1 then 5
                      when attempt_6=1 then 6 else NULL end),2) AS `Average attempts to pass`,
			 count(case when attempt_1=1 OR attempt_2=1 OR attempt_3=1 OR attempt_4=1 OR attempt_5=1 OR attempt_6=1 then 1 else 0 end) AS 'Total Passer'
from exam
group by exam
order by `Average attempts to pass` DESC;
                      
/* d. Pass rate per exam and programme */
select programme, exam, count(*) AS 'Total exam',round(sum(case when attempt_1=1 OR attempt_2=1 OR attempt_3=1 OR attempt_4=1 OR attempt_5=1 OR attempt_6=1 then 1 else 0 end)*100/count(*),2) AS `Pass Rate`
from exam
group by exam, programme
order by programme, `Pass Rate`;

/* 5. Learner Progress Tracking */
/* [ Purpose: Identify individual learner situations who is on track, who struggled, and who may need intervention]*/
/* a. Participants who have not yet attempted any exam */
Select programme, cohort, name AS 'Participants who not yet attempted any exam'
from exam
where attempt_1 IS NULL AND attempt_2 IS NULL AND attempt_3 IS NULL AND attempt_3 IS NULL AND attempt_4 IS NULL AND attempt_5 IS NULL AND attempt_6 IS NULL;

/* b. Participants who passed on the first attempt */
Select programme, cohort,name AS 'Straight Passer',exam
from exam
where attempt_1=1
order by programme,cohort;

/* c. Participants who needed multiple attempts to pass */
select programme, exam, name AS 'Participants', case when attempt_2=1 then 2
													 when attempt_3=1 then 3
													 when attempt_4=1 then 4
													 when attempt_5=1 then 5
													 when attempt_6=1 then 6 end  AS 'Passed on attempt'
from exam
where(attempt_1=0 OR attempt_1 IS NULL) AND(attempt_2=1 OR attempt_3=1 OR attempt_4=1 OR attempt_5=1 OR attempt_6=1)
order by programme, exam;

/* d. Participants who attempted but never passed */
select programme, exam, name AS 'Never passed'
from exam 
where attempt_1 IS NOT NULL AND attempt_1 != 1 
      AND coalesce(attempt_2,0) !=1 
      AND coalesce(attempt_3,0) !=1
      AND coalesce(attempt_4,0) !=1
      AND coalesce(attempt_5,0) !=1
      AND coalesce(attempt_6,0) !=1
order by programme, exam;

/* e. At risk summary - no attempt count by programme & cohort */
/* [ aggregated version of 5a. Shows which specific cohorts have the highest number of disengaged participants, helping programme manager prioritise outreach.]*/
select programme, cohort, count(name) AS 'Total Participants who have no attempt'
from exam
where (attempt_1 IS NULL AND attempt_2 IS NULL AND attempt_3 IS NULL AND attempt_4 IS NULL AND attempt_5 IS NULL AND attempt_6 IS NULL)
group by programme, cohort
order by `Total Participants who have no attempt` DESC;

/* 6. Status based Insights */
/*[Purpose: Compare active vs terminated participants to see whether termination correlates with performance.]*/
/* a. Pass rate comparison -Active vs Terminated */
select status, count(distinct name) AS 'Total Participants',round(count(distinct case when attempt_1=1 OR attempt_2=1 OR attempt_3=1 OR attempt_4=1 OR attempt_5=1 OR attempt_6=1 then name end)*100/count(distinct name),2) AS 'Pass rate'
from exam
group by status;

/* b. Number of exam records per status */
/* [Compares how many exam slots each group occupies. Terminated participants sitting fewer exams may indicate early dropout.]*/
select status, count(*) AS 'Total exam records'
from exam
group by status;

/* c. Termination rate per programme */
select programme, count(distinct case when status='Terminate' then name end) AS 'Total Terminated Paticipants',
                 round(count(distinct case when status='Terminate' then name end)*100/count(distinct name),2) AS 'Termination Rate'
from exam
group by programme
order by `Termination Rate` DESC;

/* 7. Advanced/Aggregate Views */
/* [Purpose: Create reusable views & summary tables that can feed directly into PowerBI or further analysis.] */
/* a. Create view - Exam attempts with total attempts column coalesce (attempt,0) converts NULL to 0 so the sum works correctly. This view is the base for queries 7b and 7c.*/
CREATE or REPLACE VIEW ExamAttempts AS 
                       select *, (coalesce(attempt_1,0) + coalesce(attempt_2,0) + 
                       coalesce(attempt_3,0) + coalesce(attempt_4,0) +
                       coalesce(attempt_5,0) + coalesce(attempt_6,0)) AS total_attempts
from exam;

/* b. Average attempts per programme using the view */
select programme, round(avg(total_attempts),2) AS 'Average_attempts'
from ExamAttempts
group by programme;

/* c. Year over year pass rate comparison */
SELECT   programme,
         year,
         COUNT(DISTINCT name) AS participants,
         ROUND(
           SUM(CASE WHEN total_attempts > 0 THEN 1 ELSE 0 END)
           * 100.0 / COUNT(*), 2) AS attempt_rate_pct,
         ROUND(SUM(CASE WHEN attempt_1=1 OR attempt_2=1 OR attempt_3=1
                         OR attempt_4=1 OR attempt_5=1 OR attempt_6=1
                    THEN 1 ELSE 0 END) * 100.0/ COUNT(*), 2) AS pass_rate_pct
FROM ExamAttempts
GROUP BY programme, year
ORDER BY programme, year;

/* d. Full learner summary - one row per participant */
SELECT name, programme, cohort, year, status,COUNT(*) AS total_exams,
  SUM(CASE WHEN attempt_1=1 OR attempt_2=1 OR attempt_3=1
                OR attempt_4=1 OR attempt_5=1 OR attempt_6=1 THEN 1 ELSE 0 END) AS exams_passed,
  SUM(CASE WHEN attempt_1 IS NULL AND attempt_2 IS NULL
                AND attempt_3 IS NULL AND attempt_4 IS NULL
                AND attempt_5 IS NULL AND attempt_6 IS NULL THEN 1 ELSE 0 END) AS exams_not_attempted,
  ROUND(SUM(CASE WHEN attempt_1=1 OR attempt_2=1 OR attempt_3=1
                  OR attempt_4=1 OR attempt_5=1 OR attempt_6=1 THEN 1 ELSE 0 END) * 100.0/ COUNT(*), 2)                                                          AS individual_pass_rate_pct
FROM exam
GROUP BY name, programme, cohort, year, status
ORDER BY programme, cohort, name;