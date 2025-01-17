DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS Screenshots;
DROP TABLE IF EXISTS Tags;
DROP TABLE IF EXISTS BugsProducts;
DROP TABLE IF EXISTS Bugs;
DROP TABLE IF EXISTS BugStatus;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Products;

CREATE TABLE Accounts (
  account_id        SERIAL PRIMARY KEY,
  account_name      VARCHAR(20),
  first_name        VARCHAR(20),
  last_name         VARCHAR(20),
  email             VARCHAR(100),
  password_hash     CHAR(64),
  portrait_image    BYTEA,
  hourly_rate       NUMERIC(9,2)
);

CREATE TABLE BugStatus (
  status            VARCHAR(20) PRIMARY KEY
);

CREATE TABLE Bugs (
  bug_id            SERIAL PRIMARY KEY,
  date_reported     DATE NOT NULL DEFAULT CURRENT_DATE,
  summary           VARCHAR(80),
  description       VARCHAR(1000),
  resolution        VARCHAR(1000),
  reported_by       BIGINT NOT NULL CHECK (reported_by >= 0),
  assigned_to       BIGINT CHECK (assigned_to >= 0),
  verified_by       BIGINT CHECK (verified_by >= 0),
  status            VARCHAR(20) NOT NULL DEFAULT 'NEW',
  priority          VARCHAR(20),
  hours             NUMERIC(9,2),
  FOREIGN KEY (reported_by) REFERENCES Accounts(account_id),
  FOREIGN KEY (assigned_to) REFERENCES Accounts(account_id),
  FOREIGN KEY (verified_by) REFERENCES Accounts(account_id),
  FOREIGN KEY (status) REFERENCES BugStatus(status)
);


CREATE TABLE Comments (
  comment_id        SERIAL PRIMARY KEY,
  bug_id            BIGINT NOT NULL CHECK (bug_id >= 0),
  author            BIGINT NOT NULL CHECK (author >= 0),
  comment_date      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  comment           TEXT NOT NULL,
  FOREIGN KEY (bug_id) REFERENCES Bugs(bug_id),
  FOREIGN KEY (author) REFERENCES Accounts(account_id)
);

CREATE TABLE Screenshots (
  bug_id            BIGINT NOT NULL CHECK (bug_id >= 0),
  image_id          BIGINT NOT NULL CHECK (image_id >= 0),
  screenshot_image  BYTEA,
  caption           VARCHAR(100),
  PRIMARY KEY      (bug_id, image_id),
  FOREIGN KEY (bug_id) REFERENCES Bugs(bug_id)
);

CREATE TABLE Tags (
  bug_id            BIGINT NOT NULL CHECK (bug_id >= 0),
  tag               VARCHAR(20) NOT NULL,
  PRIMARY KEY      (bug_id, tag),
  FOREIGN KEY (bug_id) REFERENCES Bugs(bug_id)
);

CREATE TABLE Products (
  product_id        SERIAL PRIMARY KEY,
  product_name      VARCHAR(50)
);

CREATE TABLE BugsProducts(
  bug_id            BIGINT NOT NULL CHECK (bug_id >= 0),
  product_id        BIGINT NOT NULL CHECK (product_id >= 0),
  PRIMARY KEY      (bug_id, product_id),
  FOREIGN KEY (bug_id) REFERENCES Bugs(bug_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Accounts (account_id, account_name, email) VALUES
  (1, 'moe', 'moe@example.com'),
  (2, 'larry', 'larry@example.com'),
  (3, 'curly', 'curley@example.com'),
  (4, 'shemp', 'shemp@example.com');

INSERT INTO Products (product_id, product_name) VALUES
  (1, 'Open RoundFile'),
  (2, 'Visual TurboBuilder'),
  (3, 'ReConsider');

INSERT INTO BugStatus (status) VALUES ('NEW'), ('IN PROGRESS'), ('CODE COMPLETE'), ('VERIFIED'), ('FIXED'), ('DUPLICATE'), ('WONTFIX');

INSERT INTO Bugs (bug_id, summary, reported_by) VALUES
  (1234, 'crash when I save', 4),
  (2345, 'increase performance', 3),
  (3456, 'screen goes blank', 4),
  (5678, 'unknown conflict between products', 2);

INSERT INTO BugsProducts (bug_id, product_id) VALUES
  (1234, 1),
  (1234, 3),
  (3456, 2),
  (5678, 1),
  (5678, 3);

INSERT INTO Comments (comment_id, bug_id, author, comment) VALUES
  (6789, 1234, 4, 'It crashes!'),
  (9876, 2345, 1, 'Great idea!');

INSERT INTO Tags (bug_id, tag) VALUES
  (1234, 'crash'),
  (1234, 'save'),
  (1234, 'version-3.0'),
  (1234, 'windows');
