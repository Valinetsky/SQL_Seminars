# 1. Создайте таблицу с мобильными телефонами, используя графический интерфейс. Заполните БД данными. Добавьте скриншот на платформу в качестве ответа на ДЗ
CREATE SCHEMA `seminar01`;
CREATE TABLE `seminar01`.`phones` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ProductName` VARCHAR(45) NOT NULL,
  `Manufacturer` VARCHAR(45) NOT NULL,
  `ProductCount` INT UNSIGNED NULL,
  `Price` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `ProductName_UNIQUE` (`ProductName` ASC) VISIBLE);
  
INSERT INTO `seminar01`.`phones` (`ProductName`, `Manufacturer`, `ProductCount`, `Price`) VALUES ('iPhone X', 'Apple', '3', '76000');
INSERT INTO `seminar01`.`phones` (`ProductName`, `Manufacturer`, `ProductCount`, `Price`) VALUES ('iPhone 8', 'Apple', '2', '51000');
INSERT INTO `seminar01`.`phones` (`ProductName`, `Manufacturer`, `ProductCount`, `Price`) VALUES ('Galaxy S9', 'Samsung', '2', '56000');
INSERT INTO `seminar01`.`phones` (`ProductName`, `Manufacturer`, `ProductCount`, `Price`) VALUES ('Galaxy S8', 'Samsung', '1', '41000');
INSERT INTO `seminar01`.`phones` (`ProductName`, `Manufacturer`, `ProductCount`, `Price`) VALUES ('P20 Pro', 'Huawei', '5', '36000');



# 2. Выведите название, производителя и цену для товаров, количество которых превышает 2 (SQL - файл, скриншот, либо сам код)
SELECT ProductName, Manufacturer, Price 
FROM seminar01.phones
WHERE ProductCount >=2;

# 3. Выведите весь ассортимент товаров марки “Samsung”
# кратко
SELECT ProductName 
FROM seminar01.phones
WHERE Manufacturer = 'Samsung';
# все поля
SELECT * 
FROM seminar01.phones
WHERE Manufacturer = 'Samsung';

# 4.*** С помощью регулярных выражений найти:
#	4.1. Товары, в которых есть упоминание "Iphone"
SELECT * 
FROM seminar01.phones 
WHERE ProductName REGEXP 'Iphone' || Manufacturer REGEXP 'Iphone';

#	4.2. "Samsung"
SELECT * 
FROM seminar01.phones 
WHERE ProductName REGEXP 'Samsung' || Manufacturer REGEXP 'Samsung';

#	4.3.  Товары, в которых есть ЦИФРА "8"
SELECT * 
FROM seminar01.phones 
WHERE ProductName REGEXP '[[8]]' || Manufacturer REGEXP '[[8]]';