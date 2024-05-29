-- Индексы по внешним ключам:

CREATE INDEX idx_student_id ON Education(student_id);
CREATE INDEX idx_theme_id ON Education(theme_id);
CREATE INDEX idx_room_direction_id ON "Educational programs at faculties"(direction_id);
CREATE INDEX idx_faculty_id ON "Educational programs at faculties"(faculty_id );
CREATE INDEX idx_university_id ON Faculties(university_id);
CREATE INDEX idx_direction_id ON Leaders(direction_id);
CREATE INDEX idx_leader_id ON Leaders(leader_id);
CREATE INDEX idx_post_id ON Leaders(post_id);
CREATE INDEX idx_education_id ON People(education_id);
CREATE INDEX idx_status_id ON People(status_id);
CREATE INDEX idx_direction_id ON Students(direction_id);
CREATE INDEX idx_mentor_id ON Students(mentor_id);
CREATE INDEX idx_progress_status_id ON Students(progress_status_id);
CREATE INDEX idx_student_id ON Students(student_id);
CREATE INDEX idx_direction_id ON Themes(direction_id);

-- Составной индекс для руководства 
-- для быстрого поиска по списку всех студентов:
CREATE INDEX idx_full name ON People(surname, name, patronymic)

-- Составной индекс, который будет использоваться учащимися для быстрого 
-- поиска всей учебной информации для них в таблице “Обучение”:
CREATE INDEX idx_participants_information ON Education(visits, number_of_homework, finish, additions)

-- Индекс для быстрого поиска должности человека в руководстве:
CREATE INDEX idx_post ON Leaders(post)

-- Составной индекс, который будет использоваться студентами для быстрого 
-- поиска тем и домашних заданий к темам в процессе обучения на направлении:
CREATE INDEX idx_homework_materials_for_theme ON Theme(name, homework)
