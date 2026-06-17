# 🎓 Second Year Projects — Asmita Roy

A collection of projects built during my second year of Computer Engineering at Thapar Institute of Engineering & Technology, spanning full-stack web development, database design, and NLP with transformers.

---

## 📁 Projects

### 1. 🏆 Hackathon Management System
> A full-stack web application to manage hackathon operations end-to-end — from team registration to final scoresheets.

### 2. 🧠 Sexism Detection using Fine-tuned BERT
> A text classification system that detects sexist language in English sentences using a fine-tuned BERT model.

---

## 🏆 Project 1: Hackathon Management System

### Overview
A Flask-based web application backed by an Oracle XE database that handles the complete lifecycle of a hackathon — team and member registration, check-ins, physical resource allocation, mentor/judge scoring, submission tracking, and final score aggregation.

### Features
- **Team & Member Management** — register teams and members across colleges; member count auto-updates via stored procedures
- **Check-in System** — timestamp-based member check-in with automatic table allocation on first check-in
- **Resource Allocation** — table and extension board assignment per team
- **Dual Scoring** — separate mentor and judge scoring flows; scores aggregated into a final scoresheet in real time
- **Submission Tracking** — teams submit PPT links and GitHub repository URLs via a POST form
- **Mentor & Judge Directory** — dedicated views for all mentors and judges

### Tech Stack

| Layer | Technology |
|---|---|
| Backend | Python, Flask |
| Database | Oracle XE (via cx_Oracle) |
| DB Layer | Stored Procedures (PL/SQL), Sequences |
| Frontend | HTML/Jinja2 templates (10 pages) |
| Config | python-dotenv (.env for DB credentials) |

### Database Schema
12 tables with full relational integrity:

`TEAM` → `MEMBER` → `CHECK_INTIME`  
`TEAM` → `TABLE_ALLOCATION` (auto-assigned on check-in via sequence)  
`TEAM` → `EXTENTION_BOARD_ALLOCATION`  
`MENTORS` → `MENTOR_SCORES` → `FINAL_SCORESHEETS`  
`JUDGES` → `JUDGE_SCORES` → `FINAL_SCORESHEETS`  
`TEAM` → `SUBMISSIONS`

### Stored Procedures (PL/SQL)
- `insert_team` — auto-increments TEAM_ID and inserts
- `insert_member` — inserts member and updates team's member count
- `check_in_member` — records timestamp and auto-allocates a table if not already assigned
- `update_submissions` — records PPT + GitHub link and initialises scoresheet row
- `add_mentor_scores` — inserts score and recalculates cumulative mentor + final score
- `add_judges_scores` — inserts score and updates judge + final score on the scoresheet

### Project Structure
```
main.py              # Flask routes (11 GET + POST endpoints)
new.py               # Oracle DB layer (execute_sql_query / execute_sql_statement)
creation.sql         # Full schema: CREATE TABLE, sequences, stored procedures, seed data
templates/           # 10 Jinja2 HTML templates
  ├── index.html
  ├── teams.html
  ├── members.html
  ├── mentor_judges.html
  ├── mentorScoring.html
  ├── judgesScoring.html
  ├── finalScoresheet.html
  ├── checkin.html
  ├── submissions.html
  └── extensions.html
requirements.txt     # cx_Oracle, flask, flask-cors, python-dotenv
```

### Setup & Run
```bash
# Install dependencies
pip install -r requirements.txt

# Add a .env file with your Oracle credentials
DB_USER=your_username
DB_PASSWORD=your_password

# Run Oracle XE locally on port 1521 with service name XEPDB1
# Then initialise the schema
sqlplus your_username/your_password@XEPDB1 @creation.sql

# Start the Flask app
python main.py
# Runs at http://localhost:8080
```

---

## 🧠 Project 2: Sexism Detection using Fine-tuned BERT

### Overview
A text classification project that fine-tunes `bert-base-uncased` to detect sexist language in English sentences. Trained on the HuggingFace `lidiapierre/fr_sexism_labelled` dataset using the Trainer API with memory-optimized settings for Google Colab.

### Features
- Fine-tunes `bert-base-uncased` for binary sequence classification (Sexist / Not Sexist)
- Memory-optimized training: FP16 mixed precision, gradient accumulation (4 steps), gradient checkpointing
- Custom `compute_metrics` — accuracy, F1, precision, recall (supports binary and macro averaging)
- Batch inference via `predict_sexism()` with device-aware tensor placement
- HuggingFace `pipeline` integration for clean one-line inference
- Model persisted to Google Drive and exportable as `.zip`

### Tech Stack

| Component | Tool |
|---|---|
| Model | `bert-base-uncased` (HuggingFace) |
| Dataset | `lidiapierre/fr_sexism_labelled` |
| Training | HuggingFace `Trainer` API |
| Metrics | scikit-learn (accuracy, F1, precision, recall) |
| Environment | Google Colab (GPU) |
| Storage | Google Drive |

### Training Configuration

| Parameter | Value |
|---|---|
| Learning Rate | 2e-5 |
| Epochs | 4 |
| Batch Size | 8 |
| Gradient Accumulation Steps | 4 |
| Mixed Precision | FP16 |
| Best Model Metric | Accuracy |
| Max Sequence Length | 128 |

### Sample Predictions
```python
clf_pipeline("She is a terrible leader.")
# → Sexist

clf_pipeline("Everyone deserves equal opportunities regardless of gender.")
# → Not Sexist

clf_pipeline("She can't be a doctor, she should be a nurse.")
# → Sexist

clf_pipeline("Anyone can be a doctor.")
# → Not Sexist
```

### How to Run
1. Open `AI project_Asmita.ipynb` in Google Colab
2. Run all cells in order — dataset loading, tokenization, training, and inference are fully end-to-end
3. The trained model saves to `AI_Project/SexismDetection/model/` on your Google Drive

---

## 👩‍💻 Author

**Asmita Roy**  
Computer Engineering (2023–2027), Thapar Institute of Engineering & Technology, Patiala  
[GitHub](https://github.com/techAsmita) • [LinkedIn](https://linkedin.com/in/techasmita) • asmitaasmani@gmail.com
