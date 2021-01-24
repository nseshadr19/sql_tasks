


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT distinct name
from Facilities
where membercost >0;

/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT( DISTINCT Name )
FROM Facilities
WHERE membercost =0

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT DISTINCT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost >0
AND membercost < ( 0.20 * monthlymaintenance )

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT *
FROM `Facilities`
WHERE facid
IN ( 1, 5 )

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name,
CASE WHEN monthlymaintenance >100
THEN 'Expensive'
ELSE 'Cheap'
END AS Maintenance_Category
FROM `Facilities`

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT firstname, surname
FROM `Members`
WHERE joindate = (
SELECT MAX( joindate )
FROM `Members` )

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT f.name AS Facility_Name, CONCAT( firstname, ' ', surname ) AS Member_Name
FROM Members m
JOIN Bookings b ON m.memid = b.memid
JOIN Facilities f ON f.facid = b.facid
WHERE f.name LIKE '%tennis%court%'
ORDER BY 2

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT f.name as Facility_Name, concat (firstname, ' ', surname) as User_name, case when b.memid = 0 then (slots * guestcost) else (slots * membercost) END as Cost                                                                                                                            FROM Bookings b join Facilities f on b.facid=f.facid join Members m on m.memid=b.memid
WHERE cast(starttime as DATE)='2012-09-14' and case when b.memid = 0 then (slots * guestcost) else (slots * membercost) END > 30
order by 3 desc

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT Facility_Name, User_name, Cost from (
select f.name as Facility_Name,concat (firstname, ' ', surname) as User_name,case when b.memid = 0 then (slots * guestcost) else (slots * membercost) END as Cost                                                                                                                            FROM Bookings b join Facilities f on b.facid=f.facid join Members m on m.memid=b.memid
WHERE cast(starttime as DATE)='2012-09-14' and case when b.memid = 0 then (slots * guestcost) else (slots * membercost) END > 30)x
order by 3 desc


 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT Facility_Name, Revenue
FROM (

SELECT f.name AS Facility_Name, SUM(
CASE WHEN b.memid =0
THEN (
slots * guestcost
)
ELSE (
slots * membercost
)
END ) AS Revenue
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
JOIN Members m ON m.memid = b.memid
GROUP BY facility_name
)x
WHERE Revenue <1000
ORDER BY 2 DESC

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
SELECT 
CONCAT(r.surname, ', ', r.firstname) AS Member,
    CONCAT(m.surname, ', ', m.firstname) AS RecommendedBy
FROM
    Members r
INNER JOIN Members m ON 
    r.recommendedby=m.memid 
where m.memid<>0
order by 1

/* Q12: Find the facilities with their usage by member, but not guests */
SELECT f.name AS Facility, CONCAT( m.firstname, ' ', m.surname ) AS Member, COUNT( starttime ) AS Count_usage
FROM `Members` m
JOIN Bookings b ON m.memid = b.memid
JOIN Facilities f ON b.facid = f.facid
WHERE m.memid <>0
GROUP BY f.name, CONCAT( m.firstname, ' ', m.surname )
ORDER BY 1


/* Q13: Find the facilities usage by month, but not guests */
SELECT CONCAT( MONTH( starttime ) , '-', YEAR( starttime ) ) AS
MONTH , f.name AS Facility, COUNT( starttime ) AS Count_usage
FROM Members m
JOIN Bookings b ON m.memid = b.memid
JOIN Facilities f ON b.facid = f.facid
WHERE m.memid <>0
GROUP BY CONCAT( MONTH( starttime ) , '-', YEAR( starttime ) ) , f.name

