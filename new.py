import cx_Oracle
import dotenv

username = dotenv.get_key('.env', 'DB_USER')
password = dotenv.get_key('.env', 'DB_PASSWORD')
dsn = cx_Oracle.makedsn("localhost", 1521, service_name="XEPDB1")
connection = cx_Oracle.connect(user=username, password=password, dsn=dsn, encoding="UTF-8")




def disconnect_from_database(connection):
    """Closes the connection to the Oracle database."""
    connection.close()

def execute_sql_query( query):
    connection = cx_Oracle.connect(user=username, password=password, dsn=dsn)

    """Executes an SQL query and returns the result."""
    cursor = connection.cursor()
    print(query)
    cursor.execute(query)
    rows = cursor.fetchall()
    cursor.close()
    disconnect_from_database(connection)
    return rows

def execute_sql_statement( statement):
    connection = cx_Oracle.connect(user=username, password=password, dsn=dsn)

    """Executes an SQL statement."""
    print(statement)
    cursor = connection.cursor()
    cursor.execute(statement)
    connection.commit()
    cursor.close()
    disconnect_from_database(connection)

def get_teams():
    """Retrieves all teams from the database."""
    query = "SELECT * FROM TEAM"
    teams = execute_sql_query( query)
    return teams

def get_members():
    """Retrieves all members from the database."""
    query = "SELECT * FROM MEMBER"
    members = execute_sql_query( query)
    return members

def get_mentor_scoring():
    """Retrieves mentor scoring data from the database."""
    query = "SELECT * FROM MENTOR_SCORES"
    mentor_scores = execute_sql_query( query)
    return mentor_scores

def get_judge_scoring():
    """Retrieves judge scoring data from the database."""
    query = "SELECT * FROM JUDGE_SCORES"
    judge_scores = execute_sql_query( query)
    return judge_scores

def get_final_scores():
    """Retrieves final scores from the database."""
    query = "SELECT * FROM FINAL_SCORESHEETS"
    final_scores = execute_sql_query( query)
    return final_scores

def get_team_submission():
    """Retrieves team submissions from the database."""
    query = "SELECT * FROM SUBMISSIONS"
    submissions = execute_sql_query( query)
    return submissions

def get_extensions():
    """Retrieves extension board allocations from the database."""
    query = "SELECT * FROM EXTENTION_BOARD_ALLOCATION"
    extensions = execute_sql_query( query)
    return extensions

def get_tables():
    """Retrieves table data from the database."""
    query = "SELECT * FROM table_allocation"
    tables = execute_sql_query( query)
    print(tables)
    return tables

def get_checkin():
    """Retrieves check-in data from the database."""
    query = "SELECT * FROM CHECK_INTIME"
    checkin = execute_sql_query( query)
    return checkin

def get_mentors():
    """Retrieves mentors from the database."""
    query = "SELECT * FROM MENTORS"
    mentors = execute_sql_query( query)
    return mentors

def get_judges():
    """Retrieves judges from the database."""
    query = "SELECT * FROM JUDGES"
    judges = execute_sql_query( query)
    return judges

def put_team(team_name):
    """Inserts a new team into the database."""
    print(team_name)
    statement = f"""
        BEGIN
            INSERT_TEAM('{team_name}');
        END;
    """
    execute_sql_statement( statement)

def put_member(member_name, email, college_name, ph_no, team_id):
    """Inserts a new member into the database."""
    statement = f"""
    
        BEGIN
            insert_member('{member_name}', '{email}', '{college_name}', '{ph_no}', {team_id});
        END;
    
    """
    execute_sql_statement( statement)
    # disconnect_from_database()

def put_mentor(mentor_id, mentor_name, mentor_ph):
    """Inserts a new mentor into the database."""
    statement = f"INSERT INTO MENTORS VALUES ({mentor_id}, '{mentor_name}', '{mentor_ph}')"
    execute_sql_statement( statement)

def put_judge(judge_id, judge_name):
    """Inserts a new judge into the database."""
    statement = f"INSERT INTO JUDGES (Judge_Id, Judge_Name) VALUES ({judge_id}, '{judge_name}')"
    execute_sql_statement( statement)

def put_checkin(member_id):
    """Inserts a check-in record for a member into the database."""
    statement = f"""
    
        BEGIN
            check_in_member({member_id});
        END;
    
    """
    execute_sql_statement( statement)

def put_extension(extention_board_no, team_id):
    """Inserts an extension board allocation into the database."""

    statement = f"INSERT INTO extention_Board_Allocation VALUES({extention_board_no},{team_id});"

    execute_sql_statement( statement)

def put_mentor_scoring(mentor_id, team_id, team_score):
    """Inserts mentor scoring data into the database."""
    statement = f"""
    
        BEGIN
            add_mentor_scores({mentor_id},{team_id},{team_score});
        END;
    
    """
    execute_sql_statement( statement)

def put_judge_scoring(team_id, judge_id, score):
    """Inserts judge scoring data into the database."""
    statement = f"""
    
        BEGIN 
            add_judges_scores({team_id},{judge_id},{score});
        END;
    
    """
    execute_sql_statement( statement)
    # disconnect_from_database()

def put_submissions(teamid,ppt,github):
    statement = f"""
    
        BEGIN
            update_submissions({teamid}, '{ppt}', '{github}');
        END;
    
    """
    execute_sql_statement( statement)
    # disconnect_from_database()


