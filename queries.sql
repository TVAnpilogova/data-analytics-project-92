SELECT count(DISTINCT customer_id) AS customers_count
from customers
-- запрос считает общее количество покупателей из таблицы customers
;

top_10_total_income.csv Первый отчет о десятке лучших продавцов. Таблица состоит из трех колонок - данных о продавце, суммарной выручке с проданных товаров и количестве проведенных сделок, и отсортирована по убыванию выручки:
select
CONCAT(e.first_name,' ',e.last_name) as name, --имя и фамилия продавца
count(s.quantity) as operations, --количество проведенных сделок
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
TO_CHAR(sale_date, 'day') as weekday,  --название дня недели на английском языке
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

Первый отчет - количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+
SELECT
    CASE
        WHEN age BETWEEN 16 AND 25 THEN '16-25'
        WHEN age BETWEEN 26 AND 40 THEN '26-40'
        WHEN age >= 41 THEN '40+'
    END AS age_category, -- возрастная группа
    COUNT(*) AS count -- количество человек в группе
FROM
    customers
GROUP BY
    age_category
ORDER BY
    age_category;

Во втором отчете предоставьте данные по количеству уникальных покупателей и выручке, которую они принесли

select
TO_CHAR(sale_date, 'YYYY-MM') as date, --дата в указанном формате
COUNT(distinct customer_id) as total_customers, --количество покупателей
round(sum(distinct s.quantity*p.price),0) as income --принесенная выручка
from sales as s
join products as p on 
p.product_id = s.product_id
group by date
order by date asc
;

Третий отчет следует составить о покупателях, первая покупка которых была в ходе проведения акций (акционные товары отпускали со стоимостью равной 0)

select
CONCAT(c.first_name,' ',c.last_name) as customer, --имя и фамилия покупателя
TO_CHAR(MIN(s.sale_date), 'YYYY-MM-DD') as sale_date, --дата покупки
CONCAT(e.first_name,' ',e.last_name) as seller --имя и фамилия продавца
from customers as c
join sales as s on
s.customer_id = c.customer_id
join employees as e on
s.sales_person_id = e.employee_id
join products as p on 
p.product_id = s.product_id
where
p.price = 0
group by c.customer_id,
e.employee_id
order by c.customer_id
;


