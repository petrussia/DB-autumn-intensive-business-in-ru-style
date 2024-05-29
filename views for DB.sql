--1 представление 
--Получить ФИО всех студентов, успешно завершивших обучение. (можно добавить выбор по направлению)
CREATE OR REPLACE VIEW students_successful AS
SELECT p.surname, p.name, p.patronymic
FROM "People" p
JOIN "Students" s ON p.id = s.student_id
JOIN "Progress status" ps ON ps.id = s.progress_status_id
JOIN "Directions" d ON d.id = s.direction_id
WHERE progress_statuses = 'Успешно прошёл обучение';

--2 представление 
--Получить ФИО и должность всех руководителей. (можно добавить выбор по направлению, факультету и университету)
CREATE OR REPLACE VIEW leaders_and_post AS
SELECT p.surname, p.name, p.patronymic, po.post
FROM "People" p
JOIN "Leaders" l ON p.id = l.leader_id
JOIN "Educational programs at faculties" epf ON p.education_id = epf.id
JOIN "Educational programs" ep ON epf.direction_id = ep.id
JOIN "Faculties" f ON epf.faculty_id = f.id
JOIN "Universities" u ON f.university_id = u.id
JOIN "Posts" po ON l.post_id = po.id;

--3 представление 
--Получить все темы и домашние задания. (можно добавить выбор по направлению)
CREATE OR REPLACE VIEW themes_and_homeworks AS
SELECT t.name, t.homework
FROM "Themes" t
JOIN "Directions" d ON t.direction_id = d.id;
 
--4 представление 
--Получить всех студентов, количество посещений на различных темам которых превышает среднее значение по всем строкам таблицы Обучение.
CREATE OR REPLACE VIEW average_visits_materials AS
SELECT *
FROM public."Education"
WHERE visits > (SELECT AVG(visits) FROM public."Education");

--5 представление 
--Получить ФИО студентов и темы их домашних заданий, которые они не выполнили.
CREATE OR REPLACE VIEW students_with_unfinished_homework AS
SELECT p.surname, p.name, p.patronymic
FROM "People" p
JOIN "Students" s ON p.id = s.student_id
WHERE s.progress_status_id = (
SELECT id FROM public."Progress status" 
WHERE progress_statuses = 'Неудачно прошёл обучение')
AND s.mentor_id = 1; 

--6 представление 
--Получить количество студентов, обучающихся по направлениям.
CREATE OR REPLACE VIEW students_per_direction AS
SELECT COUNT(*)
FROM "Students" s
JOIN "Directions" d ON s.direction_id = d.id 
GROUP BY d.name;


