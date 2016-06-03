CREATE SEQUENCE pic_id
MINVALUE 1
START WITH 1
INCREMENT BY 1	
NOCACHE;

CREATE SEQUENCE rec_id
MINVALUE 1
START WITH 14
INCREMENT BY 1	
NOCACHE;

CREATE OR REPLACE TRIGGER user_manage_insert
BEFORE INSERT ON persons
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM persons
	WHERE person_id = :NEW.person_id;

	IF counter > 0
	THEN
		raise_application_error(-20101, 'The ID has already been registrated!!!!!!!!!!!!!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert1
BEFORE UPDATE OR INSERT ON persons
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM persons p
	WHERE p.email = :NEW.email AND
		p.person_id <> :NEW.person_id;

	IF counter > 0
	THEN
		raise_application_error(-20102, 'The email has already been registrated!!!!!!!!!!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert2
BEFORE UPDATE OR INSERT ON users
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM users p
	WHERE user_name = :NEW.user_name AND
		p.person_id <> :NEW.person_id;

	IF counter > 0
	THEN
		raise_application_error(-20103, 'The user name has already been registrated!!!!!!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert3
BEFORE INSERT ON users
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM persons p
	WHERE p.person_id = :NEW.person_id;

	IF counter < 1
	THEN
		raise_application_error(-20104, 'The users person ID does not exist!!!!!!!!!!!!!!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert4
BEFORE UPDATE OR INSERT ON family_doctor
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM family_doctor
	WHERE doctor_id = :NEW.doctor_id AND
		patient_id  = :NEW.patient_id;

	IF counter > 0
	THEN
		raise_application_error(-20105, 'This pair has already been recorded!!!!!!!!!!!!!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert5
BEFORE UPDATE OR INSERT ON family_doctor
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM persons p1, persons p2
	WHERE p1.person_id = :NEW.doctor_id and
		p2.person_id  = :NEW.patient_id;

	IF counter < 1
	THEN
		raise_application_error(-20106, 'This is not a exist id!!!!!!!!!!!!!!!!!!!!!!!!!!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert6
BEFORE UPDATE OR INSERT ON radiology_record
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM family_doctor fd
	WHERE :NEW.patient_id = fd.patient_id and
		:NEW.doctor_id = fd.doctor_id;

	IF counter < 1
	THEN
		raise_application_error(-20107, 'This is not a exist pair of patient and doctor!!');
	END IF;
COMMIT;
END;
/

CREATE OR REPLACE TRIGGER user_manage_insert7
BEFORE INSERT ON users
FOR EACH ROW
DECLARE counter INTEGER;
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT count(*) INTO counter
	FROM users u
	WHERE u.person_id = :NEW.person_id and
		:NEW.class = u.class;

	IF counter > 0
	THEN
		raise_application_error(-20108, 'A user cannot regist two accounts of same class!');
	END IF;
COMMIT;
END;
/
