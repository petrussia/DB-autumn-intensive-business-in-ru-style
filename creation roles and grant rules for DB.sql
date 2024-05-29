SELECT rolname FROM pg_roles

CREATE ROLE intensive_participant; -- участник интенсива
CREATE ROLE mentor; -- ментор
CREATE ROLE head_of_direction; -- глава направления
CREATE ROLE CEO; -- Глава Бизнес в Стиле. Ру

GRANT INSERT, SELECT, UPDATE, DELETE ON "People"  TO intensive_participant;
GRANT SELECT, UPDATE, DELETE ON "People" TO mentor;
GRANT SELECT, UPDATE, DELETE ON "People" TO head_of_direction;
GRANT SELECT, UPDATE, DELETE ON "People" TO CEO;

GRANT SELECT ON "Educational programs" TO intensive_participant;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Educational programs" TO mentor;
GRANT SELECT ON "Educational programs" TO head_of_direction;
GRANT SELECT ON "Educational programs" TO CEO;

GRANT SELECT ON "Educational programs at faculties" TO intensive_participant;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Educational programs at faculties" TO mentor;
GRANT SELECT ON "Educational programs at faculties" TO head_of_direction;
GRANT SELECT ON "Educational programs at faculties" TO CEO;

GRANT SELECT ON "Faculties" TO intensive_participant;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Faculties" TO mentor;
GRANT SELECT ON "Faculties" TO head_of_direction;
GRANT SELECT ON "Faculties" TO CEO;

GRANT SELECT ON "Universities" TO intensive_participant;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Universities" TO mentor;
GRANT SELECT ON "Universities" TO head_of_direction;
GRANT SELECT ON "Universities" TO CEO;

GRANT SELECT ON "Statuses" TO intensive_participant;
GRANT SELECT ON "Statuses" TO mentor;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Statuses" TO head_of_direction;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Statuses" TO CEO;

GRANT SELECT ON "Students" TO intensive_participant;
GRANT SELECT, UPDATE ON "Students" TO mentor;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Students" TO head_of_direction;
GRANT SELECT ON "Students" TO CEO;

GRANT SELECT ON "Progress status" TO intensive_participant;
GRANT SELECT ON "Progress status" TO mentor;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Progress status" TO head_of_direction;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Progress status" TO CEO;

GRANT SELECT ON "Leaders" TO mentor;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Leaders" TO head_of_direction;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Leaders" TO CEO;

GRANT SELECT ON "Posts" TO mentor;
GRANT SELECT ON "Posts" TO head_of_direction;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Posts" TO CEO;

GRANT SELECT ON "Education" TO intensive_participant;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Education" TO mentor;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Education" TO head_of_direction;
GRANT SELECT ON "Education" TO CEO;

GRANT SELECT ON "Themes" TO intensive_participant;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Themes" TO mentor;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Themes" TO head_of_direction;
GRANT SELECT ON "Themes" TO CEO;

GRANT SELECT ON "Directions" TO intensive_participant;
GRANT SELECT ON "Directions" TO mentor;
GRANT SELECT ON "Directions" TO head_of_direction;
GRANT INSERT, SELECT, UPDATE, DELETE ON "Directions" TO CEO;

