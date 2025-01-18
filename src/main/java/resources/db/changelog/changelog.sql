-- liquibase formatted sql

-- changeset harikrishna:1736797346493-1
-- preconditions onFail:MARK_RAN onError:HALT
-- precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'account'
CREATE TABLE account (
    id BIGINT AUTO_INCREMENT NOT NULL,
    balance DECIMAL(38, 2) NULL,
    password VARCHAR(255) NULL,
    username VARCHAR(255) NULL,
    CONSTRAINT PK_ACCOUNT PRIMARY KEY (id)
);
-- rollback DROP TABLE account;

-- changeset harikrishna:1736797586983-1
-- preconditions onFail:MARK_RAN onError:HALT
-- precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM account WHERE username = 'admin'
INSERT INTO account (id, balance, password, username)
VALUES 
    (1, 0.00, '$2a$10$zqxpla02QN3erVUX9czsKuVSpU4Gjv3exMXjl.kDVd03QIN2/k34O', 'admin');
-- rollback DELETE FROM account WHERE username = 'admin';

-- changeset harikrishna:1736797346493-2
-- preconditions onFail:MARK_RAN onError:HALT
-- precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'transaction'
CREATE TABLE transaction (
    id BIGINT AUTO_INCREMENT NOT NULL,
    amount DECIMAL(38, 2) NULL,
    timestamp DATETIME NULL,
    type VARCHAR(255) NULL,
    account_id BIGINT NULL,
    CONSTRAINT PK_TRANSACTION PRIMARY KEY (id)
);
-- rollback DROP TABLE transaction;

-- changeset harikrishna:1736797346493-3
-- preconditions onFail:MARK_RAN onError:HALT
-- precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.statistics WHERE table_name = 'transaction' AND index_name = 'FK6g20fcr3bhr6bihgy24rq1r1b'
CREATE INDEX FK6g20fcr3bhr6bihgy24rq1r1b ON transaction(account_id);
-- rollback DROP INDEX FK6g20fcr3bhr6bihgy24rq1r1b ON transaction;

-- changeset harikrishna:1736797346493-4
-- preconditions onFail:MARK_RAN onError:HALT
-- precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_name = 'transaction' AND constraint_name = 'FK6g20fcr3bhr6bihgy24rq1r1b'
ALTER TABLE transaction
ADD CONSTRAINT FK6g20fcr3bhr6bihgy24rq1r1b
FOREIGN KEY (account_id) REFERENCES account (id)
ON UPDATE RESTRICT ON DELETE RESTRICT;
-- rollback ALTER TABLE transaction DROP CONSTRAINT FK6g20fcr3bhr6bihgy24rq1r1b;

-- changeset harikrishna:1736797346493-5
-- preconditions onFail:MARK_RAN onError:HALT
-- precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'account' AND column_name = 'email'
ALTER TABLE account ADD COLUMN email VARCHAR(255);
-- rollback ALTER TABLE account DROP COLUMN email;

-- changeset harikrishna:1736797346493-6
-- preconditions onFail:MARK_RAN onError:HALT
-- precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM transaction WHERE id = 1
INSERT INTO transaction (id, amount, timestamp, type, account_id)
VALUES (1, 500.00, '2025-01-14 10:00:00', 'credit', 1);
-- rollback DELETE FROM transaction WHERE id = 1;

