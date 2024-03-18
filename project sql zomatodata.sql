

                                                  --------------------Exploring zomato data ---------------------------------------------

 
 
 
 select column_name, data_type                                                      --check datatype
from INFORMATION_SCHEMA.COLUMNS
 where table_name ='zomato'

 select restaurantid,count(restaurantid)                                            -- check duplicate values
 from Zomato
 group by restaurantid
 having count(RestaurantID)>1
 
 alter table zomato                                                                 --delete unwanted column
 drop column countryname

 select *
 from zomato                                                                        --join tables
 full outer join sqlab.dbo.employeedemographics
 on zomato.RestaurantID=employeedemographics.emoployeeid
 
 alter table zomato                                                                   --add column
 add country_name nvarchar(50) 

select sum(counted)as total ,city                                                     --total restaurants with total restaurant in a city using subquery
from (select count(restaurantid)as counted,city
from Zomato
group by city)as subquery
group by City

select max(votes) maxvotes,min(votes) minvotes,avg(votes) avgvotes,                    ---min() max()  avg()  votes , rating check
max(rating) maxrating,min(rating) minrating,avg(rating) avgrating
from zomato

 select distinct(Price_range)                                                          --price range
 from Zomato



SELECT RATING,CASE
WHEN Rating >= 1 AND Rating < 2.5 THEN 'POOR'                                          -- rate category column by case 
WHEN Rating >= 2.5 AND Rating < 3.5 THEN 'GOOD'
WHEN Rating >= 3.5 AND Rating < 4.5 THEN 'GREAT'
WHEN Rating >= 4.5 THEN 'EXCELLENT'
END as rate_categorys
FROM Zomato	


alter table zomato
add rate_category varchar(30)
update Zomato
set rate_category = (case
WHEN Rating >= 1 AND Rating < 2.5 THEN 'POOR'                                            -- adding rate category column by case 
WHEN Rating >= 2.5 AND Rating < 3.5 THEN 'GOOD'
WHEN Rating >= 3.5 AND Rating < 4.5 THEN 'GREAT'
WHEN Rating >= 4.5 THEN 'EXCELLENT'
end
)          

												 
	                                                                                             
SELECT City,Locality, 
COUNT(RestaurantID) TOTAL_REST ,ROUND(AVG(cast(Rating as decimal)),2) AVG_RATING           --avg ratings of restaurants location wise
FROM Zomato
GROUP BY City,Locality
ORDER BY 4 DESC		
			
			           
                                                                                      
SELECT Price_range, COUNT(Has_Table_booking) NO_OF_REST
FROM Zomato                                                                          --FIND ALL THE RESTAURANTS THOSE WHO ARE OFFERING TABLE BOOKING OPTIONS WITH PRICE RANGE AND HAS HIGH RATING
WHERE Rating >= 4.5
AND Has_Table_booking = 'YES'
GROUP BY Price_range 



SELECT 'WITH_TABLE' TABLE_BOOKING_OPT,COUNT(Has_Table_booking) TOTAL_REST,
ROUND(AVG(Rating),2) AVG_RATING
FROM Zomato
WHERE Has_Table_booking = 'YES'
AND Locality = 'Connaught Place'                                                     -- HOW RATING AFFECTS IN MAX LISTED RESTAURANTS WITH AND WITHOUT TABLE BOOKING OPTION (Connaught Place)
UNION
SELECT 'WITHOUT_TABLE' TABLE_BOOKING_OPT,COUNT([Has_Table_booking]) TOTAL_REST,
ROUND(AVG(Rating),2) AVG_RATING
FROM Zomato
WHERE Has_Table_booking = 'NO'
AND Locality = 'Connaught Place'

                                                                     
WITH CT1 AS (
SELECT City,Locality,COUNT(RestaurantID) REST_COUNT
FROM Zomato
WHERE CountryCode = 1
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
),
CT2 AS (
SELECT Locality,REST_COUNT FROM CT1
WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)                             --HOW MANY RESTAURANTS OFFER TABLE BOOKING OPTION IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
),
CT3 AS (
SELECT Locality,Has_Table_booking TABLE_BOOKING
FROM Zomato
)
SELECT A.Locality, COUNT(A.TABLE_BOOKING) TABLE_BOOKING_OPTION
FROM CT3 A JOIN CT2 B
ON A.Locality = B.Locality
WHERE A.TABLE_BOOKING = 'YES'
GROUP BY A.Locality

