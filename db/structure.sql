--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: action_plan_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE action_plan_entries (
    id integer NOT NULL,
    user_id integer NOT NULL,
    cohort_id integer NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    started_on date,
    due_on date,
    completed_on date,
    learning_experience_id integer,
    status integer DEFAULT 0 NOT NULL
);


--
-- Name: action_plan_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE action_plan_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: action_plan_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE action_plan_entries_id_seq OWNED BY action_plan_entries.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answers (
    id integer NOT NULL,
    taken_assessment_id integer NOT NULL,
    question_id character varying(255) NOT NULL,
    response text,
    score integer,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: assessments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assessments (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    time_allowed_in_minutes integer,
    markdown text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    css text
);


--
-- Name: assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assessments_id_seq OWNED BY assessments.id;


--
-- Name: assigned_learning_experiences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assigned_learning_experiences (
    id integer NOT NULL,
    learning_experience_id integer NOT NULL,
    cohort_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: assigned_learning_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assigned_learning_experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assigned_learning_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assigned_learning_experiences_id_seq OWNED BY assigned_learning_experiences.id;


--
-- Name: assignment_submission_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_submission_notes (
    id integer NOT NULL,
    assignment_submission_id integer NOT NULL,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: assignment_submission_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_submission_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_submission_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_submission_notes_id_seq OWNED BY assignment_submission_notes.id;


--
-- Name: assignment_submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_submissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    assignment_id integer NOT NULL,
    submission_url character varying(255),
    complete boolean DEFAULT false,
    submitted boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    time_spent integer
);


--
-- Name: assignment_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_submissions_id_seq OWNED BY assignment_submissions.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignments (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    due_date timestamp without time zone NOT NULL,
    url character varying(255),
    cohort_id integer NOT NULL
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: campuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE campuses (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    google_maps_location text NOT NULL,
    directions text NOT NULL
);


--
-- Name: campuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE campuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE campuses_id_seq OWNED BY campuses.id;


--
-- Name: challenges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE challenges (
    id integer NOT NULL,
    directory_name character varying(255) NOT NULL,
    github_url character varying(255) NOT NULL,
    cohort_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: challenges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE challenges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: challenges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE challenges_id_seq OWNED BY challenges.id;


--
-- Name: class_project_features; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE class_project_features (
    id integer NOT NULL,
    class_project_id integer NOT NULL,
    category integer DEFAULT 0 NOT NULL,
    name character varying(255) NOT NULL,
    "position" integer NOT NULL,
    stories text,
    wireframes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: class_project_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE class_project_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: class_project_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE class_project_features_id_seq OWNED BY class_project_features.id;


--
-- Name: class_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE class_projects (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255) NOT NULL
);


--
-- Name: class_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE class_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: class_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE class_projects_id_seq OWNED BY class_projects.id;


--
-- Name: cohort_epics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cohort_epics (
    id integer NOT NULL,
    epic_id integer NOT NULL,
    cohort_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cohort_epics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cohort_epics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cohort_epics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cohort_epics_id_seq OWNED BY cohort_epics.id;


--
-- Name: cohort_exercises; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cohort_exercises (
    id integer NOT NULL,
    exercise_id integer,
    cohort_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cohort_exercises_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cohort_exercises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cohort_exercises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cohort_exercises_id_seq OWNED BY cohort_exercises.id;


--
-- Name: cohorts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cohorts (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    start_date date NOT NULL,
    end_date date NOT NULL,
    hero character varying(255),
    showcase boolean DEFAULT false NOT NULL,
    curriculum_id integer,
    show_employment_ribbon boolean DEFAULT false NOT NULL,
    calendar_url character varying(1000),
    prereqs text,
    greenhouse_job_id bigint,
    campus_id integer NOT NULL,
    announced boolean DEFAULT false NOT NULL,
    showcase_position integer DEFAULT 0 NOT NULL,
    daily_feedback_url character varying(255),
    weekly_feedback_url character varying(255),
    course_id integer NOT NULL,
    label character varying(255)
);


--
-- Name: cohorts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cohorts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cohorts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cohorts_id_seq OWNED BY cohorts.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE courses (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: curriculum_notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE curriculum_notifications (
    id integer NOT NULL,
    user_id integer,
    resource_type character varying(255),
    resource_id integer,
    resource_name character varying(1000) NOT NULL,
    status integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    curriculum_id integer
);


--
-- Name: curriculum_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE curriculum_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: curriculum_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE curriculum_notifications_id_seq OWNED BY curriculum_notifications.id;


--
-- Name: curriculums; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE curriculums (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    version character varying(255) NOT NULL
);


--
-- Name: curriculums_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE curriculums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: curriculums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE curriculums_id_seq OWNED BY curriculums.id;


--
-- Name: daily_plans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE daily_plans (
    id integer NOT NULL,
    cohort_id integer NOT NULL,
    date date NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: daily_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE daily_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: daily_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE daily_plans_id_seq OWNED BY daily_plans.id;


--
-- Name: deadlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE deadlines (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    due_date timestamp without time zone NOT NULL,
    url character varying(255),
    cohort_id integer NOT NULL
);


--
-- Name: deadlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deadlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deadlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deadlines_id_seq OWNED BY deadlines.id;


--
-- Name: employment_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employment_profiles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    status integer NOT NULL,
    looking_for text,
    strengths text,
    preferred_locations text,
    show_email boolean DEFAULT false NOT NULL,
    remote_work boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    bio text,
    headline character varying(255)
);


--
-- Name: employment_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employment_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employment_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employment_profiles_id_seq OWNED BY employment_profiles.id;


--
-- Name: employments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    company_name character varying(255) NOT NULL,
    city character varying(255),
    company_type character varying(255),
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    company_url character varying(255),
    public_description character varying(255),
    date_placed date,
    yearly_salary integer
);


--
-- Name: employments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employments_id_seq OWNED BY employments.id;


--
-- Name: enrollments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE enrollments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    cohort_id integer NOT NULL,
    role integer NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: enrollments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE enrollments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: enrollments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE enrollments_id_seq OWNED BY enrollments.id;


--
-- Name: epics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE epics (
    id integer NOT NULL,
    class_project_id integer NOT NULL,
    category integer DEFAULT 0 NOT NULL,
    name character varying(255) NOT NULL,
    "position" integer NOT NULL,
    stories text,
    wireframes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    label character varying(255)
);


--
-- Name: epics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE epics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: epics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE epics_id_seq OWNED BY epics.id;


--
-- Name: exercise_objectives; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE exercise_objectives (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    exercise_id integer,
    objective_id integer
);


--
-- Name: exercise_objectives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE exercise_objectives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exercise_objectives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE exercise_objectives_id_seq OWNED BY exercise_objectives.id;


--
-- Name: exercises; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE exercises (
    id integer NOT NULL,
    name character varying(255),
    github_repo character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    response_type integer DEFAULT 0,
    curriculum_id integer NOT NULL
);


--
-- Name: exercises_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE exercises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exercises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE exercises_id_seq OWNED BY exercises.id;


--
-- Name: expectation_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE expectation_statuses (
    id integer NOT NULL,
    user_id integer NOT NULL,
    cohort_id integer NOT NULL,
    expectation_id integer NOT NULL,
    author_id integer NOT NULL,
    notes text NOT NULL,
    status integer NOT NULL,
    on_track boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: expectation_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE expectation_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expectation_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE expectation_statuses_id_seq OWNED BY expectation_statuses.id;


--
-- Name: expectations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE expectations (
    id integer NOT NULL,
    course_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    "position" integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: expectations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE expectations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expectations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE expectations_id_seq OWNED BY expectations.id;


--
-- Name: experience_objectives; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE experience_objectives (
    id integer NOT NULL,
    learning_experience_id integer NOT NULL,
    objective_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: experience_objectives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE experience_objectives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: experience_objectives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE experience_objectives_id_seq OWNED BY experience_objectives.id;


--
-- Name: given_assessments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE given_assessments (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    time_allowed_in_minutes integer NOT NULL,
    markdown text NOT NULL,
    given_on date NOT NULL,
    cohort_id integer NOT NULL,
    assessment_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    css text
);


--
-- Name: given_assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE given_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: given_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE given_assessments_id_seq OWNED BY given_assessments.id;


--
-- Name: greenhouse_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE greenhouse_applications (
    id integer NOT NULL,
    cohort_id integer NOT NULL,
    application_json json NOT NULL,
    candidate_json json NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: greenhouse_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE greenhouse_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: greenhouse_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE greenhouse_applications_id_seq OWNED BY greenhouse_applications.id;


--
-- Name: job_activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE job_activities (
    id integer NOT NULL,
    user_id integer NOT NULL,
    company character varying(255) NOT NULL,
    "position" character varying(255),
    status character varying(255),
    date_of_last_interaction date,
    job_source character varying(255),
    url character varying(1000),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: job_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE job_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE job_activities_id_seq OWNED BY job_activities.id;


--
-- Name: learning_experiences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE learning_experiences (
    id integer NOT NULL,
    curriculum_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    "position" integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    instructor_notes text,
    mainline boolean DEFAULT true NOT NULL,
    suggested_days numeric,
    subject_id integer,
    section character varying(255),
    github_repo character varying(255)
);


--
-- Name: learning_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE learning_experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: learning_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE learning_experiences_id_seq OWNED BY learning_experiences.id;


--
-- Name: lesson_plans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lesson_plans (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    objectives text,
    assessment text,
    activity text,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lesson_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lesson_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lesson_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lesson_plans_id_seq OWNED BY lesson_plans.id;


--
-- Name: lessons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lessons (
    id integer NOT NULL,
    cohort_id integer,
    lesson_plan_id integer,
    date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lessons_id_seq OWNED BY lessons.id;


--
-- Name: mentors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mentors (
    id integer NOT NULL,
    user_id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    company_name character varying(255),
    mentor_id integer,
    status integer NOT NULL
);


--
-- Name: mentors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mentors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mentors_id_seq OWNED BY mentors.id;


--
-- Name: mentorships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mentorships (
    id integer NOT NULL,
    user_id integer NOT NULL,
    mentor_id integer NOT NULL,
    status integer NOT NULL,
    company_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: mentorships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mentorships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentorships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mentorships_id_seq OWNED BY mentorships.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notes (
    id integer NOT NULL,
    contents text,
    user_id integer NOT NULL,
    learning_experience_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: objectives; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE objectives (
    id integer NOT NULL,
    name character varying(1000) NOT NULL,
    standard_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description text,
    guiding_questions text,
    resources text,
    "position" integer NOT NULL,
    instructor_notes text
);


--
-- Name: objectives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE objectives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: objectives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE objectives_id_seq OWNED BY objectives.id;


--
-- Name: pair_rotations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pair_rotations (
    id integer NOT NULL,
    cohort_id integer NOT NULL,
    happened_on date,
    pairs json NOT NULL,
    "position" integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: pair_rotations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pair_rotations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pair_rotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pair_rotations_id_seq OWNED BY pair_rotations.id;


--
-- Name: pairings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pairings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    pair_id integer NOT NULL,
    feedback text NOT NULL,
    paired_on date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pairings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pairings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pairings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pairings_id_seq OWNED BY pairings.id;


--
-- Name: performances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE performances (
    id integer NOT NULL,
    user_id integer NOT NULL,
    objective_id integer NOT NULL,
    updator_id integer NOT NULL,
    score integer,
    history json,
    comments json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    assessing_question_answers json
);


--
-- Name: performances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE performances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: performances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE performances_id_seq OWNED BY performances.id;


--
-- Name: planned_lessons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE planned_lessons (
    id integer NOT NULL,
    curriculum_unit_id integer NOT NULL,
    lesson_plan_id integer NOT NULL,
    "position" integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: planned_lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE planned_lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: planned_lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE planned_lessons_id_seq OWNED BY planned_lessons.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    objective_id integer,
    question_type character varying(255),
    question character varying(255),
    answers text[] DEFAULT '{}'::text[],
    correct_answer character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: snippets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE snippets (
    id integer NOT NULL,
    cohort_id integer,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: snippets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE snippets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snippets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE snippets_id_seq OWNED BY snippets.id;


--
-- Name: staffings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE staffings (
    id integer NOT NULL,
    cohort_id integer NOT NULL,
    user_id integer NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: staffings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE staffings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: staffings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE staffings_id_seq OWNED BY staffings.id;


--
-- Name: standards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE standards (
    id integer NOT NULL,
    name character varying(1000) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    curriculum_id integer,
    tags json,
    resources text,
    guiding_questions text,
    description text,
    "position" integer NOT NULL,
    instructor_notes text,
    subject_id integer
);


--
-- Name: standards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE standards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: standards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE standards_id_seq OWNED BY standards.id;


--
-- Name: stories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stories (
    id integer NOT NULL,
    epic_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    "position" integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255),
    story_type character varying(255) DEFAULT 'feature'::character varying NOT NULL
);


--
-- Name: stories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stories_id_seq OWNED BY stories.id;


--
-- Name: student_challenges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE student_challenges (
    id integer NOT NULL,
    challenge_id integer NOT NULL,
    file character varying(255) NOT NULL,
    user_id integer NOT NULL,
    passed integer DEFAULT 0 NOT NULL,
    failed integer DEFAULT 0 NOT NULL,
    submission_count integer DEFAULT 1 NOT NULL,
    complete boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: student_challenges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_challenges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_challenges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_challenges_id_seq OWNED BY student_challenges.id;


--
-- Name: student_deadlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE student_deadlines (
    id integer NOT NULL,
    user_id integer NOT NULL,
    deadline_id integer NOT NULL,
    complete boolean DEFAULT false NOT NULL
);


--
-- Name: student_deadlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_deadlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_deadlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_deadlines_id_seq OWNED BY student_deadlines.id;


--
-- Name: student_projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE student_projects (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    github_url character varying(255),
    tracker_url character varying(255),
    production_url character varying(255),
    screenshot character varying(255),
    technical_notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    class_project_id integer,
    travis_badge_markdown text,
    code_climate_badge_markdown text,
    visibility integer DEFAULT 0 NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


--
-- Name: student_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_projects_id_seq OWNED BY student_projects.id;


--
-- Name: student_snippets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE student_snippets (
    id integer NOT NULL,
    snippet_id integer,
    body text,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: student_snippets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_snippets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_snippets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_snippets_id_seq OWNED BY student_snippets.id;


--
-- Name: student_stories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE student_stories (
    id integer NOT NULL,
    class_project_id integer NOT NULL,
    epic_id integer NOT NULL,
    story_id integer NOT NULL,
    user_id integer NOT NULL,
    current_state character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    pivotal_tracker_id bigint NOT NULL,
    last_response_json json
);


--
-- Name: student_stories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_stories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_stories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_stories_id_seq OWNED BY student_stories.id;


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subjects (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(255),
    curriculum_id integer,
    "position" integer
);


--
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subjects_id_seq OWNED BY subjects.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE submissions (
    id integer NOT NULL,
    user_id integer,
    exercise_id integer,
    github_repo_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tracker_project_url character varying(255),
    feedback json,
    feedback_given boolean DEFAULT false,
    contents text
);


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submissions_id_seq OWNED BY submissions.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    tagger_id integer,
    tagger_type character varying(255),
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255),
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: taken_assessments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taken_assessments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    given_assessment_id integer NOT NULL,
    status integer NOT NULL,
    ended_at timestamp without time zone,
    focus_history json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: taken_assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taken_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taken_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taken_assessments_id_seq OWNED BY taken_assessments.id;


--
-- Name: tracker_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tracker_statuses (
    id integer NOT NULL,
    user_id integer NOT NULL,
    delivered integer DEFAULT 0 NOT NULL,
    accepted integer DEFAULT 0 NOT NULL,
    rejected integer DEFAULT 0 NOT NULL,
    started integer DEFAULT 0 NOT NULL,
    finished integer DEFAULT 0 NOT NULL,
    unstarted integer DEFAULT 0 NOT NULL,
    unscheduled integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    class_project_id integer NOT NULL,
    total_rejections integer,
    total_stories integer,
    stories_with_rejections integer,
    total_started_stories integer,
    total_started_bugs integer,
    activities json,
    activity_summary json
);


--
-- Name: tracker_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tracker_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tracker_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tracker_statuses_id_seq OWNED BY tracker_statuses.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    github_username character varying(255),
    github_id character varying(255),
    role integer DEFAULT 0,
    phone character varying(255),
    twitter character varying(255),
    blog character varying(255),
    address_1 character varying(255),
    address_2 character varying(255),
    city character varying(255),
    state character varying(255),
    zip_code character varying(255),
    linkedin character varying(255),
    avatar character varying(255),
    shirt_size character varying(255),
    status integer DEFAULT 0 NOT NULL,
    greenhouse_candidate_id bigint,
    pivotal_tracker_token character varying(255),
    auth_token character varying(255) NOT NULL,
    password_digest character varying(255),
    galvanize_id integer
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE videos (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    vimeo_id bigint NOT NULL
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE videos_id_seq OWNED BY videos.id;


--
-- Name: writeup_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE writeup_comments (
    id integer NOT NULL,
    writeup_id integer NOT NULL,
    user_id integer NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: writeup_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE writeup_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: writeup_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE writeup_comments_id_seq OWNED BY writeup_comments.id;


--
-- Name: writeup_topics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE writeup_topics (
    id integer NOT NULL,
    cohort_id integer NOT NULL,
    subject character varying(255) NOT NULL,
    description text,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: writeup_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE writeup_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: writeup_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE writeup_topics_id_seq OWNED BY writeup_topics.id;


--
-- Name: writeups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE writeups (
    id integer NOT NULL,
    writeup_topic_id integer NOT NULL,
    user_id integer NOT NULL,
    response text NOT NULL,
    read boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    score integer
);


--
-- Name: writeups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE writeups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: writeups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE writeups_id_seq OWNED BY writeups.id;


--
-- Name: zpd_responses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE zpd_responses (
    id integer NOT NULL,
    user_id integer NOT NULL,
    response integer NOT NULL,
    date date NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    resource_id integer,
    resource_type character varying(255)
);


--
-- Name: zpd_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE zpd_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zpd_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE zpd_responses_id_seq OWNED BY zpd_responses.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY action_plan_entries ALTER COLUMN id SET DEFAULT nextval('action_plan_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assessments ALTER COLUMN id SET DEFAULT nextval('assessments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assigned_learning_experiences ALTER COLUMN id SET DEFAULT nextval('assigned_learning_experiences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_submission_notes ALTER COLUMN id SET DEFAULT nextval('assignment_submission_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_submissions ALTER COLUMN id SET DEFAULT nextval('assignment_submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY campuses ALTER COLUMN id SET DEFAULT nextval('campuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY challenges ALTER COLUMN id SET DEFAULT nextval('challenges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY class_project_features ALTER COLUMN id SET DEFAULT nextval('class_project_features_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY class_projects ALTER COLUMN id SET DEFAULT nextval('class_projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohort_epics ALTER COLUMN id SET DEFAULT nextval('cohort_epics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohort_exercises ALTER COLUMN id SET DEFAULT nextval('cohort_exercises_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohorts ALTER COLUMN id SET DEFAULT nextval('cohorts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY curriculum_notifications ALTER COLUMN id SET DEFAULT nextval('curriculum_notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY curriculums ALTER COLUMN id SET DEFAULT nextval('curriculums_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_plans ALTER COLUMN id SET DEFAULT nextval('daily_plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines ALTER COLUMN id SET DEFAULT nextval('deadlines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employment_profiles ALTER COLUMN id SET DEFAULT nextval('employment_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employments ALTER COLUMN id SET DEFAULT nextval('employments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY enrollments ALTER COLUMN id SET DEFAULT nextval('enrollments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY epics ALTER COLUMN id SET DEFAULT nextval('epics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY exercise_objectives ALTER COLUMN id SET DEFAULT nextval('exercise_objectives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY exercises ALTER COLUMN id SET DEFAULT nextval('exercises_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY expectation_statuses ALTER COLUMN id SET DEFAULT nextval('expectation_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY expectations ALTER COLUMN id SET DEFAULT nextval('expectations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY experience_objectives ALTER COLUMN id SET DEFAULT nextval('experience_objectives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY given_assessments ALTER COLUMN id SET DEFAULT nextval('given_assessments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY greenhouse_applications ALTER COLUMN id SET DEFAULT nextval('greenhouse_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY job_activities ALTER COLUMN id SET DEFAULT nextval('job_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY learning_experiences ALTER COLUMN id SET DEFAULT nextval('learning_experiences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lesson_plans ALTER COLUMN id SET DEFAULT nextval('lesson_plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons ALTER COLUMN id SET DEFAULT nextval('lessons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mentors ALTER COLUMN id SET DEFAULT nextval('mentors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mentorships ALTER COLUMN id SET DEFAULT nextval('mentorships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY objectives ALTER COLUMN id SET DEFAULT nextval('objectives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pair_rotations ALTER COLUMN id SET DEFAULT nextval('pair_rotations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pairings ALTER COLUMN id SET DEFAULT nextval('pairings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY performances ALTER COLUMN id SET DEFAULT nextval('performances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY planned_lessons ALTER COLUMN id SET DEFAULT nextval('planned_lessons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY snippets ALTER COLUMN id SET DEFAULT nextval('snippets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY staffings ALTER COLUMN id SET DEFAULT nextval('staffings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY standards ALTER COLUMN id SET DEFAULT nextval('standards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stories ALTER COLUMN id SET DEFAULT nextval('stories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_challenges ALTER COLUMN id SET DEFAULT nextval('student_challenges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_deadlines ALTER COLUMN id SET DEFAULT nextval('student_deadlines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_projects ALTER COLUMN id SET DEFAULT nextval('student_projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_snippets ALTER COLUMN id SET DEFAULT nextval('student_snippets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_stories ALTER COLUMN id SET DEFAULT nextval('student_stories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects ALTER COLUMN id SET DEFAULT nextval('subjects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions ALTER COLUMN id SET DEFAULT nextval('submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taken_assessments ALTER COLUMN id SET DEFAULT nextval('taken_assessments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tracker_statuses ALTER COLUMN id SET DEFAULT nextval('tracker_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY videos ALTER COLUMN id SET DEFAULT nextval('videos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY writeup_comments ALTER COLUMN id SET DEFAULT nextval('writeup_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY writeup_topics ALTER COLUMN id SET DEFAULT nextval('writeup_topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY writeups ALTER COLUMN id SET DEFAULT nextval('writeups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY zpd_responses ALTER COLUMN id SET DEFAULT nextval('zpd_responses_id_seq'::regclass);


--
-- Name: action_plan_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY action_plan_entries
    ADD CONSTRAINT action_plan_entries_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assessments
    ADD CONSTRAINT assessments_pkey PRIMARY KEY (id);


--
-- Name: assigned_learning_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assigned_learning_experiences
    ADD CONSTRAINT assigned_learning_experiences_pkey PRIMARY KEY (id);


--
-- Name: assignment_submission_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_submission_notes
    ADD CONSTRAINT assignment_submission_notes_pkey PRIMARY KEY (id);


--
-- Name: assignment_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_submissions
    ADD CONSTRAINT assignment_submissions_pkey PRIMARY KEY (id);


--
-- Name: assignments_cohorts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cohort_exercises
    ADD CONSTRAINT assignments_cohorts_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY exercises
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey1 PRIMARY KEY (id);


--
-- Name: campuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY campuses
    ADD CONSTRAINT campuses_pkey PRIMARY KEY (id);


--
-- Name: challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY challenges
    ADD CONSTRAINT challenges_pkey PRIMARY KEY (id);


--
-- Name: class_project_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY class_project_features
    ADD CONSTRAINT class_project_features_pkey PRIMARY KEY (id);


--
-- Name: class_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY class_projects
    ADD CONSTRAINT class_projects_pkey PRIMARY KEY (id);


--
-- Name: cohort_epics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cohort_epics
    ADD CONSTRAINT cohort_epics_pkey PRIMARY KEY (id);


--
-- Name: cohorts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cohorts
    ADD CONSTRAINT cohorts_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: curriculum_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY curriculum_notifications
    ADD CONSTRAINT curriculum_notifications_pkey PRIMARY KEY (id);


--
-- Name: curriculums_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY curriculums
    ADD CONSTRAINT curriculums_pkey PRIMARY KEY (id);


--
-- Name: daily_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY daily_plans
    ADD CONSTRAINT daily_plans_pkey PRIMARY KEY (id);


--
-- Name: deadlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deadlines
    ADD CONSTRAINT deadlines_pkey PRIMARY KEY (id);


--
-- Name: employment_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employment_profiles
    ADD CONSTRAINT employment_profiles_pkey PRIMARY KEY (id);


--
-- Name: employments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY employments
    ADD CONSTRAINT employments_pkey PRIMARY KEY (id);


--
-- Name: enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (id);


--
-- Name: epics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY epics
    ADD CONSTRAINT epics_pkey PRIMARY KEY (id);


--
-- Name: exercise_objectives_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY exercise_objectives
    ADD CONSTRAINT exercise_objectives_pkey PRIMARY KEY (id);


--
-- Name: expectation_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY expectation_statuses
    ADD CONSTRAINT expectation_statuses_pkey PRIMARY KEY (id);


--
-- Name: expectations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY expectations
    ADD CONSTRAINT expectations_pkey PRIMARY KEY (id);


--
-- Name: experience_objectives_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY experience_objectives
    ADD CONSTRAINT experience_objectives_pkey PRIMARY KEY (id);


--
-- Name: given_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY given_assessments
    ADD CONSTRAINT given_assessments_pkey PRIMARY KEY (id);


--
-- Name: greenhouse_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY greenhouse_applications
    ADD CONSTRAINT greenhouse_applications_pkey PRIMARY KEY (id);


--
-- Name: job_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY job_activities
    ADD CONSTRAINT job_activities_pkey PRIMARY KEY (id);


--
-- Name: learning_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY learning_experiences
    ADD CONSTRAINT learning_experiences_pkey PRIMARY KEY (id);


--
-- Name: lesson_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lesson_plans
    ADD CONSTRAINT lesson_plans_pkey PRIMARY KEY (id);


--
-- Name: lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: mentors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mentors
    ADD CONSTRAINT mentors_pkey PRIMARY KEY (id);


--
-- Name: mentorships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mentorships
    ADD CONSTRAINT mentorships_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: objectives_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY objectives
    ADD CONSTRAINT objectives_pkey PRIMARY KEY (id);


--
-- Name: pair_rotations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pair_rotations
    ADD CONSTRAINT pair_rotations_pkey PRIMARY KEY (id);


--
-- Name: pairings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pairings
    ADD CONSTRAINT pairings_pkey PRIMARY KEY (id);


--
-- Name: performances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY performances
    ADD CONSTRAINT performances_pkey PRIMARY KEY (id);


--
-- Name: planned_lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY planned_lessons
    ADD CONSTRAINT planned_lessons_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: snippets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY snippets
    ADD CONSTRAINT snippets_pkey PRIMARY KEY (id);


--
-- Name: staffings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY staffings
    ADD CONSTRAINT staffings_pkey PRIMARY KEY (id);


--
-- Name: standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY standards
    ADD CONSTRAINT standards_pkey PRIMARY KEY (id);


--
-- Name: stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stories
    ADD CONSTRAINT stories_pkey PRIMARY KEY (id);


--
-- Name: student_challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY student_challenges
    ADD CONSTRAINT student_challenges_pkey PRIMARY KEY (id);


--
-- Name: student_deadlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY student_deadlines
    ADD CONSTRAINT student_deadlines_pkey PRIMARY KEY (id);


--
-- Name: student_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY student_projects
    ADD CONSTRAINT student_projects_pkey PRIMARY KEY (id);


--
-- Name: student_snippets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY student_snippets
    ADD CONSTRAINT student_snippets_pkey PRIMARY KEY (id);


--
-- Name: student_stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY student_stories
    ADD CONSTRAINT student_stories_pkey PRIMARY KEY (id);


--
-- Name: subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: taken_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taken_assessments
    ADD CONSTRAINT taken_assessments_pkey PRIMARY KEY (id);


--
-- Name: tracker_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tracker_statuses
    ADD CONSTRAINT tracker_statuses_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: writeup_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY writeup_comments
    ADD CONSTRAINT writeup_comments_pkey PRIMARY KEY (id);


--
-- Name: writeup_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY writeup_topics
    ADD CONSTRAINT writeup_topics_pkey PRIMARY KEY (id);


--
-- Name: writeups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY writeups
    ADD CONSTRAINT writeups_pkey PRIMARY KEY (id);


--
-- Name: zpd_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY zpd_responses
    ADD CONSTRAINT zpd_responses_pkey PRIMARY KEY (id);


--
-- Name: daily_plans_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX daily_plans_idx ON daily_plans USING gin (to_tsvector('english'::regconfig, description));


--
-- Name: idx_assigned_experiences; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX idx_assigned_experiences ON assigned_learning_experiences USING btree (learning_experience_id, cohort_id);


--
-- Name: index_action_plan_entries_on_learning_experience_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_action_plan_entries_on_learning_experience_id ON action_plan_entries USING btree (learning_experience_id);


--
-- Name: index_answers_on_question_id_and_taken_assessment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_answers_on_question_id_and_taken_assessment_id ON answers USING btree (question_id, taken_assessment_id);


--
-- Name: index_category_epic_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_category_epic_name ON epics USING btree (class_project_id, name, category);


--
-- Name: index_category_feature_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_category_feature_name ON class_project_features USING btree (class_project_id, name, category);


--
-- Name: index_class_project_features_on_class_project_id_and_position; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_class_project_features_on_class_project_id_and_position ON class_project_features USING btree (class_project_id, "position");


--
-- Name: index_class_projects_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_class_projects_on_name ON class_projects USING btree (name);


--
-- Name: index_cohorts_on_course_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cohorts_on_course_id ON cohorts USING btree (course_id);


--
-- Name: index_cohorts_on_curriculum_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cohorts_on_curriculum_id ON cohorts USING btree (curriculum_id);


--
-- Name: index_cohorts_on_greenhouse_job_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_cohorts_on_greenhouse_job_id ON cohorts USING btree (greenhouse_job_id);


--
-- Name: index_courses_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_courses_on_name ON courses USING btree (name);


--
-- Name: index_curriculums_on_name_and_version; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_curriculums_on_name_and_version ON curriculums USING btree (name, version);


--
-- Name: index_daily_plans_on_date_and_cohort_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_daily_plans_on_date_and_cohort_id ON daily_plans USING btree (date, cohort_id);


--
-- Name: index_employment_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_employment_profiles_on_user_id ON employment_profiles USING btree (user_id);


--
-- Name: index_enrollments_on_user_id_and_cohort_id_and_role; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_enrollments_on_user_id_and_cohort_id_and_role ON enrollments USING btree (user_id, cohort_id, role);


--
-- Name: index_epics_on_class_project_id_and_position; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_epics_on_class_project_id_and_position ON epics USING btree (class_project_id, "position");


--
-- Name: index_exercise_objectives_on_objective_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_exercise_objectives_on_objective_id ON exercise_objectives USING btree (objective_id);


--
-- Name: index_expectation_statuses_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_expectation_statuses_on_author_id ON expectation_statuses USING btree (author_id);


--
-- Name: index_expectation_statuses_on_cohort_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_expectation_statuses_on_cohort_id ON expectation_statuses USING btree (cohort_id);


--
-- Name: index_expectation_statuses_on_expectation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_expectation_statuses_on_expectation_id ON expectation_statuses USING btree (expectation_id);


--
-- Name: index_expectation_statuses_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_expectation_statuses_on_user_id ON expectation_statuses USING btree (user_id);


--
-- Name: index_expectations_on_course_id_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_expectations_on_course_id_and_name ON expectations USING btree (course_id, name);


--
-- Name: index_experience_objectives_on_learning_experience_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_experience_objectives_on_learning_experience_id ON experience_objectives USING btree (learning_experience_id);


--
-- Name: index_experience_objectives_on_objective_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_experience_objectives_on_objective_id ON experience_objectives USING btree (objective_id);


--
-- Name: index_learning_experiences_on_curriculum_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_learning_experiences_on_curriculum_id ON learning_experiences USING btree (curriculum_id);


--
-- Name: index_lesson_plans_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_lesson_plans_on_name ON lesson_plans USING btree (name);


--
-- Name: index_mentors_on_mentor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentors_on_mentor_id ON mentors USING btree (mentor_id);


--
-- Name: index_mentors_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mentors_on_status ON mentors USING btree (status);


--
-- Name: index_notes_on_learning_experience_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notes_on_learning_experience_id ON notes USING btree (learning_experience_id);


--
-- Name: index_notes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notes_on_user_id ON notes USING btree (user_id);


--
-- Name: index_pairings_on_pair_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pairings_on_pair_id ON pairings USING btree (pair_id);


--
-- Name: index_pairings_on_user_id_and_pair_id_and_paired_on; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pairings_on_user_id_and_pair_id_and_paired_on ON pairings USING btree (user_id, pair_id, paired_on);


--
-- Name: index_performances_on_objective_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_performances_on_objective_id ON performances USING btree (objective_id);


--
-- Name: index_performances_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_performances_on_user_id ON performances USING btree (user_id);


--
-- Name: index_performances_on_user_id_and_objective_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_performances_on_user_id_and_objective_id ON performances USING btree (user_id, objective_id);


--
-- Name: index_planned_lessons_on_curriculum_unit_id_and_lesson_plan_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_planned_lessons_on_curriculum_unit_id_and_lesson_plan_id ON planned_lessons USING btree (curriculum_unit_id, lesson_plan_id);


--
-- Name: index_planned_lessons_on_curriculum_unit_id_and_position; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_planned_lessons_on_curriculum_unit_id_and_position ON planned_lessons USING btree (curriculum_unit_id, "position");


--
-- Name: index_staffings_on_cohort_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_staffings_on_cohort_id_and_user_id ON staffings USING btree (cohort_id, user_id);


--
-- Name: index_staffings_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_staffings_on_status ON staffings USING btree (status);


--
-- Name: index_standards_on_curriculum_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_standards_on_curriculum_id ON standards USING btree (curriculum_id);


--
-- Name: index_stories_on_epic_id_and_position; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_stories_on_epic_id_and_position ON stories USING btree (epic_id, "position");


--
-- Name: index_stories_on_epic_id_and_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_stories_on_epic_id_and_title ON stories USING btree (epic_id, title);


--
-- Name: index_student_stories_on_story_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_student_stories_on_story_id_and_user_id ON student_stories USING btree (story_id, user_id);


--
-- Name: index_submissions_on_exercise_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_exercise_id ON submissions USING btree (exercise_id);


--
-- Name: index_submissions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_user_id ON submissions USING btree (user_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_taken_assessments_on_user_id_and_given_assessment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taken_assessments_on_user_id_and_given_assessment_id ON taken_assessments USING btree (user_id, given_assessment_id);


--
-- Name: index_tracker_statuses_on_user_id_and_class_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tracker_statuses_on_user_id_and_class_project_id ON tracker_statuses USING btree (user_id, class_project_id);


--
-- Name: index_users_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_email ON users USING btree (lower((email)::text));


--
-- Name: index_users_github_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_github_id ON users USING btree (lower((github_id)::text));


--
-- Name: index_users_on_greenhouse_candidate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_greenhouse_candidate_id ON users USING btree (greenhouse_candidate_id);


--
-- Name: index_users_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_status ON users USING btree (status);


--
-- Name: index_writeups_on_score; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_writeups_on_score ON writeups USING btree (score);


--
-- Name: index_writeups_on_writeup_topic_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_writeups_on_writeup_topic_id_and_user_id ON writeups USING btree (writeup_topic_id, user_id);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX taggings_idx ON taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: users_lower_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_lower_idx ON users USING btree (lower((email)::text));


--
-- Name: assignment_submissions_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_submissions
    ADD CONSTRAINT assignment_submissions_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_action_plan_entries_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY action_plan_entries
    ADD CONSTRAINT fk_action_plan_entries_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_action_plan_entries_learning_experience_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY action_plan_entries
    ADD CONSTRAINT fk_action_plan_entries_learning_experience_id FOREIGN KEY (learning_experience_id) REFERENCES learning_experiences(id) ON DELETE CASCADE;


--
-- Name: fk_action_plan_entries_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY action_plan_entries
    ADD CONSTRAINT fk_action_plan_entries_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_answers_taken_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT fk_answers_taken_assessment_id FOREIGN KEY (taken_assessment_id) REFERENCES taken_assessments(id) ON DELETE CASCADE;


--
-- Name: fk_assigned_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assigned_learning_experiences
    ADD CONSTRAINT fk_assigned_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_assigned_experience_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assigned_learning_experiences
    ADD CONSTRAINT fk_assigned_experience_id FOREIGN KEY (learning_experience_id) REFERENCES learning_experiences(id) ON DELETE CASCADE;


--
-- Name: fk_assignment_submission_notes_assignment_submission_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_submission_notes
    ADD CONSTRAINT fk_assignment_submission_notes_assignment_submission_id FOREIGN KEY (assignment_submission_id) REFERENCES assignment_submissions(id) ON DELETE CASCADE;


--
-- Name: fk_assignment_submissions_assignment_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_submissions
    ADD CONSTRAINT fk_assignment_submissions_assignment_id FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE;


--
-- Name: fk_assignments_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT fk_assignments_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_challenges_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY challenges
    ADD CONSTRAINT fk_challenges_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_class_project_features_class_project_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY class_project_features
    ADD CONSTRAINT fk_class_project_features_class_project_id FOREIGN KEY (class_project_id) REFERENCES class_projects(id) ON DELETE CASCADE;


--
-- Name: fk_cohort_epics_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohort_epics
    ADD CONSTRAINT fk_cohort_epics_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_cohort_epics_epic_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohort_epics
    ADD CONSTRAINT fk_cohort_epics_epic_id FOREIGN KEY (epic_id) REFERENCES epics(id) ON DELETE CASCADE;


--
-- Name: fk_cohort_exercises_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohort_exercises
    ADD CONSTRAINT fk_cohort_exercises_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_cohort_exercises_exercise_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohort_exercises
    ADD CONSTRAINT fk_cohort_exercises_exercise_id FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE;


--
-- Name: fk_cohorts_campus_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohorts
    ADD CONSTRAINT fk_cohorts_campus_id FOREIGN KEY (campus_id) REFERENCES campuses(id) ON DELETE CASCADE;


--
-- Name: fk_cohorts_course_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohorts
    ADD CONSTRAINT fk_cohorts_course_id FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE;


--
-- Name: fk_cohorts_curriculum_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cohorts
    ADD CONSTRAINT fk_cohorts_curriculum_id FOREIGN KEY (curriculum_id) REFERENCES curriculums(id) ON DELETE CASCADE;


--
-- Name: fk_curriculum_notifications_curriculum_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY curriculum_notifications
    ADD CONSTRAINT fk_curriculum_notifications_curriculum_id FOREIGN KEY (curriculum_id) REFERENCES curriculums(id) ON DELETE CASCADE;


--
-- Name: fk_curriculum_notifications_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY curriculum_notifications
    ADD CONSTRAINT fk_curriculum_notifications_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_daily_plans_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_plans
    ADD CONSTRAINT fk_daily_plans_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_deadlines_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deadlines
    ADD CONSTRAINT fk_deadlines_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_employment_profiles_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employment_profiles
    ADD CONSTRAINT fk_employment_profiles_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_employments_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employments
    ADD CONSTRAINT fk_employments_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_enrollments_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enrollments
    ADD CONSTRAINT fk_enrollments_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_enrollments_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enrollments
    ADD CONSTRAINT fk_enrollments_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_epics_class_project_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY epics
    ADD CONSTRAINT fk_epics_class_project_id FOREIGN KEY (class_project_id) REFERENCES class_projects(id) ON DELETE CASCADE;


--
-- Name: fk_exercise_objectives_exercise_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY exercise_objectives
    ADD CONSTRAINT fk_exercise_objectives_exercise_id FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE;


--
-- Name: fk_exercise_objectives_objective_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY exercise_objectives
    ADD CONSTRAINT fk_exercise_objectives_objective_id FOREIGN KEY (objective_id) REFERENCES objectives(id) ON DELETE CASCADE;


--
-- Name: fk_exercises_curriculum_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY exercises
    ADD CONSTRAINT fk_exercises_curriculum_id FOREIGN KEY (curriculum_id) REFERENCES curriculums(id) ON DELETE RESTRICT;


--
-- Name: fk_expectation_statuses_author_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expectation_statuses
    ADD CONSTRAINT fk_expectation_statuses_author_id FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_expectation_statuses_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expectation_statuses
    ADD CONSTRAINT fk_expectation_statuses_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_expectation_statuses_expectation_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expectation_statuses
    ADD CONSTRAINT fk_expectation_statuses_expectation_id FOREIGN KEY (expectation_id) REFERENCES expectations(id) ON DELETE CASCADE;


--
-- Name: fk_expectation_statuses_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expectation_statuses
    ADD CONSTRAINT fk_expectation_statuses_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_expectations_course_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expectations
    ADD CONSTRAINT fk_expectations_course_id FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE;


--
-- Name: fk_experience_objectives_learning_experience_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY experience_objectives
    ADD CONSTRAINT fk_experience_objectives_learning_experience_id FOREIGN KEY (learning_experience_id) REFERENCES learning_experiences(id) ON DELETE CASCADE;


--
-- Name: fk_experience_objectives_objective_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY experience_objectives
    ADD CONSTRAINT fk_experience_objectives_objective_id FOREIGN KEY (objective_id) REFERENCES objectives(id) ON DELETE CASCADE;


--
-- Name: fk_given_assessments_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY given_assessments
    ADD CONSTRAINT fk_given_assessments_assessment_id FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON DELETE CASCADE;


--
-- Name: fk_given_assessments_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY given_assessments
    ADD CONSTRAINT fk_given_assessments_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_greenhouse_applications_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY greenhouse_applications
    ADD CONSTRAINT fk_greenhouse_applications_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_job_activities_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY job_activities
    ADD CONSTRAINT fk_job_activities_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_learning_experiences_curriculum_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY learning_experiences
    ADD CONSTRAINT fk_learning_experiences_curriculum_id FOREIGN KEY (curriculum_id) REFERENCES curriculums(id) ON DELETE CASCADE;


--
-- Name: fk_learning_experiences_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY learning_experiences
    ADD CONSTRAINT fk_learning_experiences_subject_id FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE;


--
-- Name: fk_lessons_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT fk_lessons_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_lessons_lesson_plan_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT fk_lessons_lesson_plan_id FOREIGN KEY (lesson_plan_id) REFERENCES lesson_plans(id) ON DELETE CASCADE;


--
-- Name: fk_mentors_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mentors
    ADD CONSTRAINT fk_mentors_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_mentorships_mentor_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mentorships
    ADD CONSTRAINT fk_mentorships_mentor_id FOREIGN KEY (mentor_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_mentorships_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mentorships
    ADD CONSTRAINT fk_mentorships_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_objectives_standard_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY objectives
    ADD CONSTRAINT fk_objectives_standard_id FOREIGN KEY (standard_id) REFERENCES standards(id) ON DELETE CASCADE;


--
-- Name: fk_pair_rotations_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pair_rotations
    ADD CONSTRAINT fk_pair_rotations_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_pairings_pair_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pairings
    ADD CONSTRAINT fk_pairings_pair_id FOREIGN KEY (pair_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_pairings_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pairings
    ADD CONSTRAINT fk_pairings_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_performances_objective_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY performances
    ADD CONSTRAINT fk_performances_objective_id FOREIGN KEY (objective_id) REFERENCES objectives(id) ON DELETE CASCADE;


--
-- Name: fk_performances_updator_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY performances
    ADD CONSTRAINT fk_performances_updator_id FOREIGN KEY (updator_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_performances_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY performances
    ADD CONSTRAINT fk_performances_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_planned_lessons_lesson_plan_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY planned_lessons
    ADD CONSTRAINT fk_planned_lessons_lesson_plan_id FOREIGN KEY (lesson_plan_id) REFERENCES lesson_plans(id) ON DELETE CASCADE;


--
-- Name: fk_snippets_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snippets
    ADD CONSTRAINT fk_snippets_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_staffings_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staffings
    ADD CONSTRAINT fk_staffings_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_staffings_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staffings
    ADD CONSTRAINT fk_staffings_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_standards_curriculum_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY standards
    ADD CONSTRAINT fk_standards_curriculum_id FOREIGN KEY (curriculum_id) REFERENCES curriculums(id) ON DELETE CASCADE;


--
-- Name: fk_standards_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY standards
    ADD CONSTRAINT fk_standards_subject_id FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE RESTRICT;


--
-- Name: fk_stories_epic_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stories
    ADD CONSTRAINT fk_stories_epic_id FOREIGN KEY (epic_id) REFERENCES epics(id) ON DELETE CASCADE;


--
-- Name: fk_student_challenges_challenge_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_challenges
    ADD CONSTRAINT fk_student_challenges_challenge_id FOREIGN KEY (challenge_id) REFERENCES challenges(id) ON DELETE CASCADE;


--
-- Name: fk_student_challenges_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_challenges
    ADD CONSTRAINT fk_student_challenges_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_student_deadlines_deadline_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_deadlines
    ADD CONSTRAINT fk_student_deadlines_deadline_id FOREIGN KEY (deadline_id) REFERENCES deadlines(id) ON DELETE CASCADE;


--
-- Name: fk_student_deadlines_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_deadlines
    ADD CONSTRAINT fk_student_deadlines_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_student_projects_class_project_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_projects
    ADD CONSTRAINT fk_student_projects_class_project_id FOREIGN KEY (class_project_id) REFERENCES class_projects(id) ON DELETE CASCADE;


--
-- Name: fk_student_projects_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_projects
    ADD CONSTRAINT fk_student_projects_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_student_snippets_snippet_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_snippets
    ADD CONSTRAINT fk_student_snippets_snippet_id FOREIGN KEY (snippet_id) REFERENCES snippets(id) ON DELETE CASCADE;


--
-- Name: fk_student_snippets_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_snippets
    ADD CONSTRAINT fk_student_snippets_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_student_stories_class_project_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_stories
    ADD CONSTRAINT fk_student_stories_class_project_id FOREIGN KEY (class_project_id) REFERENCES class_projects(id) ON DELETE CASCADE;


--
-- Name: fk_student_stories_epic_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_stories
    ADD CONSTRAINT fk_student_stories_epic_id FOREIGN KEY (epic_id) REFERENCES epics(id) ON DELETE CASCADE;


--
-- Name: fk_student_stories_story_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_stories
    ADD CONSTRAINT fk_student_stories_story_id FOREIGN KEY (story_id) REFERENCES stories(id) ON DELETE CASCADE;


--
-- Name: fk_student_stories_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_stories
    ADD CONSTRAINT fk_student_stories_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_subjects_curriculum_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT fk_subjects_curriculum_id FOREIGN KEY (curriculum_id) REFERENCES curriculums(id) ON DELETE CASCADE;


--
-- Name: fk_submissions_exercise_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT fk_submissions_exercise_id FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE;


--
-- Name: fk_submissions_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT fk_submissions_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_taggings_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT fk_taggings_tag_id FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;


--
-- Name: fk_taken_assessments_given_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taken_assessments
    ADD CONSTRAINT fk_taken_assessments_given_assessment_id FOREIGN KEY (given_assessment_id) REFERENCES given_assessments(id) ON DELETE CASCADE;


--
-- Name: fk_taken_assessments_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taken_assessments
    ADD CONSTRAINT fk_taken_assessments_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_tracker_statuses_class_project_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tracker_statuses
    ADD CONSTRAINT fk_tracker_statuses_class_project_id FOREIGN KEY (class_project_id) REFERENCES class_projects(id) ON DELETE CASCADE;


--
-- Name: fk_tracker_statuses_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tracker_statuses
    ADD CONSTRAINT fk_tracker_statuses_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_writeup_comments_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY writeup_comments
    ADD CONSTRAINT fk_writeup_comments_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_writeup_comments_writeup_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY writeup_comments
    ADD CONSTRAINT fk_writeup_comments_writeup_id FOREIGN KEY (writeup_id) REFERENCES writeups(id) ON DELETE CASCADE;


--
-- Name: fk_writeup_topics_cohort_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY writeup_topics
    ADD CONSTRAINT fk_writeup_topics_cohort_id FOREIGN KEY (cohort_id) REFERENCES cohorts(id) ON DELETE CASCADE;


--
-- Name: fk_writeups_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY writeups
    ADD CONSTRAINT fk_writeups_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_writeups_writeup_topic_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY writeups
    ADD CONSTRAINT fk_writeups_writeup_topic_id FOREIGN KEY (writeup_topic_id) REFERENCES writeup_topics(id) ON DELETE CASCADE;


--
-- Name: fk_zpd_responses_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zpd_responses
    ADD CONSTRAINT fk_zpd_responses_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20131209215002');

INSERT INTO schema_migrations (version) VALUES ('20131213155355');

INSERT INTO schema_migrations (version) VALUES ('20131224163815');

INSERT INTO schema_migrations (version) VALUES ('20131226201447');

INSERT INTO schema_migrations (version) VALUES ('20140126221834');

INSERT INTO schema_migrations (version) VALUES ('20140126222638');

INSERT INTO schema_migrations (version) VALUES ('20140128185600');

INSERT INTO schema_migrations (version) VALUES ('20140131221240');

INSERT INTO schema_migrations (version) VALUES ('20140203170204');

INSERT INTO schema_migrations (version) VALUES ('20140206173011');

INSERT INTO schema_migrations (version) VALUES ('20140206175553');

INSERT INTO schema_migrations (version) VALUES ('20140206184130');

INSERT INTO schema_migrations (version) VALUES ('20140213171824');

INSERT INTO schema_migrations (version) VALUES ('20140214182415');

INSERT INTO schema_migrations (version) VALUES ('20140219161546');

INSERT INTO schema_migrations (version) VALUES ('20140219182633');

INSERT INTO schema_migrations (version) VALUES ('20140219184249');

INSERT INTO schema_migrations (version) VALUES ('20140219184514');

INSERT INTO schema_migrations (version) VALUES ('20140219223115');

INSERT INTO schema_migrations (version) VALUES ('20140220175812');

INSERT INTO schema_migrations (version) VALUES ('20140220180447');

INSERT INTO schema_migrations (version) VALUES ('20140317214240');

INSERT INTO schema_migrations (version) VALUES ('20140320170254');

INSERT INTO schema_migrations (version) VALUES ('20140325224129');

INSERT INTO schema_migrations (version) VALUES ('20140423175738');

INSERT INTO schema_migrations (version) VALUES ('20140423181205');

INSERT INTO schema_migrations (version) VALUES ('20140512224734');

INSERT INTO schema_migrations (version) VALUES ('20140513005804');

INSERT INTO schema_migrations (version) VALUES ('20140513204500');

INSERT INTO schema_migrations (version) VALUES ('20140513223706');

INSERT INTO schema_migrations (version) VALUES ('20140514193828');

INSERT INTO schema_migrations (version) VALUES ('20140527192720');

INSERT INTO schema_migrations (version) VALUES ('20140527202818');

INSERT INTO schema_migrations (version) VALUES ('20140602170905');

INSERT INTO schema_migrations (version) VALUES ('20140602170906');

INSERT INTO schema_migrations (version) VALUES ('20140602170907');

INSERT INTO schema_migrations (version) VALUES ('20140604035613');

INSERT INTO schema_migrations (version) VALUES ('20140604164805');

INSERT INTO schema_migrations (version) VALUES ('20140605171722');

INSERT INTO schema_migrations (version) VALUES ('20140605182637');

INSERT INTO schema_migrations (version) VALUES ('20140605184410');

INSERT INTO schema_migrations (version) VALUES ('20140606171229');

INSERT INTO schema_migrations (version) VALUES ('20140606171724');

INSERT INTO schema_migrations (version) VALUES ('20140608003714');

INSERT INTO schema_migrations (version) VALUES ('20140608003733');

INSERT INTO schema_migrations (version) VALUES ('20140608013056');

INSERT INTO schema_migrations (version) VALUES ('20140610191352');

INSERT INTO schema_migrations (version) VALUES ('20140616155942');

INSERT INTO schema_migrations (version) VALUES ('20140616171106');

INSERT INTO schema_migrations (version) VALUES ('20140616190901');

INSERT INTO schema_migrations (version) VALUES ('20140617163458');

INSERT INTO schema_migrations (version) VALUES ('20140618172946');

INSERT INTO schema_migrations (version) VALUES ('20140618173115');

INSERT INTO schema_migrations (version) VALUES ('20140618212906');

INSERT INTO schema_migrations (version) VALUES ('20140619160320');

INSERT INTO schema_migrations (version) VALUES ('20140702181800');

INSERT INTO schema_migrations (version) VALUES ('20140702183119');

INSERT INTO schema_migrations (version) VALUES ('20140702184153');

INSERT INTO schema_migrations (version) VALUES ('20140702184551');

INSERT INTO schema_migrations (version) VALUES ('20140702231710');

INSERT INTO schema_migrations (version) VALUES ('20140702234326');

INSERT INTO schema_migrations (version) VALUES ('20140703003251');

INSERT INTO schema_migrations (version) VALUES ('20140709225248');

INSERT INTO schema_migrations (version) VALUES ('20140716174651');

INSERT INTO schema_migrations (version) VALUES ('20140716232250');

INSERT INTO schema_migrations (version) VALUES ('20140717004643');

INSERT INTO schema_migrations (version) VALUES ('20140717210346');

INSERT INTO schema_migrations (version) VALUES ('20140718141456');

INSERT INTO schema_migrations (version) VALUES ('20140722152610');

INSERT INTO schema_migrations (version) VALUES ('20140722161709');

INSERT INTO schema_migrations (version) VALUES ('20140910161616');

INSERT INTO schema_migrations (version) VALUES ('20140911012330');

INSERT INTO schema_migrations (version) VALUES ('20140918153856');

INSERT INTO schema_migrations (version) VALUES ('20140924172246');

INSERT INTO schema_migrations (version) VALUES ('20140924174644');

INSERT INTO schema_migrations (version) VALUES ('20141002040858');

INSERT INTO schema_migrations (version) VALUES ('20141002054757');

INSERT INTO schema_migrations (version) VALUES ('20141003064806');

INSERT INTO schema_migrations (version) VALUES ('20141003211830');

INSERT INTO schema_migrations (version) VALUES ('20141007180233');

INSERT INTO schema_migrations (version) VALUES ('20141008221928');

INSERT INTO schema_migrations (version) VALUES ('20141013060305');

INSERT INTO schema_migrations (version) VALUES ('20141019214050');

INSERT INTO schema_migrations (version) VALUES ('20141021033126');

INSERT INTO schema_migrations (version) VALUES ('20141030193034');

INSERT INTO schema_migrations (version) VALUES ('20141031173241');

INSERT INTO schema_migrations (version) VALUES ('20141101164837');

INSERT INTO schema_migrations (version) VALUES ('20141103062448');

INSERT INTO schema_migrations (version) VALUES ('20141103064718');

INSERT INTO schema_migrations (version) VALUES ('20141103232155');

INSERT INTO schema_migrations (version) VALUES ('20141103232504');

INSERT INTO schema_migrations (version) VALUES ('20141103234643');

INSERT INTO schema_migrations (version) VALUES ('20141104001726');

INSERT INTO schema_migrations (version) VALUES ('20141104005208');

INSERT INTO schema_migrations (version) VALUES ('20141104050025');

INSERT INTO schema_migrations (version) VALUES ('20141104232823');

INSERT INTO schema_migrations (version) VALUES ('20141109214844');

INSERT INTO schema_migrations (version) VALUES ('20141109222623');

INSERT INTO schema_migrations (version) VALUES ('20141109225256');

INSERT INTO schema_migrations (version) VALUES ('20141112061928');

INSERT INTO schema_migrations (version) VALUES ('20141114062753');

INSERT INTO schema_migrations (version) VALUES ('20141117171119');

INSERT INTO schema_migrations (version) VALUES ('20141125225111');

INSERT INTO schema_migrations (version) VALUES ('20141203071617');

INSERT INTO schema_migrations (version) VALUES ('20141208023800');

INSERT INTO schema_migrations (version) VALUES ('20141208045417');

INSERT INTO schema_migrations (version) VALUES ('20141208050341');

INSERT INTO schema_migrations (version) VALUES ('20141208052103');

INSERT INTO schema_migrations (version) VALUES ('20141208063210');

INSERT INTO schema_migrations (version) VALUES ('20141208064113');

INSERT INTO schema_migrations (version) VALUES ('20141208065228');

INSERT INTO schema_migrations (version) VALUES ('20141209234905');

INSERT INTO schema_migrations (version) VALUES ('20141211173931');

INSERT INTO schema_migrations (version) VALUES ('20141212001914');

INSERT INTO schema_migrations (version) VALUES ('20141212002849');

INSERT INTO schema_migrations (version) VALUES ('20141212005638');

INSERT INTO schema_migrations (version) VALUES ('20141212011118');

INSERT INTO schema_migrations (version) VALUES ('20141212012318');

INSERT INTO schema_migrations (version) VALUES ('20141212030043');

INSERT INTO schema_migrations (version) VALUES ('20141212053957');

INSERT INTO schema_migrations (version) VALUES ('20141212060140');

INSERT INTO schema_migrations (version) VALUES ('20141212165034');

INSERT INTO schema_migrations (version) VALUES ('20141217150217');

INSERT INTO schema_migrations (version) VALUES ('20141221035809');

INSERT INTO schema_migrations (version) VALUES ('20141224214857');

INSERT INTO schema_migrations (version) VALUES ('20141226225611');

INSERT INTO schema_migrations (version) VALUES ('20141227032733');

INSERT INTO schema_migrations (version) VALUES ('20141227055623');

INSERT INTO schema_migrations (version) VALUES ('20141230182605');

INSERT INTO schema_migrations (version) VALUES ('20141230205731');

INSERT INTO schema_migrations (version) VALUES ('20141230220241');

INSERT INTO schema_migrations (version) VALUES ('20141230221407');

INSERT INTO schema_migrations (version) VALUES ('20141230231533');

INSERT INTO schema_migrations (version) VALUES ('20141231001056');

INSERT INTO schema_migrations (version) VALUES ('20141231040227');

INSERT INTO schema_migrations (version) VALUES ('20141231150454');

INSERT INTO schema_migrations (version) VALUES ('20150102160038');

INSERT INTO schema_migrations (version) VALUES ('20150105041428');

INSERT INTO schema_migrations (version) VALUES ('20150105061409');

INSERT INTO schema_migrations (version) VALUES ('20150105062516');

INSERT INTO schema_migrations (version) VALUES ('20150106053023');

INSERT INTO schema_migrations (version) VALUES ('20150106062529');

INSERT INTO schema_migrations (version) VALUES ('20150106164051');

INSERT INTO schema_migrations (version) VALUES ('20150106175954');

INSERT INTO schema_migrations (version) VALUES ('20150107004107');

INSERT INTO schema_migrations (version) VALUES ('20150109164631');

INSERT INTO schema_migrations (version) VALUES ('20150109184052');

INSERT INTO schema_migrations (version) VALUES ('20150110060127');

INSERT INTO schema_migrations (version) VALUES ('20150110063644');

INSERT INTO schema_migrations (version) VALUES ('20150110090626');

INSERT INTO schema_migrations (version) VALUES ('20150112183546');

INSERT INTO schema_migrations (version) VALUES ('20150113162936');

INSERT INTO schema_migrations (version) VALUES ('20150113163918');

INSERT INTO schema_migrations (version) VALUES ('20150113164518');

INSERT INTO schema_migrations (version) VALUES ('20150113165539');

INSERT INTO schema_migrations (version) VALUES ('20150115041644');

INSERT INTO schema_migrations (version) VALUES ('20150119053407');

INSERT INTO schema_migrations (version) VALUES ('20150126174111');

INSERT INTO schema_migrations (version) VALUES ('20150128055058');

INSERT INTO schema_migrations (version) VALUES ('20150129055911');

INSERT INTO schema_migrations (version) VALUES ('20150130152156');

INSERT INTO schema_migrations (version) VALUES ('20150216171727');

INSERT INTO schema_migrations (version) VALUES ('20150223173415');

INSERT INTO schema_migrations (version) VALUES ('20150224164459');

INSERT INTO schema_migrations (version) VALUES ('20150225044057');

INSERT INTO schema_migrations (version) VALUES ('20150225203400');

INSERT INTO schema_migrations (version) VALUES ('20150225204925');

INSERT INTO schema_migrations (version) VALUES ('20150317143408');

INSERT INTO schema_migrations (version) VALUES ('20150320031411');

INSERT INTO schema_migrations (version) VALUES ('20150331043335');

INSERT INTO schema_migrations (version) VALUES ('20150406162952');

INSERT INTO schema_migrations (version) VALUES ('20150406170906');

INSERT INTO schema_migrations (version) VALUES ('20150416202913');

INSERT INTO schema_migrations (version) VALUES ('20150416204310');

INSERT INTO schema_migrations (version) VALUES ('20150420170127');

INSERT INTO schema_migrations (version) VALUES ('20150602225746');

INSERT INTO schema_migrations (version) VALUES ('20150603030422');

INSERT INTO schema_migrations (version) VALUES ('20150618201357');

INSERT INTO schema_migrations (version) VALUES ('20150625024009');

INSERT INTO schema_migrations (version) VALUES ('20150704185949');

INSERT INTO schema_migrations (version) VALUES ('20150704191027');

INSERT INTO schema_migrations (version) VALUES ('20150709170251');

INSERT INTO schema_migrations (version) VALUES ('20150713041104');

INSERT INTO schema_migrations (version) VALUES ('20150723222720');

INSERT INTO schema_migrations (version) VALUES ('20150723225118');

INSERT INTO schema_migrations (version) VALUES ('20150723230211');

INSERT INTO schema_migrations (version) VALUES ('20150804154345');

INSERT INTO schema_migrations (version) VALUES ('20150804162935');

INSERT INTO schema_migrations (version) VALUES ('20150805041322');

INSERT INTO schema_migrations (version) VALUES ('20150805152304');

INSERT INTO schema_migrations (version) VALUES ('20150805152945');

INSERT INTO schema_migrations (version) VALUES ('20150806155523');

INSERT INTO schema_migrations (version) VALUES ('20150806232553');

INSERT INTO schema_migrations (version) VALUES ('20150807154405');

INSERT INTO schema_migrations (version) VALUES ('20150808033500');

INSERT INTO schema_migrations (version) VALUES ('20150809195922');

INSERT INTO schema_migrations (version) VALUES ('20150811024428');

INSERT INTO schema_migrations (version) VALUES ('20150812010312');

INSERT INTO schema_migrations (version) VALUES ('20150814021306');

INSERT INTO schema_migrations (version) VALUES ('20150814052743');

INSERT INTO schema_migrations (version) VALUES ('20150815033044');

INSERT INTO schema_migrations (version) VALUES ('20150817153559');

INSERT INTO schema_migrations (version) VALUES ('20150819225437');

INSERT INTO schema_migrations (version) VALUES ('20150820015734');

INSERT INTO schema_migrations (version) VALUES ('20150826170159');

INSERT INTO schema_migrations (version) VALUES ('20150904170937');

INSERT INTO schema_migrations (version) VALUES ('20150922203605');

INSERT INTO schema_migrations (version) VALUES ('20150923201318');

INSERT INTO schema_migrations (version) VALUES ('20150924164940');

INSERT INTO schema_migrations (version) VALUES ('20151019222301');

INSERT INTO schema_migrations (version) VALUES ('20151027194904');

INSERT INTO schema_migrations (version) VALUES ('20151027235624');

INSERT INTO schema_migrations (version) VALUES ('20151115015807');

INSERT INTO schema_migrations (version) VALUES ('20151202161623');

INSERT INTO schema_migrations (version) VALUES ('20151203035439');

INSERT INTO schema_migrations (version) VALUES ('20151203052419');

INSERT INTO schema_migrations (version) VALUES ('20151203183008');

INSERT INTO schema_migrations (version) VALUES ('20151207171321');

INSERT INTO schema_migrations (version) VALUES ('20151210011434');

INSERT INTO schema_migrations (version) VALUES ('20151210222748');

INSERT INTO schema_migrations (version) VALUES ('20151214005113');

INSERT INTO schema_migrations (version) VALUES ('20151214232904');

INSERT INTO schema_migrations (version) VALUES ('20151216000823');

INSERT INTO schema_migrations (version) VALUES ('20151216223257');

INSERT INTO schema_migrations (version) VALUES ('20151221214730');

INSERT INTO schema_migrations (version) VALUES ('20151230175507');

INSERT INTO schema_migrations (version) VALUES ('20160104221500');

INSERT INTO schema_migrations (version) VALUES ('20160105231602');

INSERT INTO schema_migrations (version) VALUES ('20160105232728');

INSERT INTO schema_migrations (version) VALUES ('20160113173613');

INSERT INTO schema_migrations (version) VALUES ('20160120045632');

INSERT INTO schema_migrations (version) VALUES ('20160120232818');

INSERT INTO schema_migrations (version) VALUES ('20160202032619');

INSERT INTO schema_migrations (version) VALUES ('20160202052038');

INSERT INTO schema_migrations (version) VALUES ('20160202053703');

