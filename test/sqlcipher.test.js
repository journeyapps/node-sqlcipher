var sqlite3 = require('..');
var assert = require('assert');
var fs = require('fs');
var helper = require('./support/helper');

describe('sqlcipher', function() {
    before(function() {
        helper.ensureExists('test/tmp');
    });

    before(function() {
        helper.deleteFile('test/tmp/test_create.db.enc');
    });

    var db;
    it('should open the database', function(done) {
        db = new sqlite3.Database('test/tmp/test_create.db.enc', done);
    });

    it('should enable encryption', function(done) {
        db.run("PRAGMA key = 'mysecret'", done);
    });


    it("should use openssl", function(done) {
        db.get("PRAGMA cipher_provider", (err, result) => {
            assert.deepEqual(result, { cipher_provider: 'openssl' });
            done(err);
        });
    });

    it('should create a table', function(done) {
        db.run("CREATE TABLE foo (id INT, num INT)", done);
    });

    it('should insert data', function(done) {
        var stmt = db.prepare("INSERT INTO foo (id, num) VALUES (?, ?)");
        stmt.run(1, 2, function() {
            stmt.finalize();
            done();
        });
    });

    it('should read the table', function(done) {
        db.run("SELECT * FROM foo", done);
    });

    it('should close the database', function(done) {
        db.close(done);
    });

    it('should have created the file', function() {
        assert.fileExists('test/tmp/test_create.db.enc');
    });

    it("should not be plaintext", function(done) {
        const buffer = fs.readFileSync("test/tmp/test_create.db.enc");
        const sqliteMagic = "SQLite format 3";
        const actual = buffer.slice(0, sqliteMagic.length).toString("utf8");
        if (actual == sqliteMagic) {
          // The file contains the header in plain-text.
          // This means it's definitely not encrypted.
          done(new Error("The database is not encrypted!"));
        } else {
          // Not necessarily encrypted, but at least we did a basic check.
          done();
        }
      });

    it('should open the database without a key', function(done) {
        db = new sqlite3.Database('test/tmp/test_create.db.enc', done);
    });

    it('should fail to read a table', function(done) {
        db.run("SELECT * FROM foo", function(err) {
            if (err) {
                assert.equal(err.message, 'SQLITE_NOTADB: file is not a database');
                assert.equal(err.errno, sqlite3.NOTADB);
                assert.equal(err.code, 'SQLITE_NOTADB');
                done();
            } else {
                done(new Error('Completed query without error, but expected SQLITE_NOTADB'));
            }
        });
    });

    it('should close the database', function(done) {
        db.close(done);
    });

    it('should open the database again', function(done) {
        db = new sqlite3.Database('test/tmp/test_create.db.enc', done);
    });

    it('should set the same key', function(done) {
        db.run("PRAGMA key = 'mysecret'", done);
    });

    it('should read the table', function(done) {
        db.run("SELECT * FROM foo", done);
    });

    it('should close the database', function(done) {
        db.close(done);
    });

    after(function() {
        helper.deleteFile('test/tmp/test_create.db.enc');
    });
});
