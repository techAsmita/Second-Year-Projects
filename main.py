import new
from flask import Flask, render_template,redirect, url_for
from flask import request

app = Flask(__name__)




@app.route('/')
def index():
    return render_template('index.html')

@app.route('/teams')
def teams():
    teamsdata = new.get_teams()
    teamsdata.sort(key=lambda x: x[0])
    return render_template('teams.html', teams=teamsdata)

@app.route('/members')
def members():
    memberdata = new.get_members()
    return render_template('members.html', members = memberdata)

@app.route('/mentor_judges')
def mentor_judges():
    mentors = new.get_mentors()
    judges = new.get_judges()
    return render_template('mentor_judges.html', mentors = mentors, judges = judges)

@app.route('/mentorScoring')
def mentorScoring():
    mentorScoringdata = new.get_mentor_scoring()
    print(mentorScoringdata)
    return render_template('mentorScoring.html', mentor_scores = mentorScoringdata)

@app.route('/judgeScoring')
def judgeScoring():
    judge_score_data = new.get_judge_scoring()
    return render_template('judgesScoring.html', judge_scores = judge_score_data)

@app.route('/finalScores')
def final_scores_page():
    final_scores = new.get_final_scores()
    return render_template('finalScoresheet.html', final_scores = final_scores)

@app.route('/checkin')
def checkin():
    checkin = new.get_checkin()
    return render_template('checkin.html', checkin = checkin)

@app.route('/teamSubmission', methods=['GET', 'POST'])
def team_submissions_page():
    if request.method == 'POST':
        team_id = request.form['team_id']
        ppt = request.form['presentation']
        github = request.form['github_link']

        # Make sure you convert ID to int if needed
        new.put_submissions(int(team_id), ppt, github)
    submissiondata = new.get_team_submission()
    return render_template('submissions.html', submissions = submissiondata)

@app.route('/extensions')
def extensions_page():
    ext = new.get_extensions()
    tab = new.get_tables()
    print(ext, tab)
    return render_template('extensions.html', extension_data = ext, table_data = tab)



@app.route('/add_member', methods=['POST'])
def add_member():
    if request.method == 'POST':
        team_id = request.form['team_id']
        member_name = request.form['member_name']
        email = request.form['email']
        college_name = request.form['college_name']
        phone = request.form['phone']
        new.put_member( member_name,email , college_name, phone, team_id)
        return redirect(url_for('members'))

@app.route('/add_team', methods=['POST'])
def add_team():
    team_name=request.form['team_name']
    new.put_team(team_name)
    return redirect(url_for('teams'))


@app.route('/checkin', methods=['POST'])
def checkin_put():
    member_id=request.form['member_id']
    new.put_checkin(member_id)
    return redirect(url_for('members'))

@app.route('/add_mentor_scores', methods=['POST'])
def add_mentor_scores():
    mentor_id=request.form['mentor_id']
    team_id=request.form['team_id']
    team_score=request.form['score']
    new.put_mentor_scoring(mentor_id,team_id,team_score)
    return redirect(url_for('mentorScoring'))

@app.route('/add_judge_scores', methods=['POST'])
def add_judge_scores():
    judge_id=request.form['judge_id']
    team_id=request.form['team_id']
    team_score=request.form['score']
    new.put_judge_scoring(team_id,judge_id,team_score)
    return redirect(url_for('judgeScoring'))


if __name__ == "__main__":
    app.run(debug=True, port=8080)
