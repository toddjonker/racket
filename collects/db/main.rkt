#lang racket/base
(require (for-syntax racket/base)
         "private/generic/lazy-require.rkt"
         racket/runtime-path
         racket/promise
         racket/contract
         "base.rkt")
(provide (all-from-out "base.rkt"))

(define-lazy-require-definer define-postgresql "private/postgresql/main.rkt")
(define-lazy-require-definer define-mysql "private/mysql/main.rkt")
(define-lazy-require-definer define-sqlite3 "private/sqlite3/main.rkt")
(define-lazy-require-definer define-odbc "private/odbc/main.rkt")
(define-lazy-require-definer define-openssl 'openssl)

(define-postgresql
  postgresql-connect
  postgresql-guess-socket-path
  postgresql-password-hash)

(define-mysql
  mysql-connect
  mysql-guess-socket-path
  mysql-password-hash)

(define-sqlite3
  sqlite3-connect)

(define-odbc
  odbc-connect
  odbc-driver-connect
  odbc-data-sources
  odbc-drivers)

(define-openssl
  ssl-client-context?)

(provide/contract
 ;; Duplicates contracts at postgresql.rkt
 [postgresql-connect
  (->* (#:user string?
        #:database string?)
       (#:password (or/c string? (list/c 'hash string?) #f)
        #:server (or/c string? #f)
        #:port (or/c exact-positive-integer? #f)
        #:socket (or/c path-string? 'guess #f)
        #:allow-cleartext-password? boolean?
        #:ssl (or/c 'yes 'no 'optional)
        #:ssl-context ssl-client-context?
        #:notice-handler (or/c 'output 'error output-port? procedure?)
        #:notification-handler (or/c 'output 'error output-port? procedure?))
       any/c)]
 [postgresql-guess-socket-path
  (-> path-string?)]
 [postgresql-password-hash
  (-> string? string? string?)]

 ;; Duplicates contracts at mysql.rkt
 [mysql-connect
  (->* (#:user string?
        #:database string?)
       (#:password (or/c string? (list/c 'hash string?) #f)
        #:server (or/c string? #f)
        #:port (or/c exact-positive-integer? #f)
        #:socket (or/c path-string? 'guess #f)
        #:notice-handler (or/c 'output 'error output-port? procedure?))
       any/c)]
 [mysql-guess-socket-path
  (-> path-string?)]
 [mysql-password-hash
  (-> string? string?)]

 ;; Duplicates contracts at sqlite3.rkt
 [sqlite3-connect
  (->* (#:database (or/c path-string? 'memory 'temporary))
       (#:mode (or/c 'read-only 'read/write 'create)
        #:busy-retry-limit (or/c exact-nonnegative-integer? +inf.0)
        #:busy-retry-delay (and/c rational? (not/c negative?)))
       any/c)]

 ;; Duplicates contracts at odbc.rkt
 [odbc-connect
  (->* (#:dsn (or/c string? #f))
       (#:user (or/c string? #f)
        #:password (or/c string? #f)
        #:notice-handler (or/c 'output 'error output-port? procedure?)
        #:strict-parameter-types? boolean?
        #:character-mode (or/c 'wchar 'utf-8 'latin-1))
       connection?)]
 [odbc-driver-connect
  (->* (string?)
       (#:notice-handler (or/c 'output 'error output-port? procedure?)
        #:strict-parameter-types? boolean?
        #:character-mode (or/c 'wchar 'utf-8 'latin-1))
       connection?)]
 [odbc-data-sources
  (-> (listof (list/c string? string?)))]
 [odbc-drivers
  (-> (listof (cons/c string? any/c)))])