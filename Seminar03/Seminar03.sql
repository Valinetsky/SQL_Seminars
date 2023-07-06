/*
Условие по таблице staff:
Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания
Выведите 5 максимальных заработных плат (salary)
Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
Найдите количество специальностей
Выведите специальности, у которых средний возраст сотрудников меньше 30 лет включительно

1. Выведите id сотрудников, которые напечатали более 500 страниц за всех дни

2. Выведите дни, когда работало более 3 сотрудников Также укажите кол-во сотрудников, которые работали в выбранные дни.

3. Выведите среднюю заработную плату по должностям, которая составляет более 30000
*/

DROP DATABASE IF EXISTS seminar03;
CREATE DATABASE IF NOT EXISTS `seminar03`;
USE `seminar03`;

DROP TABLE IF EXISTS `staff`;
CREATE TABLE IF NOT EXISTS `staff`
(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`firstname` VARCHAR(45),
`lastname` VARCHAR(45),
`post` VARCHAR(45),
`seniority` INT,
`salary` INT,
`age` INT);

INSERT INTO `staff` (`firstname`, `lastname`, `post`,`seniority`,`salary`, `age`)
VALUES
('Вася', 'Васькин', 'Начальник', 40, 100000, 60), 
('Петр', 'Власов', 'Начальник', 8, 70000, 30),
('Катя', 'Катина', 'Инженер', 2, 70000, 25),
('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
('Иван', 'Петров', 'Рабочий', 40, 30000, 59),
('Петр', 'Петров', 'Рабочий', 20, 55000, 60),
('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
('Максим', 'Петров', 'Рабочий', 2, 11000, 19),
('Юрий', 'Петров', 'Рабочий', 3, 12000, 24),
('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);

SELECT * FROM staff;

DROP TABLE IF EXISTS `activity_staff`;
CREATE TABLE IF NOT EXISTS `activity_staff`
(`id` INT PRIMARY KEY AUTO_INCREMENT,
`staff_id` INT,
FOREIGN KEY (staff_id) REFERENCES staff(id),
`date_activity` DATE,
`count_pages` INT
);


INSERT activity_staff (`staff_id`, `date_activity`, `count_pages`)
VALUES
(1,'2022-01-01',250),
(2,'2022-01-01',220),
(3,'2022-01-01',170),
(1,'2022-01-02',100),
(2,'2022-01-01',220),
(3,'2022-01-01',300),
(7,'2022-01-01',350),
(1,'2022-01-03',168),
(2,'2022-01-03',62),
(3,'2022-01-03',84);

-- Посчитаем среднюю зарплату по фирме 
SELECT AVG(salary) FROM staff;

-- Выведем информацию о людях, у которых зарплата выше средней 
-- SELECT * FROM staff WHERE salary > AVG(salary); -- Неверная запись

SELECT * FROM staff WHERE salary > (SELECT AVG(salary) FROM staff);

SELECT * FROM staff WHERE salary > 38500; 

-- Получим информацию по зарплатам сотрудников, от меньшего к большему 
SELECT * FROM staff
ORDER BY salary ASC; -- ASC - исходный параметр возрастания


-- Получим информацию по зарплатам сотрудников, от большего к меньшему
SELECT * FROM staff
ORDER BY salary DESC; -- DESC - параметр убывания 
 
 -- Получим информацию по зарплатам сотрудников, от большего к меньшему, стаж > 5 лет, должность = Рабочий 
 
 SELECT * FROM staff
 WHERE seniority > 5 AND post = "Рабочий"
ORDER BY salary DESC;


-- Сколько всего фамилий 
SELECT COUNT(lastname) FROM staff;

SELECT lastname FROM staff
ORDER BY lastname;

SELECT  DISTINCT lastname FROM staff
ORDER BY lastname;

-- Колво уникальных фамилий
SELECT COUNT(DISTINCT lastname) FROM staff;

SELECT id, lastname
FROM staff
LIMIT 5; -- колво выведенных строк


SELECT lastname
FROM staff
LIMIT 4,5; -- 4 - сколько пропустить строк, 5 - сколько вывести строк 


SELECT lastname
FROM staff
ORDER BY id DESC
LIMIT 4,5;


-- Максимальную и минимальную зарплаты по каждой должности 
SELECT salary, lastname, post,
MAX(salary) AS 'Максимальная зарплата',
MIN(salary) AS 'Минимальная зарплата',
MAX(salary) - MIN(salary) AS 'Разность мин макс'
FROM staff
GROUP BY post;

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT SUM(salary) 'Сумма по должности',
GROUP_CONCAT(lastname) 'Фамилии сотрудников', post,
MAX(salary) AS 'Максимальная зарплата',
MIN(salary) AS 'Минимальная зарплата',
MAX(salary) - MIN(salary) AS 'Разность мин макс'
FROM staff
GROUP BY post;

SELECT CONCAT(firstname, ' ', lastname) FROM staff;

-- 1. Выведите общее количество напечатанных страниц каждым сотрудником
SELECT * FROM activity_staff;

SELECT staff_id, SUM(count_pages) AS 'Sum' FROM activity_staff
GROUP BY staff_id;

-- 2. Посчитайте количество страниц за каждый день

SELECT date_activity, SUM(count_pages) AS 'Sum' FROM activity_staff
GROUP BY date_activity;


-- 3. Найдите среднее арифметическое по количеству ежедневных страниц 

SELECT date_activity, AVG(count_pages) AS 'Avg' FROM activity_staff
GROUP BY date_activity;


/*Сгруппируйте данные о сотрудниках по возрасту: 
1 группа – младше 20 лет
2 группа – от 20 до 40 лет
3 группа – старше  40 лет 
Для каждой группы  найдите суммарную зарплату 
*/


SELECT SUM(salary), name_age
FROM
(SELECT salary,
	CASE 
		WHEN age < 20 THEN 'младше 20 лет'
        WHEN age BETWEEN 20 AND 40 THEN 'от 20 до 40 лет'
        WHEN age > 40 THEN 'старше  40 лет'
        ELSE 'Не определено'
	END AS name_age 
FROM staff) AS `lists`
GROUP BY name_age;

SELECT AVG(sum_pages)
FROM
(SELECT date_activity, SUM(count_pages) AS 'sum_pages'
FROM activity_staff
GROUP BY date_activity) AS `lists`;

/*
SELECT salary, COUNT(id)
FROM staff
GROUP BY salary
WHERE salary > 50000; -- Неверная запись
*/


SELECT salary, COUNT(id)
FROM staff
GROUP BY salary
HAVING salary > 50000;

SELECT salary
FROM staff
WHERE salary > 50000;


SELECT salary
FROM staff
HAVING AVG(salary) > 10000;

SELECT salary, COUNT(id) AS 'Колво'
FROM staff
WHERE post !="Начальник"
GROUP BY salary
HAVING salary > 50000;


/*
SELECT
FROM
WHERE
GROUP BY
HAVING
ODRER BY
LIMIT
*/


/*
1. Выведите id сотрудников, которые напечатали более 500 страниц за все дни

2. Выведите дни, когда работало более 3 сотрудников Также укажите кол-во сотрудников, которые работали в выбранные дни.

3. Выведите среднюю заработную плату по должностям, которая составляет более 30000
*/

-- 1. Выведите id сотрудников, которые напечатали более 500 страниц за все дни
SELECT staff_id FROM activity_staff
GROUP BY staff_id
HAVING SUM(count_pages) > 500;

-- 2. Выведите дни, когда работало более 3 сотрудников Также укажите кол-во сотрудников, которые работали в выбранные дни.
SELECT date_activity, 
COUNT(count_pages) AS cnt_staff 
FROM activity_staff
GROUP BY date_activity
HAVING cnt_staff > 3;

-- 3. Выведите среднюю заработную плату по должностям, которая составляет более 30000
/*
SELECT post
FROM staff
GROUP BY post
HAVING AVG(salary) > 30000;
-- или так:
SELECT salary, post
FROM staff
GROUP BY salary
HAVING AVG(salary) > 30000;
*/
-- Выше ^^^ - попытки кода... Но, думаю следующий блок — наиболее соответствует условию задачи.
SELECT AVG(salary) AS avg_salary, post
FROM staff
GROUP BY post
HAVING avg_salary > 30000;




-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*
Условие по таблице staff:
Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания
Выведите 5 максимальных заработных плат (salary)
Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
Найдите количество специальностей
Выведите специальности, у которых средний возраст сотрудников меньше 30 лет включительно
*/

-- 1. Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания
-- в порядке: убывания
SELECT * FROM staff ORDER BY salary DESC;
-- в порядке: возрастания
SELECT * FROM staff ORDER BY salary;

-- 2. Выведите 5 максимальных заработных плат (salary)
SELECT salary 
FROM staff 
ORDER BY salary DESC 
LIMIT 5;

-- 3. Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
SELECT post AS "Должность", SUM(salary) AS "Сумма зарплат"
FROM staff
GROUP BY post;

-- 4. Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
SELECT post, COUNT(*)  AS "Количество сотрудников"
FROM staff 
WHERE post = "Рабочий" && age >= 24 && age <= 42
GROUP BY post;

-- 5. Найдите количество специальностей
SELECT COUNT(distinct post) AS "Количество специальностей"
FROM staff;

-- 6. Выведите специальности, у которых средний возраст сотрудников меньше 30 лет включительно
SELECT post, AVG(age)
FROM staff
GROUP BY post
HAVING AVG(age) <= 30;