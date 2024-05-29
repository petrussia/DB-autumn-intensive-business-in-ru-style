-- Создание таблиц


-- Таблица “Направления”:

CREATE TABLE IF NOT EXISTS public."Directions"
(
    id numeric(6,0) NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    start_date date NOT NULL,
    end_date date,
    description character varying(200) COLLATE pg_catalog."default",
    CONSTRAINT "Directions_pkey" PRIMARY KEY (id),
    CONSTRAINT "CHK_name" CHECK (name::text = 'Web-разработка'::text OR name::text = 'Менеджмент'::text OR name::text = 'Дизайн'::text OR name::text = 'Маркетинг'::text) NOT VALID,
    CONSTRAINT "CHK_end_date" CHECK (end_date >= start_date) NOT VALID
)

--Таблица “Обучение”:

CREATE TABLE IF NOT EXISTS public."Education"
(
    id serial(6,0) NOT NULL,
    theme_id numeric(6,0),
    student_id numeric(6,0),
    visits numeric(4,0) NOT NULL,
    number_of_homework numeric(4,0) NOT NULL,
    finish character varying(3) COLLATE pg_catalog."default" NOT NULL,
    additions character varying(200) COLLATE pg_catalog."default",
    CONSTRAINT "Education_pkey" PRIMARY KEY (id),
    CONSTRAINT student_fkey FOREIGN KEY (student_id)
        REFERENCES public."Students" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT theme_fkey FOREIGN KEY (theme_id)
        REFERENCES public."Themes" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "CHK_finish" CHECK (finish::text = 'Да'::text OR finish::text = 'Нет'::text) NOT VALID
)

--Таблица “Образовательные программы”:

CREATE TABLE IF NOT EXISTS public."Educational programs"
(
    id character varying(8) NOT NULL,
    direction character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Educational programs_pkey" PRIMARY KEY (id)
)

--Таблица “Образовательные программы на факультетах”:

CREATE TABLE IF NOT EXISTS public."Educational programs at faculties"
(
    id numeric(4,0) NOT NULL,
    faculty_id character varying(20),
    direction_id character varying(8),
    CONSTRAINT "Educational programs at faculties_pkey" PRIMARY KEY (id),
    CONSTRAINT direction_fkey FOREIGN KEY (direction_id)
        REFERENCES public."Educational programs" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT faculty_fkey FOREIGN KEY (faculty_id)
        REFERENCES public."Faculties" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

--Таблица “Факультеты”:

CREATE TABLE IF NOT EXISTS public."Faculties"
(
    id character varying(20) NOT NULL,
    faculty character varying(100) COLLATE pg_catalog."default" NOT NULL,
    university_id character varying(20),
    CONSTRAINT "Faculties_pkey" PRIMARY KEY (id),
    CONSTRAINT university_fkey FOREIGN KEY (university_id)
        REFERENCES public."Universities" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)


--Таблица “Руководители”:

CREATE TABLE IF NOT EXISTS public."Leaders"
(
    id serial(6,0) NOT NULL,
    direction_id numeric(6,0),
    leader_id numeric(6,0),
    post_id numeric(1,0),
    start_date date NOT NULL,
    end_date date,
    CONSTRAINT "Leaders_pkey" PRIMARY KEY (id),
    CONSTRAINT direction_fkey FOREIGN KEY (direction_id)
        REFERENCES public."Directions" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT leader_fkey FOREIGN KEY (leader_id)
        REFERENCES public."People" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT post_id FOREIGN KEY (post_id)
        REFERENCES public."Posts" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "CHK_end_date" CHECK (end_date >= start_date) NOT VALID
)

--Таблица “Люди”:

CREATE TABLE IF NOT EXISTS public."People"
(
    id numeric(6,0) NOT NULL,
    surname character varying(100) COLLATE pg_catalog."default" NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    patronymic character varying(100) COLLATE pg_catalog."default",
    phone character varying(40) COLLATE pg_catalog."default" NOT NULL,
    vk character varying(100) COLLATE pg_catalog."default" NOT NULL,
    tg character varying(100) COLLATE pg_catalog."default" NOT NULL,
    year numeric(4,0) NOT NULL,
    education_id numeric(4,0),
    status_id character varying(1),
    CONSTRAINT "People_pkey" PRIMARY KEY (id),
    CONSTRAINT education_fkey FOREIGN KEY (education_id)
        REFERENCES public."Educational programs at faculties" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT status_fkey FOREIGN KEY (status_id)
        REFERENCES public."Statuses" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

--Таблица “Должности”:

CREATE TABLE IF NOT EXISTS public."Posts"
(
    id numeric(6,0) NOT NULL,
    post character varying(10) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Posts_pkey" PRIMARY KEY (id),
    CONSTRAINT "CHK_post" CHECK (post::text = 'Ментор'::text OR post::text = 'Глава'::text OR post::text = 'CEO'::text) NOT VALID
)

--Таблица “Статусы прохождения”:

CREATE TABLE IF NOT EXISTS public."Progress status"
(
    id numeric(1,0) NOT NULL,
    progress_statuses character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Progress status_pkey" PRIMARY KEY (id),
    CONSTRAINT "CHK_progress_statuses" CHECK (progress_statuses::text = 'Успешно прошёл обучение'::text OR progress_statuses::text = 'Неудачно прошёл обучение'::text OR progress_statuses::text = 'В процессе обучения'::text) NOT VALID
)

 --Таблица “Статусы”:

CREATE TABLE IF NOT EXISTS public."Statuses"
(
    status character varying(1) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Statuses_pkey" PRIMARY KEY (status),
    CONSTRAINT "CHK_status" CHECK (status::text = 'С'::text OR status::text = 'Р'::text) NOT VALID
)

-- Таблица “Студенты”:

CREATE TABLE IF NOT EXISTS public."Students"
(
    id serial(6,0) NOT NULL,
    direction_id numeric(6,0),
    student_id numeric(6,0),
    mentor_id numeric(6,0),
    start_date date NOT NULL,
    end_date date,
    progress_status_id numeric(1,0),
    CONSTRAINT "Students_pkey" PRIMARY KEY (id),
    CONSTRAINT direction_fkey FOREIGN KEY (direction_id)
        REFERENCES public."Directions" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT mentor_fkey FOREIGN KEY (mentor_id)
        REFERENCES public."Leaders" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT progress_status_fkey FOREIGN KEY (progress_status_id)
        REFERENCES public."Progress status" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT student_fkey FOREIGN KEY (student_id)
        REFERENCES public."People" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "CHK_end_date" CHECK (end_date >= start_date) NOT VALID
)

 --Таблица “Темы”:

CREATE TABLE IF NOT EXISTS public."Themes"
(
    id numeric(6,0) NOT NULL,
    direction_id numeric(6,0),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    homework character varying(200) COLLATE pg_catalog."default" NOT NULL,
    description character varying(200) COLLATE pg_catalog."default",
    CONSTRAINT "Themes_pkey" PRIMARY KEY (id),
    CONSTRAINT direction_fkey FOREIGN KEY (direction_id)
        REFERENCES public."Directions" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

 --Таблица “Университеты”:

CREATE TABLE IF NOT EXISTS public."Universities"
(
    id character varying(20) NOT NULL,
    university character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Universities_pkey" PRIMARY KEY (id)
)


