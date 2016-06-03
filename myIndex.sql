drop index myindex3;
drop index myindex4;

CREATE INDEX myindex3 ON radiology_record(diagnosis) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX myindex4 ON radiology_record(description) INDEXTYPE IS CTXSYS.CONTEXT;
