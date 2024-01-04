SELECT count(DISTINCT customer_id) AS customers_count
from customers
-- запрос считает общее количество покупателей из таблицы customers
;

Первый отчет о десятке лучших продавцов. Таблица состоит из трех колонок - данных о продавце, суммарной выручке с проданных товаров и количестве проведенных сделок, и отсортирована по убыванию выручки:
select
CONCAT(e.first_name,' ',e.last_name) as name, --имя и фамилия продавца
sum(s.quantity) as operations, --количество проведенных сделок
sum(p.price*s.quantity) as income --суммарная выручка продавца за все время
from
employees as e 
join sales as s on
s.sales_person_id=e.employee_id
join products as p on
p.product_id = s.product_id
GROUP BY
e.employee_id, e.first_name, e.last_name
order BY income desc
limit 10
;


Второй отчет содержит информацию о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам. Таблица отсортирована по выручке по возрастанию.
select 
CONCAT(e.first_name,' ',e.last_name) as name, -- имя и фамилия продавца
ROUND(AVG(p.price*s.quantity),0) as average_income --средняя выручка продавца за сделку с округлением до целого
from
employees as e
join sales as s on
s.sales_person_id=e.employee_id
join products as p on
p.product_id = s.product_id
GROUP BY
  e.employee_id, e.first_name, e.last_name
HAVING
  avg(p.price * s.quantity) < (SELECT AVG(p.price * s.quantity) 
  FROM employees e 
  JOIN sales s 
  ON s.sales_person_id = e.employee_id 
  JOIN products p 
  ON p.product_id = s.product_id)
ORDER BY
  average_income ASC;

Третий отчет содержит информацию о выручке по дням недели. Каждая запись содержит имя и фамилию продавца, день недели и суммарную выручку.
  select 
CONCAT(e.first_name,' ',e.last_name) as name, -- имя и фамилия продавца
TO_CHAR(sale_date, 'DAY') as weekday,  --название дня недели на английском языке
SUM(quantity) as income --суммарная выручка продавца в определенный день недели, округленная до целого числа
from
employees as e 
join sales as s on
s.sales_person_id=e.employee_id
join products as p on
p.product_id = s.product_id
GROUP by
e.last_name,
e.first_name,
weekday
order by
name,
weekday
;
