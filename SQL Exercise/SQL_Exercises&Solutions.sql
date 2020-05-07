
***SQL Exercises and Solution Code*** 


Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do.

SELECT name
FROM Facilities 
WHERE membercost > 0 

Names: Tennis Court 1, Tennis Court 2, Massage Room 1, Massage Room 2 Squash Court 

Q2: How many facilities do not charge a fee to members?

SELECT COUNT(name)
FROM Facilities 
WHERE membercost = 0

4 facilities 

Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question.

SELECT facid, name, membercost, monthlymaintenance 
FROM facilities 
WHERE membercost < (monthlymaintenance * .2)

Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator.

SELECT * 
FROM Facilities
WHERE facid = 1 OR facid = 5

Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question.

SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance > 100 THEN 'expensive'
ELSE 'cheap' END AS cheap_expensive 
FROM Facilities 

Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution.
??????????

SELECT JoinDateTable.firstnamemin, JoinDateTable.surname, min(JoinDateTable.JoinDate) AS EarliestJoinDate
FROM 
(SELECT firstname, surname, STR_TO_DATE(joindate, '%Y-%m-%d') AS JoinDate
FROM Members
GROUP BY JoinDate
ORDER BY JoinDate) AS JoinDateTable

STR_TO_DATE(Bookings.starttime, '%Y-%m-%d') = '2012-09-14'

Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. 

SELECT Facilities.name, MembersWithBookings.Member
FROM
(
SELECT DISTINCT Bookings.facid, CONCAT(Members.firstname, ' ', Members.surname) AS Member
FROM Bookings
JOIN Members
ON Bookings.memid = Members.memid
) AS MembersWithBookings 
JOIN Facilities
ON MembersWithBookings.facid = Facilities.facid
WHERE Facilities.facid = 0 OR Facilities.facid = 1
ORDER BY MembersWithBookings.Member



Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries.

SELECT Facilities.name, CONCAT(Members.firstname, ' ', Members.surname) AS Member,
CASE WHEN Bookings.memid = 0 THEN Bookings.slots * Facilities.guestcost
	ELSE Bookings.slots * Facilities.membercost 
	END AS Cost 
FROM Bookings
JOIN Facilities
ON Bookings.facid = Facilities.facid
JOIN Members
ON Bookings.memid = Members.memid
WHERE 1=1
AND STR_TO_DATE(Bookings.starttime, '%Y-%m-%d') = '2012-09-14'
AND CASE WHEN Bookings.memid = 0 THEN Bookings.slots * Facilities.guestcost
	ELSE Bookings.slots * Facilities.membercost 
	END > 30
ORDER BY Cost DESC 


Q9: This time, produce the same result as in Q8, but using a subquery.


SELECT Facilities.name, Bookinginfo.Member,
CASE WHEN Bookinginfo.memid = 0 THEN Bookinginfo.slots * Facilities.guestcost
	ELSE Bookinginfo.slots * Facilities.membercost 
	END AS Cost 
FROM (
SELECT CONCAT(Members.firstname, ' ', Members.surname) AS Member, Bookings.starttime, Bookings.facid, Bookings.slots, Bookings.memid
FROM Bookings
JOIN Members
ON Bookings.memid = Members.memid 
WHERE STR_TO_DATE(Bookings.starttime, '%Y-%m-%d')  = '2012-09-14') AS Bookinginfo
JOIN Facilities
ON Facilities.facid = Bookinginfo.facid
WHERE 1=1
AND CASE WHEN Bookinginfo.memid = 0 THEN Bookinginfo.slots * Facilities.guestcost
	ELSE Bookinginfo.slots * Facilities.membercost 
	END > 30
ORDER BY Cost DESC


Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members!



SELECT revenuetable.name, SUM(revenuetable.Cost) AS Revenue
FROM (
SELECT Facilities.name,
CASE WHEN Bookinginfo.memid = 0 THEN Bookinginfo.slots * Facilities.guestcost
	ELSE Bookinginfo.slots * Facilities.membercost 
	END AS Cost 
FROM (
SELECT Bookings.memid, Bookings.facid, Bookings.slots
FROM Bookings
JOIN Members
ON Bookings.memid = Members.memid) AS Bookinginfo
JOIN Facilities
ON Facilities.facid = Bookinginfo.facid) AS revenuetable
GROUP BY revenuetable.name
Having SUM(revenuetable.Cost) < 1000



