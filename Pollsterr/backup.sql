-- Disable foreign key checks
SET session_replication_role = 'replica';

BEGIN TRANSACTION;

-- Create tables in dependency order
CREATE TABLE IF NOT EXISTS "django_content_type" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "app_label" varchar(100) NOT NULL,
    "model" varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS "auth_group" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "name" varchar(150) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS "auth_user" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "password" varchar(128) NOT NULL,
    "last_login" timestamp NULL,
    "is_superuser" boolean NOT NULL,
    "username" varchar(150) NOT NULL UNIQUE,
    "last_name" varchar(150) NOT NULL,
    "email" varchar(254) NOT NULL,
    "is_staff" boolean NOT NULL,
    "is_active" boolean NOT NULL,
    "date_joined" timestamp NOT NULL,
    "first_name" varchar(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS "auth_permission" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "codename" varchar(100) NOT NULL,
    "name" varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED,
    "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS "auth_user_groups" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED,
    "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED,
    "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS "django_admin_log" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "object_id" text NULL,
    "object_repr" varchar(200) NOT NULL,
    "action_flag" smallint NOT NULL CHECK ("action_flag" >= 0),
    "change_message" text NOT NULL,
    "content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED,
    "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED,
    "action_time" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS "django_migrations" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "app" varchar(255) NOT NULL,
    "name" varchar(255) NOT NULL,
    "applied" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS "django_session" (
    "session_key" varchar(40) NOT NULL PRIMARY KEY,
    "session_data" text NOT NULL,
    "expire_date" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS "polls_question" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "question_text" varchar(200) NOT NULL,
    "pub_date" timestamp NOT NULL
);

CREATE TABLE IF NOT EXISTS "polls_choice" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "choice_text" varchar(200) NOT NULL,
    "votes" integer NOT NULL,
    "question_id" integer NOT NULL REFERENCES "polls_question" ("id") DEFERRABLE INITIALLY DEFERRED
);

-- Insert data for django_content_type first (referenced by auth_permission)
INSERT INTO django_content_type VALUES(1,'polls','question');
INSERT INTO django_content_type VALUES(2,'polls','choice');
INSERT INTO django_content_type VALUES(3,'admin','logentry');
INSERT INTO django_content_type VALUES(4,'auth','permission');
INSERT INTO django_content_type VALUES(5,'auth','group');
INSERT INTO django_content_type VALUES(6,'auth','user');
INSERT INTO django_content_type VALUES(7,'contenttypes','contenttype');
INSERT INTO django_content_type VALUES(8,'sessions','session');
INSERT INTO django_content_type VALUES(9,'polls','vote');

-- Insert auth_permission data (now that django_content_type has data)
INSERT INTO auth_permission VALUES(1,1,'add_question','Can add question');
INSERT INTO auth_permission VALUES(2,1,'change_question','Can change question');
INSERT INTO auth_permission VALUES(3,1,'delete_question','Can delete question');
INSERT INTO auth_permission VALUES(4,1,'view_question','Can view question');
INSERT INTO auth_permission VALUES(5,2,'add_choice','Can add choice');
INSERT INTO auth_permission VALUES(6,2,'change_choice','Can change choice');
INSERT INTO auth_permission VALUES(7,2,'delete_choice','Can delete choice');
INSERT INTO auth_permission VALUES(8,2,'view_choice','Can view choice');
INSERT INTO auth_permission VALUES(9,3,'add_logentry','Can add log entry');
INSERT INTO auth_permission VALUES(10,3,'change_logentry','Can change log entry');
INSERT INTO auth_permission VALUES(11,3,'delete_logentry','Can delete log entry');
INSERT INTO auth_permission VALUES(12,3,'view_logentry','Can view log entry');
INSERT INTO auth_permission VALUES(13,4,'add_permission','Can add permission');
INSERT INTO auth_permission VALUES(14,4,'change_permission','Can change permission');
INSERT INTO auth_permission VALUES(15,4,'delete_permission','Can delete permission');
INSERT INTO auth_permission VALUES(16,4,'view_permission','Can view permission');
INSERT INTO auth_permission VALUES(17,5,'add_group','Can add group');
INSERT INTO auth_permission VALUES(18,5,'change_group','Can change group');
INSERT INTO auth_permission VALUES(19,5,'delete_group','Can delete group');
INSERT INTO auth_permission VALUES(20,5,'view_group','Can view group');
INSERT INTO auth_permission VALUES(21,6,'add_user','Can add user');
INSERT INTO auth_permission VALUES(22,6,'change_user','Can change user');
INSERT INTO auth_permission VALUES(23,6,'delete_user','Can delete user');
INSERT INTO auth_permission VALUES(24,6,'view_user','Can view user');
INSERT INTO auth_permission VALUES(25,7,'add_contenttype','Can add content type');
INSERT INTO auth_permission VALUES(26,7,'change_contenttype','Can change content type');
INSERT INTO auth_permission VALUES(27,7,'delete_contenttype','Can delete content type');
INSERT INTO auth_permission VALUES(28,7,'view_contenttype','Can view content type');
INSERT INTO auth_permission VALUES(29,8,'add_session','Can add session');
INSERT INTO auth_permission VALUES(30,8,'change_session','Can change session');
INSERT INTO auth_permission VALUES(31,8,'delete_session','Can delete session');
INSERT INTO auth_permission VALUES(32,8,'view_session','Can view session');
INSERT INTO auth_permission VALUES(33,9,'add_vote','Can add vote');
INSERT INTO auth_permission VALUES(34,9,'change_vote','Can change vote');
INSERT INTO auth_permission VALUES(35,9,'delete_vote','Can delete vote');
INSERT INTO auth_permission VALUES(36,9,'view_vote','Can view vote');

-- Insert other data
INSERT INTO auth_user VALUES(1,'pbkdf2_sha256$1000000$BPH4PGnSvzLPX6uFLNukIM$qYCgFv2dRb1U7R9dM8rjzkgvVBT/rK4v4uomqpcMyWI=','2025-10-23 16:11:11.588687',true,'lithaxanti','','lithaxanti11@gmail.com',true,true,'2025-10-23 12:17:37.537091','');

INSERT INTO django_migrations VALUES(1,'contenttypes','0001_initial','2025-10-23 12:16:26.749293');
INSERT INTO django_migrations VALUES(2,'auth','0001_initial','2025-10-23 12:16:26.753193');
INSERT INTO django_migrations VALUES(3,'admin','0001_initial','2025-10-23 12:16:26.756202');
INSERT INTO django_migrations VALUES(4,'admin','0002_logentry_remove_auto_add','2025-10-23 12:16:26.759987');
INSERT INTO django_migrations VALUES(5,'admin','0003_logentry_add_action_flag_choices','2025-10-23 12:16:26.761989');
INSERT INTO django_migrations VALUES(6,'contenttypes','0002_remove_content_type_name','2025-10-23 12:16:26.767415');
INSERT INTO django_migrations VALUES(7,'auth','0002_alter_permission_name_max_length','2025-10-23 12:16:26.770127');
INSERT INTO django_migrations VALUES(8,'auth','0003_alter_user_email_max_length','2025-10-23 12:16:26.772570');
INSERT INTO django_migrations VALUES(9,'auth','0004_alter_user_username_opts','2025-10-23 12:16:26.775006');
INSERT INTO django_migrations VALUES(10,'auth','0005_alter_user_last_login_null','2025-10-23 12:16:26.777748');
INSERT INTO django_migrations VALUES(11,'auth','0006_require_contenttypes_0002','2025-10-23 12:16:26.778067');
INSERT INTO django_migrations VALUES(12,'auth','0007_alter_validators_add_error_messages','2025-10-23 12:16:26.780176');
INSERT INTO django_migrations VALUES(13,'auth','0008_alter_user_username_max_length','2025-10-23 12:16:26.783288');
INSERT INTO django_migrations VALUES(14,'auth','0009_alter_user_last_name_max_length','2025-10-23 12:16:26.785978');
INSERT INTO django_migrations VALUES(15,'auth','0010_alter_group_name_max_length','2025-10-23 12:16:26.788725');
INSERT INTO django_migrations VALUES(16,'auth','0011_update_proxy_permissions','2025-10-23 12:16:26.790366');
INSERT INTO django_migrations VALUES(17,'auth','0012_alter_user_first_name_max_length','2025-10-23 12:16:26.793032');
INSERT INTO django_migrations VALUES(18,'polls','0001_initial','2025-10-23 12:16:26.794311');
INSERT INTO django_migrations VALUES(19,'sessions','0001_initial','2025-10-23 12:16:26.795163');
INSERT INTO django_migrations VALUES(20,'polls','0002_vote','2025-10-23 15:46:59.758696');
INSERT INTO django_migrations VALUES(21,'polls','0003_remove_question_is_active_delete_vote','2025-10-23 17:51:23.855545');

INSERT INTO django_admin_log VALUES(1,'1','What is your favourite ice cream flavour?',1,'[{"added": {}}, {"added": {"name": "choice", "object": "Vanilla"}}, {"added": {"name": "choice", "object": "Chocolate"}}, {"added": {"name": "choice", "object": "Strawberry"}}]',1,1,'2025-10-23 17:53:28.035024');

INSERT INTO polls_question VALUES(1,'What is your favourite ice cream flavour?','2025-10-23 17:53:23');

INSERT INTO polls_choice VALUES(1,'Vanilla',0,1);
INSERT INTO polls_choice VALUES(2,'Chocolate',1,1);
INSERT INTO polls_choice VALUES(3,'Strawberry',2,1);

INSERT INTO django_session VALUES('phi2hkj24nglxco1kwp4w9eksdh3uzms','.eJxVjMsOwiAQRf-FtSFAZ3i4dN9vIAOMUjU0Ke3K-O_apAvd3nPOfYlI21rj1nmJUxFnocXpd0uUH9x2UO7UbrPMc1uXKcldkQftcpwLPy-H-3dQqddvPYSiPQaTCQwwosoetL3qgFmRJQPWFRyQEkNgtMCsSWWnUXllHIJ4fwC8-Tas:1vBxuB:TF2f9sa2D9D5gdfs-tW0_VwOssbiVVhThBjEpGM6zek','2025-11-06 16:11:11.589372');

-- Create indexes
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" ("group_id", "permission_id");
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" ("group_id");
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" ("permission_id");

CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" ("user_id", "group_id");
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" ("user_id");
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" ("group_id");

CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" ("user_id", "permission_id");
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" ("user_id");
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" ("permission_id");

CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" ("content_type_id");
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" ("user_id");

CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" ("app_label", "model");

CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" ("content_type_id", "codename");
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" ("content_type_id");

CREATE INDEX IF NOT EXISTS "polls_choice_question_id_c5b4b260" ON "polls_choice" ("question_id");

CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" ("expire_date");

-- Reset sequence values
SELECT setval('django_migrations_id_seq', 21, true);
SELECT setval('django_admin_log_id_seq', 1, true);
SELECT setval('django_content_type_id_seq', 9, true);
SELECT setval('auth_permission_id_seq', 36, true);
SELECT setval('auth_group_id_seq', 1, false);
SELECT setval('auth_user_id_seq', 1, true);
SELECT setval('polls_question_id_seq', 1, true);
SELECT setval('polls_choice_id_seq', 3, true);

-- Re-enable foreign key checks
SET session_replication_role = 'origin';

COMMIT;