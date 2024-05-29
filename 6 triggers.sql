SELECT * FROM "Students"
SELECT * FROM "People"
SELECT * FROM "Leaders"

-- 1 триггер

-- Автоматическое добавление в таблицу Студенты id при 
--добавлении строки в таблицу Люди с полем status_id, ссылающимся 
--на строку в таблице Статусы с полем status со значением С:
CREATE OR REPLACE FUNCTION add_new_student()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.status_id = (SELECT id FROM public."Statuses" WHERE status = 'С') THEN
        INSERT INTO public."Students" (student_id, start_date)
        VALUES (NEW.id, CURRENT_DATE);
    END IF;
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_add_new_student
AFTER INSERT ON public."People"
FOR EACH ROW
EXECUTE FUNCTION add_new_student();

-- 2 триггер

-- Автоматическое добавление в таблицу Руководители id при 
-- добавлении строки в таблицу Люди с полем status_id, ссылающимся 
-- на строку в таблице Статусы с полем status со значением Р:
CREATE OR REPLACE FUNCTION add_new_leader()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.status_id = (SELECT id FROM public."Statuses" WHERE status = 'Р') THEN
        INSERT INTO public."Students" (leader_id, start_date)
        VALUES (NEW.id, CURRENT_DATE);
    END IF;
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_add_new_leader
AFTER UPDATE OF status_id ON public."People"
FOR EACH ROW
EXECUTE FUNCTION add_new_leader();

-- 3 триггер

-- Автоматическое добавление строк в таблицу Обучение при 
-- изменении поля direction_id в таблице Студенты. Поля должны 
-- содержать студента и все темы, которые включены в направление 
-- выбранном в поле direction_id:
CREATE OR REPLACE FUNCTION change_direction()
RETURNS TRIGGER AS
$$
	DECLARE
	iterator integer;
	theme_id_arr numeric(6)[];
BEGIN
    IF NEW.direction_id != OLD.direction_id THEN
	theme_id_arr = ARRAY(SELECT id FROM public."Themes" WHERE direction_id = NEW.direction_id);
		FOR iterator IN 1..array_length(theme_id_arr, 1) LOOP
        INSERT INTO public."Education" (theme_id, student_id, visits, number_of_homework, finish)
        VALUES (theme_id_arr[iterator], NEW.id, 0, 0, 'Нет');
		END LOOP;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_change_direction
AFTER UPDATE OF direction_id ON public."Students"
FOR EACH ROW
EXECUTE FUNCTION change_direction();

-- 4 триггер

-- Автоматическое удаление поля в таблице Студенты и 
-- добавление в таблицу Руководители при изменении поля status_id, 
-- ссылающимся на строку в таблице Статусы с полем status со значения С на Р:
CREATE OR REPLACE FUNCTION update_student_status()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status_id = (SELECT id FROM public."Statuses" WHERE status = 'Р')
	AND OLD.status_id = (SELECT id FROM public."Statuses" WHERE status = 'С') ) THEN
        DELETE FROM "Students" WHERE student_id = NEW.id;
        INSERT INTO "Leaders" (leader_id, start_date)
        VALUES (NEW.id, CURRENT_DATE);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_update_student_status
AFTER UPDATE OF status_id ON public."People"
FOR EACH ROW
EXECUTE FUNCTION update_student_status();

-- 5 триггер

-- Автоматическое изменение поля Статус_прохождения
-- при выполнении студентом всех тем в направлении:
CREATE OR REPLACE FUNCTION change_students_progress_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.finish !=OLD.finish  THEN
	IF ( SELECT COUNT(theme_id) FROM public."Education" WHERE student_id = NEW.student_id )
	= ( SELECT COUNT(id) FROM public."Themes" 
	WHERE direction_id = ( SELECT direction_id FROM public."Students" WHERE id = NEW.student_id ) ) THEN 
        UPDATE public."Students" SET progress_status_id 
	=	( SELECT id FROM public."Progress status" WHERE progress_statuses = "Успешно прошёл обучение");
    END IF;
	END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_change_students_progress_status
AFTER INSERT OR UPDATE OF finish ON public."Education"
FOR EACH ROW
EXECUTE FUNCTION change_students_progress_status();

-- 6 триггер

-- При переходе студента в руководство, 
-- т.е попытке изменить статус человека на Р, 
-- будет автоматически проверяться, что обучение пройдено успешно:
CREATE OR REPLACE FUNCTION check_before_update_student_status()
RETURNS TRIGGER AS 
$$
BEGIN
	IF (NEW.status_id = (SELECT id FROM public."Statuses" WHERE status = 'Р')
	AND OLD.status_id = (SELECT id FROM public."Statuses" WHERE status = 'С') ) THEN 
	IF ( SELECT progress_status_id FROM public."Students" WHERE student_id = NEW.id ) != 
	( SELECT id FROM "Progress status" WHERE progress_statuses = 'Успешно прошёл обучение' )  
	THEN RAISE EXCEPTION 'ERROR. This student didn''t finish courses succesfully yet. 
	Now, he can''t become a leader.';
	END IF;
	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_check_before_update_student_status
BEFORE UPDATE OF status_id ON public."People"
FOR EACH ROW
EXECUTE FUNCTION check_before_update_student_status();