/*
1. Создайте представление, в которое попадут автомобили стоимостью 
до 25 000 долларов

2. Изменить в существующем представлении порог для стоимости: 
пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW)

3. Создайте представление, в котором будут только автомобили марки 
“Шкода” и “Ауди” (аналогично)

Доп задания:
1* Получить ранжированный список автомобилей по цене в порядке возрастания
2* Получить топ-3 самых дорогих автомобилей, а также их общую стоимость
3* Получить список автомобилей, у которых цена больше предыдущей цены
4* Получить список автомобилей, у которых цена меньше следующей цены
5*Получить список автомобилей, отсортированный по возрастанию цены, 
и добавить столбец со значением разницы между текущей ценой 
и ценой следующего автомобиля
*/

DROP DATABASE IF EXISTS seminar05;
CREATE DATABASE IF NOT EXISTS seminar05;

USE seminar05;
DROP TABLE IF EXISTS `cars`;
CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT *
    FROM cars;

/*
1. Создайте представление, в которое попадут автомобили стоимостью 
до 25 000 долларов
*/
DROP VIEW IF EXISTS cars_low_price;
CREATE VIEW cars_low_price AS
SELECT * 
    FROM Cars
    WHERE cost < 25000;

SELECT *
    FROM cars_low_price;

/*
2. Изменить в существующем представлении порог для стоимости: 
пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW)
*/
ALTER VIEW cars_low_price AS
    SELECT * 
        FROM Cars
        WHERE cost < 30000;

SELECT *
    FROM cars_low_price;

/*
3. Создайте представление, в котором будут только автомобили марки 
“Шкода” и “Ауди” (аналогично)
*/
CREATE VIEW skoda_audi AS 
SELECT *
    FROM cars 
    WHERE name = "Skoda" OR name = "Audi";

SELECT * 
    FROM skoda_audi;

-- Доп задания:
/*
1* Получить ранжированный список автомобилей по цене в порядке возрастания
*/
SELECT
ROW_NUMBER() OVER(ORDER BY cost) AS "Рейтинг по цене", name "Марка", cost "Цена"
    FROM cars; 


/*
2* Получить топ-3 самых дорогих автомобилей, а также их общую стоимость
*/
SELECT name, cost 
FROM 
(
	SELECT * 
        FROM cars
        ORDER BY cost DESC
        LIMIT 3
) 
AS top
UNION ALL
SELECT "Общая цена топовых машин", SUM(cost) 
    FROM 
    (
        SELECT * 
            FROM cars 
            ORDER BY cars.cost DESC 
            LIMIT 3
    ) 
    AS subquery;
/* Ура, работает, но есть два вопроса:
1. Не очень хочется в строках лимит использовать magic number —
лучше бы переменную.
2. Второй запрос почти повторяет первый, но мне не понятно, 
как при попытке использовать "top" сделать второй запрос короче.
Система выдает: отстутствие таблицы "top".
Однако — работает. .)
Буду рад обратной связи!
*/


/*
3* Получить список автомобилей, у которых цена больше предыдущей цены

-------------- ИСХОДНИК -------------- 
id  name        cost    
1	Audi	    52642
2	Mercedes	57127
3	Skoda	    9000
4	Volvo	    29000
5	Bentley	    350000
6	Citroen 	21000
7	Hummer	    41400
8	Volkswagen 	21600

------ добавление предыдущей цены -----
id  name        cost    previous_cost
1	Audi	    52642	NULL            
2	Mercedes	57127	52642           <--
3	Skoda	    9000	57127
4	Volvo	    29000	9000            <--
5	Bentley	    350000	29000           <--
6	Citroen 	21000	350000
7	Hummer	    41400	21000           <--
8	Volkswagen 	21600	41400

-------------- РЕЗУЛЬТАТ --------------
id  name        cost    previous_cost
2	Mercedes	57127	52642           <--
4	Volvo	    29000	9000            <--
5	Bentley	    350000	29000           <--
7	Hummer	    41400	21000           <--
*/
SELECT name 
    FROM 
    (
        SELECT *, LAG(cost) OVER() AS previous_cost
            FROM cars
    ) AS subquery
    WHERE subquery.cost > subquery.previous_cost;


/*
4* Получить список автомобилей, у которых цена меньше следующей цены

-------------- ИСХОДНИК -------------- 
id  name        cost    
1	Audi	    52642
2	Mercedes	57127
3	Skoda	    9000
4	Volvo	    29000
5	Bentley	    350000
6	Citroen 	21000
7	Hummer	    41400
8	Volkswagen 	21600

------ добавление следующей цены -----
id  name        cost    next_cost
1	Audi	    52642	57127       <--
2	Mercedes	57127	9000
3	Skoda	    9000	29000       <--
4	Volvo	    29000	350000      <--
5	Bentley	    350000	21000
6	Citroen 	21000	41400       <--
7	Hummer	    41400	21600
8	Volkswagen 	21600	NULL

-------------- РЕЗУЛЬТАТ --------------
id  name        cost    next_cost
1	Audi	    52642	57127       <--
3	Skoda	    9000	29000       <--
4	Volvo	    29000	350000      <--
6	Citroen 	21000	41400       <--
*/
SELECT name 
    FROM 
    (
        SELECT *, LEAD(cost) OVER() AS next_cost
            FROM cars
    ) AS subquery
    WHERE subquery.cost < subquery.next_cost;


/*
5*Получить список автомобилей, отсортированный по возрастанию цены, 
и добавить столбец со значением разницы между текущей ценой 
и ценой следующего автомобиля

----- Сортировка по возрастанию цены -----
id  name        cost    
3	Skoda	    9000
6	Citroen 	21000
8	Volkswagen 	21600
4	Volvo	    29000
7	Hummer	    41400
1	Audi	    52642
2	Mercedes	57127
5	Bentley	    350000

----- Добавление поля next_cost ----------
id  name        cost    next_cost   diff
3	Skoda	    9000	21000	    12000
6	Citroen 	21000	21600	    600
8	Volkswagen 	21600	29000	    7400
4	Volvo	    29000	41400	    12400
7	Hummer	    41400	52642	    11242
1	Audi	    52642	57127	    4485
2	Mercedes	57127	350000	    292873
5	Bentley	    350000	NULL        NULL	

----- Вычисление разницы -----------------
id  name        cost    next_cost   diff
3	Skoda	    9000	21000	    12000
6	Citroen 	21000	21600	    600
8	Volkswagen 	21600	29000	    7400
4	Volvo	    29000	41400	    12400
7	Hummer	    41400	52642	    11242
1	Audi	    52642	57127	    4485
2	Mercedes	57127	350000	    292873
5	Bentley	    350000	NULL        NULL	
*/
SELECT name AS "Марка", subquery.next_cost - subquery.cost AS "Разница в цене со следующей позицией" 
    FROM 
    (
        SELECT *, LEAD(cost) OVER() AS next_cost
            FROM 
            (
                SELECT * 
                    FROM cars
                    ORDER BY cars.cost
            )
            cars
    ) AS subquery;



