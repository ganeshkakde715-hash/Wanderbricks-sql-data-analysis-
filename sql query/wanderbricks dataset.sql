select * from `databricks_wanderbricks_dataset_dais_2025`.`wanderbricks`.`bookings` limit 100;
SELECT * FROM databricks_wanderbricks_dataset_dais_2025.wanderbricks.amenities;

use databricks_wanderbricks_dataset_dais_2025.wanderbricks;

-- total users

-- total properties

-- total bookings

-- total hosts

-- total cities

-- total amenities

-- total employees

select 
(select count(*) from users) as total_users,
(select count(*) from properties) as total_properties,
(select count(*) from bookings) as total_bookings,
(select count(*) from hosts) as total_hosts,
(select count(*) from cities) as total_cities,
(select count(*) from amenities) as total_amenities,
(select count(*) from employees) as total_employees;



-- check booking ststus

select status, count(*) as total_bookings
from bookings
group by status;


-- total revenue

select round(sum(total_amount),2) as total_revenue
from bookings
where status = 'confirmed';


-- avg booking value

select round(avg(total_amount),2) as avg_booking_value
from bookings
where status = 'confirmed';

-- what percentage of total booking are cancelled?
-- cancelled booking / total booking *100
with cancelled as (
    select count(*) as cancelled_count
    from bookings
    where status = 'cancelled'
),
total as (
    select count(*) as total_count
    from bookings
)
select round(cancelled_count / total_count  * 100,2) as cancelled_percent
from cancelled, total;

--avg property is --- 526.72

-- top 5 cities by properties count 
select c.city,count (*)as total_properties 
from properties p
join cities c
on p.city_id = c. city_id
group by c.city_id,c.city
order by total_properties desc limit 5;

-- top 5 cities by revenue
select c.city, round(sum(b.total_amount),2) as total_revenue
from properties p
join cities c
on p.city_id = c. city_id
join bookings b
on p.property_id = b.property_id
group by c.city_id,c.city
order by total_revenue desc limit 5;

-- top 5 hosts by property count


SELECT h.host_id, COUNT(*) AS total_properties
FROM properties p
JOIN hosts h
  ON p.host_id = h.host_id
GROUP BY h.host_id
ORDER BY total_properties DESC
LIMIT 5;
```

-- top 5 cities by revenue
select c.city, round(sum(b.total_amount),2) as total_revenue
from properties p
join cities c
on p.city_id = c. city_id
join bookings b
on p.property_id = b.property_id
group by c.city_id,c.city;

-- monthly booking trend 

select year(created_at) as year,month(created_at) as month,count(*) as total_bookings
from bookings
group by year,month
order by year,month;

-- bookiong cancellation by city
select c.city, count(*) as total_bookings,
count_if(b.status= 'cancelled') as cancelled_booking
from bookings b
join properties p
on b.property_id = p.property_id
join cities c
on c.city_id = c.city_id        
group by c.city_id,c.city   
order by total_bookings desc;  

--  cancelled booking by city
select c.city, count(*) as total_bookings,
count_if(status = 'cancelled') as cancelled_booking
from bookings b
join properties p
on b.property_id = p.property_id
join cities c
on c.city_id  = p.city_id
group by c.city_id, c.city
order by cancelled_booking desc; 


-- most popular ameneties
SELECT a.name, COUNT(*) AS total_amenities
FROM property_amenities pa
JOIN amenities a ON pa.amenity_id = a.amenity_id
GROUP BY a.amenity_id, a.name
ORDER BY total_amenities DESC;
