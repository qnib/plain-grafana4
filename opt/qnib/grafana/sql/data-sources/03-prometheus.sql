PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

INSERT INTO "data_source" VALUES(3,1,0,'prometheus','prometheus','proxy','http://PROMETHEUS_HOST:PROMETHEUS_PORT','','','',0,'','',0,X'7B7D','2016-10-23 12:20:11','2016-10-23 12:20:25',0);

COMMIT;
