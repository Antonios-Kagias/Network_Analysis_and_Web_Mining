CREATE CONSTRAINT userIdConstraint FOR (u:User) REQUIRE u.id IS UNIQUE
CREATE CONSTRAINT bookTitleConstraint FOR (b:Book) REQUIRE b.title IS UNIQUE
CREATE CONSTRAINT publisherConstraint FOR (e:Editor) REQUIRE e.publisher IS UNIQUE
CREATE CONSTRAINT authorConstraint FOR (a:Author) REQUIRE a.author IS UNIQUE
CREATE INDEX FOR (g:Genre) ON (g.genre)

// Load users
LOAD CSV WITH HEADERS FROM "file:///users.csv" AS csvLine
CREATE (u:User {id: toInteger(csvLine.id), name: csvLine.Name, surname: csvLine.Surname, birthdate: csvLine.BirthDate})


// Load books
LOAD CSV WITH HEADERS FROM "file:///books.csv" AS csvLine
MERGE (editor:Editor {publisher: csvLine.edition})
MERGE (author:Author {author: csvLine.author})
CREATE (book:Book {title:csvLine.title, year_written:toInteger(csvLine.year_written), price:toFloat(csvLine.price)})
CREATE (book)-[:HAS_EDITOR]->(editor)
CREATE (book)-[:HAS_AUTHOR]->(author)


// Load editors
LOAD CSV WITH HEADERS FROM "file:///editors.csv" AS csvLine
CREATE (e:Editor {publisher:csvLine.publisher, address: csvLine.address})


// Load genres
LOAD CSV WITH HEADERS FROM "file:///genres.csv" AS csvLine
MERGE (book:Book {title: csvLine.title})
MERGE (genre:Genre {genre:csvLine.genre})
CREATE (book)-[:HAS_GENRE]->(genre)


// Load borrowed
:auto LOAD CSV WITH HEADERS FROM 'file:///borrowed.csv' AS csvLine
CALL {
 WITH csvLine   
 MATCH (u:User {id: toInteger(csvLine.userid)}), (b:Book {title: csvLine.title})
CREATE (u)-[:HAS_BORROWED {date: csvLine.date}]->(b)
} IN TRANSACTIONS OF 2 ROWS


// Load rated
:auto LOAD CSV WITH HEADERS FROM 'file:///rated.csv' AS csvLine
CALL {
 WITH csvLine   
 MATCH (u:User {id: toInteger(csvLine.userid)}), (b:Book {title: csvLine.title})
CREATE (u)-[:HAS_RATED {rank: toFloat(csvLine.rank)}]->(b)
} IN TRANSACTIONS OF 2 ROWS
