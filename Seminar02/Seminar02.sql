/*
1. Используя операторы языка SQL, создайте табличку “sales”. Заполните ее данными
2. Сгруппируйте значений количества в 3 сегмента — меньше 100, 100-300 и больше 300, используя функцию IF
3. Создайте таблицу “orders”, заполните ее значениями. Покажите “полный” статус заказа, используя оператор CASE
4. Чем NULL отличается от 0?
*/

DROP DATABASE IF EXISTS seminar02;
CREATE DATABASE IF NOT EXISTS seminar02;

USE seminar02;

/* 
1. Используя операторы языка SQL, создайте табличку “sales”. Заполните ее данными
*/
DROP TABLE IF EXISTS sales;
CREATE TABLE IF NOT EXISTS sales
(
	id INT PRIMARY KEY AUTO_INCREMENT,
	order_date DATE NOT NULL,
	count_product INT
);

INSERT INTO sales(order_date, count_product)
VALUES
	(DATE '2022-01-01', 156),
	(DATE '2022-01-02', 180),
	(DATE '2022-01-03', 21),
	(DATE '2022-01-04', 124),
	(DATE '2022-01-05', 341);
	
/*
2. Сгруппируйте значений количества в 3 сегмента — меньше 100, 100-300 и больше 300, используя функцию IF
*/	
-- выборка через конструкцию IF
SELECT
	id,
	IF(count_product < 100, "Маленький заказ",
		IF(count_product BETWEEN 100 AND 300, "Средний заказ", "Большой заказ")) AS "Тип заказа"
FROM sales;

-- выборка через конструкцию CASE
SELECT 
	id,
    CASE
		WHEN count_product < 100 THEN "Маленький заказ"
        WHEN count_product BETWEEN 100 AND 300 THEN "Средний заказ"
        ELSE "Большой заказ"
    END AS "Тип заказа"
FROM sales;

/*
3. Создайте таблицу “orders”, заполните ее значениями. Покажите “полный” статус заказа, используя оператор CASE
*/
DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(20),
    amount FLOAT DEFAULT 0.0,
	order_status VARCHAR(20)
);

INSERT INTO orders (employee_id, amount, order_status)
VALUES
('s03', 15.00, "OPEN"),
('e01', 25.50, "OPEN"),
('e05', 100.70, "CLOSED"),
('e02', 22.18, "OPEN"),
('e04', 9.50, "CANCELLED");

-- выборка через конструкцию IF
SELECT	
	id,
	employee_id,
    amount,
    order_status,
	IF(order_status = "OPEN", "Order is in open state",
		IF(order_status = "CLOSED", "Order is closed",
			IF(order_status = "CANCELLED", "Order is cancelled", ""))) AS full_order_status
FROM orders;

-- выборка через конструкцию CASE
SELECT
	id,
    employee_id,
    amount,
    order_status,
	CASE
		WHEN order_status = "OPEN" THEN "Order is in open state"
        WHEN order_status = "CLOSED" THEN "Order is closed"
        WHEN order_status = "CANCELLED" THEN "Order is cancelled"
        ELSE ""
    END AS full_order_status
FROM orders;

/*
4. Чем NULL отличается от 0?

NULL - это специальное значение, которое используется в SQL для обозначения отсутствия данных. Оно отличается от пустой строки или нулевого значения, так как NULL означает отсутствие какого-либо значения в ячейке таблицы.
*/