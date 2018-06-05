create or replace view Q1(Name, Country)
as
select c.Name, c.Country
from   Company c
where  c.Country <> 'Australia' and c.Country Is not null
order by c.Name, c.Country;


create or replace view Q2(Code)
as
select e.Code
from   Executive e
group by e.Code
having count(e.Person)>5
order by e.Code;



create or replace view Q3(Name)
as
select c.Name 
from   Category ct, Company c
where ct.code = c.code and ct.Sector = 'Technology'
order by c.Name;



create or replace view Q4(Sector, Number)
as
select ct.Sector, count(ct.Industry)
from   Category ct
where ct.Industry IS not null and ct.Sector is not null
group by ct.Sector
order by ct.Sector;


create or replace view Q5(Name)
as
select DISTINCT e.person
from   Executive e, Company c, Q3 q
where c.Name  = q.Name and e.code = c.code
order by e.person;



create or replace view Q6_1(Name)
as
select c.Name 
from   Category ct, Company c
where ct.code = c.code and ct.Sector = 'Services'
order by c.Name;


create or replace view Q6(Name)
as
select c.Name 
from   Company c, Q6_1 q
where c.Name = q.Name and c.Country ='Australia' and LEFT(c.Zip,1)= '2'
order by c.Name;

create or replace view Q7_1(Code,"Date", Volume, price )
as
select a.Code, a."Date", a.Volume, a.price
from   ASX a
order by a.Code, a."Date";


create or replace view Q7("Date", Code, Volume, PrevPrice, Price,  Change, Gain )
as
with tbdifference as
(
   select Row_Number() over(order by Code, "Date") as RowNumber, Volume, Code, "Date", price
   from Q7_1
)
select cur."Date", cur.Code, cur.Volume, previous.Price,  cur.Price, cur.price-previous.price, ((cur.price-previous.Price)/previous.Price)*100
from tbdifference cur
left outer join tbdifference previous
			on (cur.RowNumber = previous.RowNumber +1 and cur.Code = previous.Code)
where (cur.price-previous.price) is not null
order by cur.code, cur."Date";



create or replace view Q8("Date", Code, Volume)
as
select a."Date", a.Code, a.Volume
from   ASX a
where a.Volume in (select max(Volume) from ASX group by "Date")
order by a."Date",a.Code;



create or replace view Q9(Sector, Industry, Number)
as
select ct.Sector, ct.Industry, count(ct.Code)
from   Category ct
group by ct.Industry, ct.Sector 
order by ct.Sector, ct.Industry;


create or replace view Q10(Code, Industry)
as
select ct.Code, ct.Industry 
from   Category ct
where ct.Industry in (select Industry from Q9 where Number = 1)
order by ct.Code;




create or replace view Q11(Sector, AvgRating)
as
select ct.Sector, avg(r.star)
from   Category ct, Rating r 
where ct.Code = r.Code
group by ct.Sector
order by avg(r.star) desc;


create or replace view Q12(Name)
as
select e.Person
from   Executive e  
group by e.Person 
having count(Code)>1
order by e.Person;


create or replace view Q13(Code, Name, Address, Zip, Sector)
as
select c.Code, c.Name, c.Address, c.Zip, ct.Sector 
from   Company c, Category ct
where  c.code = ct.code and ct.sector not in(select ct.Sector 
from Q1 q, company c, category ct
where q.name = c.name and c.code =ct.code
group by ct.sector)
order by c.Code;

create or replace view Q14(Code, BeginPrice, EndPrice, Change, Gain) 
as 
select a.Code, a.Price, b.Price, b.Price-a.Price, ((b.Price-a.Price)/a.Price)*100
from ASX a, ASX b
where a.Code = b.Code and a."Date" = (select  "Date" 
from Q7_1
where code = a.code
order by "Date"  limit 1) and b."Date" = (select  "Date" 
from Q7_1
where code = a.code
order by "Date" desc limit 1)
group by a.Code,a.price, b.price
order by ((b.Price-a.Price)/a.Price)*100 desc, a.Code;


create or replace view Q15(Code, MinPrice, AvgPrice, MaxPrice, MinDayGain, AvgDayGain, MaxDayGain) 
as
select code, min(PrevPrice), avg(PrevPrice), max(PrevPrice), min(Gain), avg(Gain), max(Gain)
from Q7 
group by Code
order by Code;



create function checkPerson() returns trigger as $$
begin
	  if ( new.person in (select person from Executive) ) then
	  	 raise exception 'One person can not be executive for more than one company';
	  end if;
	  return new;
end;
$$ language plpgsql; 

create trigger checkPerson before insert or update
on Executive for each row execute procedure checkPerson();



create or replace view Q17_1( sector, "Date", gain)
as
select ct.sector, q7."Date", q7.gain
from  q7, category ct
where q7.code = ct.code ;


create or replace view Q17_2( sector, "Date", maxgain, mingain)
as
select sector,"Date", max(gain), min(gain)
from  q17_1 
group by sector, "Date"
order by sector, "Date";





create function updateRate() returns trigger as $$
begin
	  new.sector  = (select distinct sector from category where new.code = code);
	  new.gain = (select gain from q7 where new."Date" = "Date" and new.code = code);
	  if (new.gain = (select maxgain from q17_2 where new.sector = sector and new."Date" = "Date")) then
	  	 update rating SET star = 5 where code = new.code;
	  ELSIF (new.gain = (select mingain from q17_2 where new.sector = sector and new."Date" = "Date")) then
	  	 update rating SET star = 1 where code = new.code;
	  end if; 
	  return new;
end;
$$ language plpgsql; 


create trigger updateRate after insert or update
on ASX for each row execute procedure updateRate();





create function log() returns trigger as $$
begin
	  insert into ASXLog values (localtimestamp, old."Date", old.code, old.volume, old.price);
	  return new; 
end;
$$ language plpgsql; 

create trigger log before update
on ASX for each row execute procedure log();




