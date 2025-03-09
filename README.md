# Student Success Data Analysis Pipeline

## Analysis Pipeline Point of Entry & Database
The point of entry is /script/aaPipeline.m

A non-normlized relational schema is needed to analyze this data; see data definitions below. The database is a single table with redundancy of information; the design was chosen simply because it made it easy for the Office of Intitutional Research to produce the report. If a normalized relation databse is desired, all stored procedures would have to be updated.

The relational database is accessed in WIndows via OLEDB using the .NET System.Data namespace. Access is designed for local trusted authentication, i.e. login and password are not required int he pipeline. Standard local configuration must be addressed to gurantee authentication. 

A folder called data must be added. Files there are ignored by .gitignore. It is used to store local copies of data files to increase the speed of report generation. 

## Git protocol

After you make your changes: 
```bash
git pull
git add .
git commit -m "[description of the change]"
git push
```
Follow this protocol to make changes to the repository. 

If you need to log into git, use: 
```bash
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
```
If you need to cancel a git add operation, use: 
```bash
git reset 
``` 
If you need to force a retrieval of files on the server and ovewrite local changes, use: 
```bash
git reset --hard HEAD
``` 

## Description of the data

The Comprehensive Academic Analysis Pipeline produces one volume for each college. All data will be anonymized and/or aggregated. Within each volume, there is a chapter for each department. The content of each report is as follows: 

1. Introduction
   1. Context statement provided by the Office of the Provost.
   2. Executive summary.
   3. Description of analysis methods
      1. Definitions
      2. Data source
      3. Statistical instruments used
2. Analysis 
   1. General statistics about the institution (to provide context for the analysis)
      1. Time series of enrollment for spring, summer and fall semesters
      2. Time series of admissions and graduations
      3. New and transfer students, first-generation and non-first-generation. 
      4. Time series of proportion of male vs. female students
      5. Time series of proportion of Pell recipients vs. no financial aid. 
      6. Admission vs. graduation data disaggregated by ethnicity
   2. Analysis – Determination of main contributors to student success
      1. Metric for identification and list
      2. Statistics about the Department of X, where X stands for the department administering the subject that has the highest contribution to student success.
         1. Distribution of graduates by ethnicity.
         2. Transfer students who completed the courses in the department prior to arrival. 
         3. The distribution of students and credit hours by subject matter for all students at all levels during the entire period studied. 
         4. Distribution of students and credit hours by subject matter for all students during their first year. 
         5. Distribution of drop, fail and withdrawal (DFW) by subject matter for all students during their first year. 
         6. Distribution of A, B and C grades by subject matter for all students during their first year. 
         7. Distributions of students in their first year who reach senior-level courses within five years. 
      3. Classroom size influence on student performance.
         1. Comparison of Department of X vs other departments in the same college. 
      4. Table of odds ratios sorted by students served, all subjects
      5. Donor and acceptor majors (Minard diagram, a.k.a Sankey). 
      6. Table of influence of subject exposure on changing majors for the top three subjects identified by the table of odd ratios. 
   3. College-level data. For each department: 
      1. Time series of enrollment for spring, summer and fall semesters
      2. Time series of admissions and graduations
      3. New and transfer students, first-generation and non-first-generation. 
      4. Time series of proportion of male vs. female students
      5. Time series of proportion of Pell recipients vs. no financial aid. 
      6. Admission vs. graduation data disaggregated by ethnicity
      7. Donors and acceptors for the department
      8. Time series of credit hours by course
      9. Credit hours by course by college of record (student registered in the same college)
      10. Credit hours by course by college of instruction (student registered in a different college)
      11. For each course subject (e.g. BIO):
         1. Bubble diagram of anonymized instructors by course level vs. DFW. Radius of each item is proportional to total students served. 
         2. Bubble diagram of students served vs. DFW. 
         3. Table of instructors ranked by DFW
         4. For each course in the subject (e.g. BIO101):
            1. Bubble diagram of each course showing all instructors who have taught it, by total number of students vs. DFW. Radius of each item is proportional to total students served.
3. Interpretation of results. Identification of critical areas in need of improvement and recommendations. 

# Student Data Structure

Student data is collected in two data tables as described in this section. The first table, called DATA, contains student, section, and instructor data.  

```bash
RACE
Race as of first term

ETHNICITY
Ethnicity as of first term

GENDER
Gender as of first term

FA_APPLIED
Did the student apply for financial aid their first academic year? 
(Applied, Did not apply)

AGI
Adjusted gross income as listed on the financial aid application the first academic year

PELLSTATUS
Did student receive a pell grant their first academic year? 
(Pell Paid, No Pell)

FIRSTGENERATIONSTATUS
First Generation means that neither of the students parents graduated college

ZIPCODE
First known zip code of the student

STUDENTTYPE
Entering Status (new or transfer)

FIRSTTERMCODE
Entering Term Code (YEAR.00 = Spring, YEAR.33=Summer, YEAR.66=Fall)
Academic Performance outside college

SAT_COMPOSITE
SAT Composite - New test (max)

SAT_MATH
SAT Math - New test (max)

SAT_ERW
SAT Evidence-Based  Reading and Writing - New test (max)

SAT_COMPOSITE_OLD
SAT Composite - Old test (max) - not converted

SAT_MATH_OLD
SAT Math - Old test (max) - not converted

SAT_VERBAL_OLD
SAT Verbal - Old test (max) - not converted

SAT_WRITING_OLD
SAT Writing - Old test (max) - not converted

SATOLD_WCR
SAT Verbal + Writing Score - Old test - not converted

SAT_COMPOSITE_CONVERTED
SAT Composite old score converted to new SAT Composite score

SAT_MATH_CONVERTED
SAT Math old score converted to new SAT Math score

SAT_WCR_CONVERTED
SAT Verbal + Writing old score converted to new SAT ERW score 
(please note that many students did not submit an old writing score; 
we cannot convert without this score)

ACT_COMPOSITE
ACT Composite (max)

ACT_MATH
ACT Math  (max)

ACT_ENG
ACT English (max)

ACT_READ
ACT Reading (max)

ACT_ER
ACT English + Reading

ACT_SCIREAS
ACT Science  (max)

ACT_WRITE
ACT Writing (max)

ACT_COMPOSITE_CONVERTED
ACT Composite converted to new SAT composite score

ACT_MATH_CONVERTED
ACT Math converted to new SAT Math score

ACT_ER_CONVERTED
ACT English + Reading converted to new SAT ERW score

HIGHEST_SATACT_COMPOSITE
Highest of new SAT, old SAT, or ACT composite scores

HIGHEST_SATACT_MATH
Highest of new SAT, old SAT, or ACT math scores

HIGHEST_SATACT_ERW
Highest of new SAT, old SAT, or ACT ERW scores

HIGHSCHOOLNAME
High school name

HIGHSCHOOLCITY
High school city

HIGHSCHOOLSTATE
High school state

HIGHSCHOOLZIP
High school zip code

COLALGEBRA_AP_GRDE
Grade/credit from AP test for College Algebra 
(Grade must be above a C)

COLALGEBRA_DUAL_GRDE
Grade/credit from dual credit course for College Algebra 
(Grade must be above a C)

COLALGEBRA_CLEP_GRDE
Grade/credit from CLEP test for College Algebra 
(Grade must be above a C)

PRECALCULUS_AP_GRDE
Grade/credit from AP test for Precalculus 
(Grade must be above a C)

PRECALCULUS_DUAL_GRDE
Grade/credit from dual credit course for Precalculus 
(Grade must be above a C)

PRECALCULUS_CLEP_GRDE
Grade/credit from CLEP test for Precalculus  
(Grade must be above a C)

CALCULUS1_AP_GRDE
Grade/credit from AP test for Calculus 1  (Grade must be above a C)

CALCULUS1_DUAL_GRDE
Grade/credit from dual credit course for Calculus 1  (Grade must be above a C)

CALCULUS1_CLEP_GRDE
Grade/credit from CLEP test for Calculus 2 (Grade must be above a C)

CALCULUS2_AP_GRDE
Grade/credit from AP test for Calculus 2  (Grade must be above a C)

CALCULUS2_DUAL_GRDE
Grade/credit from dual credit course for Calculus 2 (Grade must be above a C)

CALCULUS2_CLEP_GRDE
Grade/credit from CLEP test for Calculus 2  (Grade must be above a C)
Term Code Specific Information (Program of Study, College, Department and Courses)

CURRENTTERM
Current Semester

CURRENTTERMCODE
Current Term Code (YEAR.00 = Spring, YEAR.33=Summer, YEAR.66=Fall)

PROGRAM
Program as of Current Semester

COLLEGE
College as of Current Semester

DEPARTMENT
Department as of Current Semester

SHRTCKN_SUBJ_CODE
Subject Code

SUBJDESC
Course Subject

SUBJECT
Course Subject Description

SHRTCKN_SEQ_NUMB
Current Term Section Number

SHRTCKN_CRN
Current Term Section ID

SHRTCKN_CRSE_TITLE
Current Term Course Title

PRIMARY_INSTRUCTOR_ID
Current Term Faculty ID

PRIMARY_INSTRUCTOR_RACE-ETH
Current Term Faculty Race/Ethnicity

SHRTCKG_CREDIT_HOURS
Current Term Course Credit Hours

MIDTERM_GRADE
Current Term Course Midterm Grade 
(nulls indicate withdrawals or that course did not have midterm)

SHRTCKG_GRDE_CODE_FINAL
Current Term Course Grade

SHRGRDE_QUALITY_POINTS
Current Term Course Grade Points

SHRGRDE_GPA_IND
Current Term GPA Indicator (included in GPA  Y, not included = N)

SHRTCKN_REPEAT_COURSE_IND
Current Term Course Repeat indicator

STVSCHD_DESC
Current Term Course Type (face to face, internet, etc)

FIRSTGRADDATE
First Graduation Date 

FIRSTGRADPROGRAM
First Graduation Program

FIRSTGRADCOLLEGE
First Graduation College

FIRSTGRADDEPT
First Graduation Department
```

**Data Table**

The DDL definition for themain data table is as follows: 

```bash
CREATE TABLE DATA(
        IDENTIFIER varchar(6) NOT NULL,
        ETHNICITY varchar(41) NULL,
        GENDER varchar(6) NULL,
        FA_APPLIED varchar(25) NULL,
        AGI varchar(15) NULL,
        PELLSTATUS varchar(25) NULL,
        FIRSTGENERATIONSTATUS varchar(20) NULL,
        ZIPCODE varchar(20) NULL,
        STUDENTTYPE varchar(8) NULL,
        FIRSTTERMCODE float NULL,
        SAT_COMPOSITE float NULL,
        SAT_MATH float NULL,
        SAT_ERW float NULL,
        SAT_COMPOSITE_OLD float NULL,
        SAT_MATH_OLD float NULL,
        SAT_VERBAL_OLD float NULL,
        SAT_WRITING_OLD float NULL,
        SATOLD_WCR float NULL,
        SAT_COMPOSITE_CONVERTED float NULL,
        SAT_MATH_CONVERTED float NULL,
        SAT_WCR_CONVERTED float NULL,
        ACT_COMPOSITE float NULL,
        ACT_MATH float NULL,
        ACT_ENG float NULL,
        ACT_READ float NULL,
        ACT_ER float NULL,
        ACT_SCIREAS float NULL,
        ACT_WRITE float NULL,
        ACT_COMPOSITE_CONVERTED float NULL,
        ACT_MATH_CONVERTED float NULL,
        ACT_ER_CONVERTED float NULL,
        HIGHEST_SATACT_COMPOSITE float NULL,
        HIGHEST_SATACT_MATH float NULL,
        HIGHEST_SATACT_ERW float NULL,
        HIGHSCHOOLNAME varchar(100) NULL,
        HIGHSCHOOLCITY varchar(100) NULL,
        HIGHSCHOOLSTATE varchar(50) NULL,
        HIGHSCHOOLZIP varchar(20) NULL,
        COLALGEBRA_AP_GRDE varchar(2) NULL,
        COLALGEBRA_DUAL_GRDE varchar(2) NULL,
        COLALGEBRA_CLEP_GRDE varchar(2) NULL,
        PRECALCULUS_AP_GRDE varchar(2) NULL,
        PRECALCULUS_DUAL_GRDE varchar(2) NULL,
        PRECALCULUS_CLEP_GRDE varchar(2) NULL,
        CALCULUS1_AP_GRDE varchar(2) NULL,
        CALCULUS1_DUAL_GRDE varchar(2) NULL,
        CALCULUS1_CLEP_GRDE varchar(2) NULL,
        CALCULUS2_AP_GRDE varchar(2) NULL,
        CALCULUS2_DUAL_GRDE varchar(2) NULL,
        CALCULUS2_CLEP_GRDE varchar(2) NULL,
        CURRENTTERM varchar(50) NULL,
        CURRENTTERMCODE float NULL,
        PROGRAM varchar(100) NULL,
        COLLEGE varchar(50) NULL,
        DEPARTMENT varchar(50) NULL,
        SHRTCKN_SUBJ_CODE varchar(4) NULL,
        CT_SUBJDESC varchar(50) NULL,
        CT_SUBJECT char(4) NULL,
        SHRTCKN_SEQ_NUMB varchar(3) NULL,
        SHRTCKN_CRN int NULL,
        SHRTCKN_CRSE_TITLE varchar(50) NULL,
        PRIMARY_INSTRUCTOR_ID varchar(9) NULL,
        PRIMARY_INSTRUCTOR_RACE-ETH varchar(50) NULL,
        SHRTCKG_CREDIT_HOURS tinyint NULL,
        MIDTERM_GRADE varchar(3) NULL,
        SHRTCKG_GRDE_CODE_FINAL varchar(2) NULL,
        SHRGRDE_QUALITY_POINTS float NULL,
        SHRTCKN_REPEAT_COURSE_IND char(1) NULL,
        STVSCHD_DESC varchar(30) NULL,
        FIRSTGRADDATE datetime2(7) NULL,
        FIRSTGRADPROGRAM varchar(75) NULL,
        FIRSTGRADCOLLEGE varchar(40) NULL,
        FIRSTGRADDEPT varchar(50) NULL
)
```

**Departmental Table**

The departmental table contains information about the cross reference between departments, subjects, and colleges. The DDL definition is: 

```bash
CREATE TABLE DEPT(
        SUBJECT varchar(4) NOT NULL,
        COLLEGE varchar(50) NOT NULL,
        DEPARTMENT varchar(50) NOT NULL
)
```
