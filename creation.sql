CREATE TABLE TEAM(
    TEAM_ID INT NOT NULL,
    TEAM_NAME VARCHAR(100),
    MEMBER_COUNT INT DEFAULT 0, -- Added default value
    PRIMARY KEY (TEAM_ID)
);
CREATE TABLE Member(
    Member_Id INT NOT NULL,
    Member_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(50),
    College_Name VARCHAR(100),
    Ph_No VARCHAR(12),
    Team_Id INT,
    PRIMARY KEY (Member_Id),
    FOREIGN KEY (Team_Id) REFERENCES Team(Team_Id) -- Reference to Team table
);
CREATE TABLE Check_InTime (
    Member_Id INT NOT NULL,
    Check_InTime TIMESTAMP,
    PRIMARY KEY (Member_Id),
    FOREIGN KEY (Member_Id) REFERENCES Member(Member_Id) -- Reference to Member table
);
CREATE SEQUENCE table_no_sequence
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
CREATE TABLE Table_Allocation(
    Table_no INT  DEFAULT table_no_sequence.NEXTVAL,
    Team_Id INT NOT NULL,
    PRIMARY KEY (Table_no),
    FOREIGN KEY (Team_Id) REFERENCES Team(Team_Id) -- Reference to Team table
);
CREATE TABLE Extention_Board_Allocation(
    Extention_board_No INT,
    Team_Id INT,
    PRIMARY KEY (Extention_board_No),
    FOREIGN KEY (Team_Id) REFERENCES Team(Team_Id) -- Reference to Team table
);
CREATE TABLE Mentors(
    Mentor_Id INT NOT NULL,
    Mentor_Name VARCHAR(200),
    Mentor_Ph VARCHAR(12),
    PRIMARY KEY (Mentor_Id)
);
CREATE TABLE Mentor_scores(
    Mentor_Id INT NOT NULL,
    Team_Id INT,
    Team_Score INT,
    PRIMARY KEY (Mentor_Id, Team_Id),
    FOREIGN KEY (Team_Id) REFERENCES Team(Team_Id) -- Reference to Team table
);
CREATE TABLE Submissions(
    Team_Id INT NOT NULL,
    Presentation VARCHAR(100),
    Github_Link VARCHAR(200),
    PRIMARY KEY (Team_Id),
    FOREIGN KEY (Team_Id) REFERENCES Team(Team_Id) -- Reference to Team table
);
CREATE TABLE Judges (
    Judge_Id INT NOT NULL,
    Judge_Name VARCHAR(200),
    PRIMARY KEY (Judge_Id)
);
CREATE TABLE Judge_Scores (
    Judge_Id INT NOT NULL,
    Team_Id INT NOT NULL,
    Score INT,
    PRIMARY KEY (Judge_Id, Team_Id),
    FOREIGN KEY (Judge_Id) REFERENCES Judges(Judge_Id),
    FOREIGN KEY (Team_Id) REFERENCES Team(Team_Id)
);
CREATE TABLE Final_scoresheets (
    Team_Id INT NOT NULL,
    Mentor_Score INT,
    Judge_Score INT,
    Final_Score INT,
    PRIMARY KEY (Team_Id),
    FOREIGN KEY (Team_Id) REFERENCES Team(Team_Id)
);

insert into mentors values(1, 'Mentor 1',9625375211);
insert into mentors values(2, 'Mentor 2',851095566);
insert into mentors values(3, 'Mentor 3',9650875377);insert into judges values(1,'Judge 1');
insert into judges values(2,'Judge 2');

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE insert_team (
    p_team_name IN VARCHAR2
) AS
    v_team_id INT;
BEGIN
    SELECT COALESCE(MAX(TEAM_ID), 0) + 1 INTO v_team_id FROM TEAM;
    INSERT INTO TEAM (TEAM_ID, TEAM_NAME) VALUES (v_team_id, p_team_name);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Team inserted successfully with ID: ' || v_team_id);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END insert_team;
/

BEGIN
    INSERT_TEAM('RUNTIME TERROR');
    INSERT_TEAM('RTFM');
END;
/
SELECT * FROM TEAM;

CREATE OR REPLACE PROCEDURE insert_member (
    p_member_name IN member.member_name%TYPE,
    p_email IN member.email%TYPE,
    p_college_name IN member.college_name%TYPE,
    p_ph_no IN member.ph_no%TYPE,
    p_team_id IN member.team_id%TYPE
) AS
BEGIN
    INSERT INTO Member (Member_Id, Member_Name, Email, College_Name, Ph_No, Team_Id)
    VALUES (
        (SELECT COALESCE(MAX(Member_Id), 0) + 1 FROM Member), -- Generate new Member_Id
        p_member_name, 
        p_email, 
        p_college_name, 
        p_ph_no, 
        p_team_id
    );
    
    UPDATE Team 
    SET MEMBER_COUNT = MEMBER_COUNT + 1 
    WHERE Team_Id = p_team_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Member inserted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END insert_member;
/
BEGIN
    --insert_member('Harsheen Kaur', 'harsheen@gmail.com', 'Thapar University', '8796541256', 1);
    insert_member('Asmita', 'asmita@gmail.com', 'Thapar University', '8996841206', 1);
    insert_member('Parth', 'parth@gmail.com', 'Thapar University', '9933308588', 2);
    insert_member('Rohit', 'rohit@gmail.com', 'Thapar University', '8446541446', 2);
END;
/
SELECT * FROM MEMBER;

    
CREATE OR REPLACE PROCEDURE update_extention_board_status (
    p_extention_board_no IN INT,
    p_team_id IN INT
) AS
BEGIN
    INSERT INTO extention_Board_Allocation VALUES(p_extention_board_no,p_team_id);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('extention board status updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END update_extention_board_status;
/
BEGIN
    --update_extention_board_status(1,1);
    update_extention_board_status(2,2);
END;
/
    
select * from extention_Board_Allocation;
CREATE OR REPLACE PROCEDURE check_in_member (
    p_member_id IN INT
) AS
    v_check_in_time TIMESTAMP;
    v_table_no INT;
    v_team_id INT;
BEGIN
    v_check_in_time := CURRENT_TIMESTAMP;
    
    INSERT INTO Check_InTime (Member_Id, Check_InTime)
    VALUES (p_member_id, v_check_in_time);
    
    SELECT Team_Id INTO v_team_id FROM Member WHERE Member_Id = p_member_id;
	BEGIN
        SELECT Table_no INTO v_table_no FROM Table_Allocation WHERE Team_Id = v_team_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_table_no := NULL; 
    END;    
    IF v_table_no IS NULL THEN
        insert into Table_Allocation (Team_Id) values(v_team_id);
        
        ELSE
            DBMS_OUTPUT.PUT_LINE('Table already Assigned to team.');
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Member checked in successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END check_in_member;
/

BEGIN
    --check_in_member(1);
    check_in_member(2);
    check_in_member(3);
    check_in_member(4);
END;
/

select * from check_intime;

CREATE OR REPLACE PROCEDURE update_submissions (
    p_team_id IN INT,
    p_presentation IN VARCHAR2,
    p_github_link IN VARCHAR2
) AS
BEGIN
    INSERT INTO Submissions (Team_Id, Presentation, Github_Link)
    VALUES (p_team_id, p_presentation, p_github_link);
	INSERT INTO final_scoresheets VALUES(p_team_id,0,0,0);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Submissions updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END update_submissions;
/

BEGIN
    --update_submissions(1, 'https://drive.google.com/ppt1', 'https://github.com/team_repo');
    update_submissions(2, 'https://drive.google.com/ppt2', 'https://github.com/our_repo');
END;
/
select * from submissions;


CREATE OR REPLACE PROCEDURE add_judges_scores (
    p_team_id IN INT,
     p_judge_id IN INT,
    p_scores IN INT
) AS
    v_final_score INT;
	v_judge_score INT;
BEGIN
    INSERT INTO judge_scores (Judge_id,Team_Id, Score)
    VALUES (p_judge_id,p_team_id, p_scores);
    commit;
        BEGIN
        INSERT INTO Final_Scoresheets (Team_Id, Mentor_Score, Judge_Score, Final_Score)
        VALUES (p_team_id, 0, 0, 0);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            NULL; -- do nothing, row already exists
    END;
	SELECT judge_score,final_score INTO v_judge_score,v_final_score
    FROM Final_scoresheets
    WHERE Team_Id = p_team_id;
    
    v_judge_score := v_judge_score + p_scores;
	v_final_score := v_final_score + p_scores;
    
    UPDATE Final_scoresheets
    SET judge_Score = v_judge_score,
        Final_Score = v_final_score
    WHERE Team_Id = p_team_id;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Final scores added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END add_judges_scores;
/

begin 
	--add_judges_scores(1,1,88);
    add_judges_scores(1,2,80);
    add_judges_scores(2,1,93);
    add_judges_scores(1,2,72);
end;
/

CREATE OR REPLACE PROCEDURE add_mentor_scores (
    p_mentor_id IN INT,
    p_team_id IN INT,
    p_team_score IN INT
) AS
    v_final_score INT;
    v_total_mentor_score INT;
BEGIN

    -- Insert individual mentor score (avoid duplicates by using MERGE or handle separately)
    INSERT INTO Mentor_scores (Mentor_Id, Team_Id, Team_Score)
    VALUES (p_mentor_id, p_team_id, p_team_score);
    commit;

    -- Sum all mentor scores for this team
    SELECT SUM(Team_Score)
    INTO v_total_mentor_score
    FROM Mentor_scores
    WHERE Team_Id = p_team_id;
    
        BEGIN
        INSERT INTO Final_Scoresheets (Team_Id, Mentor_Score, Judge_Score, Final_Score)
        VALUES (p_team_id, 0, 0, 0);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            NULL; -- do nothing, row already exists
    END;
    -- Get current final score
    SELECT Final_Score INTO v_final_score
    FROM Final_scoresheets
    WHERE Team_Id = p_team_id;

    -- Recalculate final score (mentor score + existing judge score)
    UPDATE Final_scoresheets
    SET Mentor_Score = v_total_mentor_score,
        Final_Score = (SELECT COALESCE(Judge_Score, 0) FROM Final_scoresheets WHERE Team_Id = p_team_id) + v_total_mentor_score
    WHERE Team_Id = p_team_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Mentor scores updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END add_mentor_scores;
/

begin
    --add_mentor_scores(1,1,20);
    --add_mentor_scores(2,1,40);
    add_mentor_scores(3,3,70);
    --add_mentor_scores(3,1,50);
end;
/


select * from judge_scores;
select * from mentor_scores;
select * from final_scoresheets;

select * from team;
select * from member;

--select * from mentors;
--select * from judges;


