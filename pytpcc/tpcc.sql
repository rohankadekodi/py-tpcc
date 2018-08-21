CREATE TABLE WAREHOUSE (
  W_ID SMALLINT DEFAULT '0' NOT NULL,
  W_NAME VARCHAR(16) DEFAULT NULL,
  W_STREET_1 VARCHAR(32) DEFAULT NULL,
  W_STREET_2 VARCHAR(32) DEFAULT NULL,
  W_CITY VARCHAR(32) DEFAULT NULL,
  W_STATE VARCHAR(2) DEFAULT NULL,
  W_ZIP VARCHAR(9) DEFAULT NULL,
  W_TAX FLOAT DEFAULT NULL,
  W_YTD FLOAT DEFAULT NULL,
  CONSTRAINT W_PK_ARRAY PRIMARY KEY (W_ID)
);

CREATE TABLE DISTRICT (
  D_ID TINYINT DEFAULT '0' NOT NULL,
  D_W_ID SMALLINT DEFAULT '0' NOT NULL REFERENCES WAREHOUSE (W_ID),
  D_NAME VARCHAR(16) DEFAULT NULL,
  D_STREET_1 VARCHAR(32) DEFAULT NULL,
  D_STREET_2 VARCHAR(32) DEFAULT NULL,
  D_CITY VARCHAR(32) DEFAULT NULL,
  D_STATE VARCHAR(2) DEFAULT NULL,
  D_ZIP VARCHAR(9) DEFAULT NULL,
  D_TAX FLOAT DEFAULT NULL,
  D_YTD FLOAT DEFAULT NULL,
  D_NEXT_O_ID INT DEFAULT NULL,
  PRIMARY KEY (D_W_ID,D_ID)
);

CREATE TABLE ITEM (
  I_ID INTEGER DEFAULT '0' NOT NULL,
  I_IM_ID INTEGER DEFAULT NULL,
  I_NAME VARCHAR(32) DEFAULT NULL,
  I_PRICE FLOAT DEFAULT NULL,
  I_DATA VARCHAR(64) DEFAULT NULL,
  CONSTRAINT I_PK_ARRAY PRIMARY KEY (I_ID)
);

CREATE TABLE CUSTOMER (
  C_ID INTEGER DEFAULT '0' NOT NULL,
  C_D_ID TINYINT DEFAULT '0' NOT NULL,
  C_W_ID SMALLINT DEFAULT '0' NOT NULL,
  C_FIRST VARCHAR(32) DEFAULT NULL,
  C_MIDDLE VARCHAR(2) DEFAULT NULL,
  C_LAST VARCHAR(32) DEFAULT NULL,
  C_STREET_1 VARCHAR(32) DEFAULT NULL,
  C_STREET_2 VARCHAR(32) DEFAULT NULL,
  C_CITY VARCHAR(32) DEFAULT NULL,
  C_STATE VARCHAR(2) DEFAULT NULL,
  C_ZIP VARCHAR(9) DEFAULT NULL,
  C_PHONE VARCHAR(32) DEFAULT NULL,
  C_SINCE TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  C_CREDIT VARCHAR(2) DEFAULT NULL,
  C_CREDIT_LIM FLOAT DEFAULT NULL,
  C_DISCOUNT FLOAT DEFAULT NULL,
  C_BALANCE FLOAT DEFAULT NULL,
  C_YTD_PAYMENT FLOAT DEFAULT NULL,
  C_PAYMENT_CNT INTEGER DEFAULT NULL,
  C_DELIVERY_CNT INTEGER DEFAULT NULL,
  C_DATA VARCHAR(500),
  PRIMARY KEY (C_W_ID,C_D_ID,C_ID),
  UNIQUE (C_W_ID,C_D_ID,C_LAST,C_FIRST),
  CONSTRAINT C_FKEY_D FOREIGN KEY (C_D_ID, C_W_ID) REFERENCES DISTRICT (D_ID, D_W_ID)
);
CREATE INDEX IDX_CUSTOMER ON CUSTOMER (C_W_ID,C_D_ID,C_LAST);

CREATE TABLE HISTORY (
  H_C_ID INTEGER DEFAULT NULL,
  H_C_D_ID TINYINT DEFAULT NULL,
  H_C_W_ID SMALLINT DEFAULT NULL,
  H_D_ID TINYINT DEFAULT NULL,
  H_W_ID SMALLINT DEFAULT '0' NOT NULL,
  H_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  H_AMOUNT FLOAT DEFAULT NULL,
  H_DATA VARCHAR(32) DEFAULT NULL,
  CONSTRAINT H_FKEY_C FOREIGN KEY (H_C_ID, H_C_D_ID, H_C_W_ID) REFERENCES CUSTOMER (C_ID, C_D_ID, C_W_ID),
  CONSTRAINT H_FKEY_D FOREIGN KEY (H_D_ID, H_W_ID) REFERENCES DISTRICT (D_ID, D_W_ID)
);

CREATE TABLE STOCK (
  S_I_ID INTEGER DEFAULT '0' NOT NULL REFERENCES ITEM (I_ID),
  S_W_ID SMALLINT DEFAULT '0 ' NOT NULL REFERENCES WAREHOUSE (W_ID),
  S_QUANTITY INTEGER DEFAULT '0' NOT NULL,
  S_DIST_01 VARCHAR(32) DEFAULT NULL,
  S_DIST_02 VARCHAR(32) DEFAULT NULL,
  S_DIST_03 VARCHAR(32) DEFAULT NULL,
  S_DIST_04 VARCHAR(32) DEFAULT NULL,
  S_DIST_05 VARCHAR(32) DEFAULT NULL,
  S_DIST_06 VARCHAR(32) DEFAULT NULL,
  S_DIST_07 VARCHAR(32) DEFAULT NULL,
  S_DIST_08 VARCHAR(32) DEFAULT NULL,
  S_DIST_09 VARCHAR(32) DEFAULT NULL,
  S_DIST_10 VARCHAR(32) DEFAULT NULL,
  S_YTD INTEGER DEFAULT NULL,
  S_ORDER_CNT INTEGER DEFAULT NULL,
  S_REMOTE_CNT INTEGER DEFAULT NULL,
  S_DATA VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (S_W_ID,S_I_ID)
);

CREATE TABLE ORDERS (
  O_ID INTEGER DEFAULT '0' NOT NULL,
  O_C_ID INTEGER DEFAULT NULL,
  O_D_ID TINYINT DEFAULT '0' NOT NULL,
  O_W_ID SMALLINT DEFAULT '0' NOT NULL,
  O_ENTRY_D TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  O_CARRIER_ID INTEGER DEFAULT NULL,
  O_OL_CNT INTEGER DEFAULT NULL,
  O_ALL_LOCAL INTEGER DEFAULT NULL,
  PRIMARY KEY (O_W_ID,O_D_ID,O_ID),
  UNIQUE (O_W_ID,O_D_ID,O_C_ID,O_ID),
  CONSTRAINT O_FKEY_C FOREIGN KEY (O_C_ID, O_D_ID, O_W_ID) REFERENCES CUSTOMER (C_ID, C_D_ID, C_W_ID)
);
CREATE INDEX IDX_ORDERS ON ORDERS (O_W_ID,O_D_ID,O_C_ID);

CREATE TABLE NEW_ORDER (
  NO_O_ID INTEGER DEFAULT '0' NOT NULL,
  NO_D_ID TINYINT DEFAULT '0' NOT NULL,
  NO_W_ID SMALLINT DEFAULT '0' NOT NULL,
  CONSTRAINT NO_PK_TREE PRIMARY KEY (NO_D_ID,NO_W_ID,NO_O_ID),
  CONSTRAINT NO_FKEY_O FOREIGN KEY (NO_O_ID, NO_D_ID, NO_W_ID) REFERENCES ORDERS (O_ID, O_D_ID, O_W_ID)
);

CREATE TABLE NEW_OPT_ORDER (
  NO_O_ID INTEGER DEFAULT '0' NOT NULL,
  NO_D_ID TINYINT DEFAULT '0' NOT NULL,
  NO_W_ID SMALLINT DEFAULT '0' NOT NULL,
  NO_C_ID INTEGER DEFAULT '0' NOT NULL,
  CONSTRAINT NO_PK_TREE PRIMARY KEY (NO_D_ID,NO_W_ID,NO_O_ID,NO_C_ID)
);

CREATE TABLE ORDER_LINE (
  OL_O_ID INTEGER DEFAULT '0' NOT NULL,
  OL_D_ID TINYINT DEFAULT '0' NOT NULL,
  OL_W_ID SMALLINT DEFAULT '0' NOT NULL,
  OL_NUMBER INTEGER DEFAULT '0' NOT NULL,
  OL_I_ID INTEGER DEFAULT NULL,
  OL_SUPPLY_W_ID SMALLINT DEFAULT NULL,
  OL_DELIVERY_D TIMESTAMP DEFAULT NULL,
  OL_QUANTITY INTEGER DEFAULT NULL,
  OL_AMOUNT FLOAT DEFAULT NULL,
  OL_DIST_INFO VARCHAR(32) DEFAULT NULL,
  PRIMARY KEY (OL_W_ID,OL_D_ID,OL_O_ID,OL_NUMBER),
  CONSTRAINT OL_FKEY_O FOREIGN KEY (OL_O_ID, OL_D_ID, OL_W_ID) REFERENCES ORDERS (O_ID, O_D_ID, O_W_ID),
  CONSTRAINT OL_FKEY_S FOREIGN KEY (OL_I_ID, OL_SUPPLY_W_ID) REFERENCES STOCK (S_I_ID, S_W_ID)
);
--CREATE INDEX IDX_ORDER_LINE_3COL ON ORDER_LINE (OL_W_ID,OL_D_ID,OL_O_ID);
--CREATE INDEX IDX_ORDER_LINE_2COL ON ORDER_LINE (OL_W_ID,OL_D_ID);
CREATE INDEX IDX_ORDER_LINE_TREE ON ORDER_LINE (OL_W_ID,OL_D_ID,OL_O_ID);
