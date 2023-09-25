// Query 1
// Users who have rated a classic or fantasy book with a rating of at least 4
MATCH (u:User)-[r1:HAS_RATED]->(b:Book)-[r2:HAS_GENRE]->(g:Genre)
WHERE (r1.rank>=4 AND g.genre="classic") OR (r1.rank>=4 AND g.genre="fantasy")
RETURN u.name, u.surname, b.title, r1.rank

// Query 2
// Users who have borrowed at least three different books sorted in descending order by the books borrowed
MATCH (u:User)-[:HAS_BORROWED]->(b:Book) 
WITH u, count(DISTINCT b) AS has_borrowed
WHERE has_borrowed>=3
RETURN u.name + ' ' + u.surname AS fullName, has_borrowed
ORDER BY has_borrowed DESC

// Query 3
// The books that have not been borrowed and have not been rated
MATCH (b:Book)-[:HAS_GENRE]->(g:Genre)
WHERE NOT (()-[:HAS_BORROWED]->(b)) AND NOT (()-[:HAS_RATED]->(b))
RETURN DISTINCT b.title AS title, REDUCE(genres = '', genre IN COLLECT(g.genre) | genres + genre + ', ') AS genres

// Query 4
// Recommend Gary Oldman books rated>3 by users who borrowed the same books as him, and which he hasn't read (borrowed or rated himself)
MATCH (u1:User {name:"Gary", surname:"Oldman"})-[:HAS_BORROWED]->(b1:Book)<-[:HAS_BORROWED]-(u2:User)
MATCH (u2)-[r:HAS_RATED]->(b2:Book)
WHERE r.rank>3 AND NOT EXISTS((u1)-[:HAS_BORROWED]->(b2)) AND NOT EXISTS((u1)-[:HAS_RATED]->(b2))
RETURN DISTINCT u2.name + ' ' + u2.surname AS fullName, b2.title AS recommendedBook, r.rank AS rank
ORDER BY fullName ASC

// Query 5
// For each publishing house, the number of books it has published by genre in alphabetical order by publisher and genre
MATCH (g:Genre)<-[:HAS_GENRE]-(b:Book)-[:HAS_EDITOR]->(e:Editor)
WITH e, g, count(b) AS published_books
RETURN e.publisher AS publisher, g.genre AS genre, published_books
ORDER BY publisher, genre

// Query 6
// Authors and publishers who are within a distance of 4 of Gabriel Byrne
MATCH (e:Editor)-[*..4]-(u:User {name:"Gabriel", surname:"Byrne"})
MATCH (a:Author)-[*..4]-(u)
RETURN DISTINCT e, a


// Query 7
// Give the shortest path between all user pairs, for users with a first name starting with 'B'
// Display the pairs starting from the one with the shortest path to the one with the longest
MATCH path=shortestPath((u1:User)-[*]-(u2:User))
WHERE substring(u1.name,0,1)="B" AND substring(u2.name,0,1)="B" AND u1.id>u2.id
RETURN u1.name + ' ' + u1.surname AS user1, u2.name + ' ' + u2.surname AS user2, length(path) AS length
ORDER BY length ASC


// Query 8
// Find the pair of users who have borrowed the most shared books
MATCH (u1:User)-[:HAS_BORROWED]->(b:Book)<-[:HAS_BORROWED]-(u2:User)
WITH u1, u2, count(b) AS sharedBooks
WHERE u1.id>u2.id
RETURN u1.name + ' ' + u1.surname AS user1, u2.name + ' ' + u2.surname AS user2, sharedBooks
ORDER BY sharedBooks DESC
LIMIT 1


// Query 9
// For books that have at least 3 genres, the number of users who have borrowed them
MATCH (u:User), (b:Book)-[:HAS_GENRE]->(g:Genre)
WITH b, u, count(g) AS belongs
WHERE belongs>=3 AND (u)-[:HAS_BORROWED]->(b)
RETURN b.title AS title, count(u) AS users


// Query 10
// Users who have borrowed a book that Al Pacino has read, but neither Bill Murray nor Brad Pitt has
MATCH (u1:User {name:"Al", surname:"Pacino"})-[:HAS_BORROWED]->(b:Book)<-[:HAS_BORROWED]-(u2:User)
WHERE NOT EXISTS((:User {name:"Bill", surname:"Murray"})-[:HAS_RATED]->(b)) AND NOT EXISTS((:User {name:"Brad", surname:"Pitt"})-[:HAS_RATED]->(b))
RETURN DISTINCT u2.name + ' ' + u2.surname AS fullName, b.title AS title
