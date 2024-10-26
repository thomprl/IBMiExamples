CREATE TABLE QTEMP.JSON_DATA (
    ID INT GENERATED ALWAYS AS IDENTITY,
    JSON_DOC CLOB
);

INSERT INTO QTEMP.JSON_DATA (JSON_DOC) VALUES (
    '{
        "data": [
            {
                "FirstName": "John",
                "LastName": "Doe",
                "City": "Paramus",
                "State": "NJ",
                "Zip code": "07082",
                "Date of birth": "11/12/1952",
                "Favorite color": "Blue"
            },
            {
                "FirstName": "Jane",
                "LastName": "Doe",
                "City": "Milford",
                "State": "PA",
                "Zip code": "08596",
                "Date of birth": "02/23/1945",
                "Favorite color": "Red"
            },
            {
                "FirstName": "Harry",
                "LastName": "Henderson",
                "City": "Palm Springs",
                "State": "CA",
                "Zip code": "90258",
                "Date of birth": "05/25/1925",
                "Favorite color": ""
            },
            {
                "FirstName": "Juli",
                "LastName": "Ambrose",
                "City": "Austin",
                "State": "TX",
                "Zip code": "85247",
                "Date of birth": "09/01/1985",
                "Favorite color": ""
            },
            {
                "FirstName": "Ron",
                "LastName": "Nettles",
                "City": "Virginia Beach",
                "State": "VA",
                "Zip code": "09874",
                "Date of birth": "07/30/1971",
                "Favorite color": "Orange"
            },
            {
                "FirstName": "Betty",
                "LastName": "Winn",
                "City": "Rochester Hills",
                "State": "MI",
                "Zip code": "02547",
                "Date of birth": "11/01/1990",
                "Favorite color": "Brown"
            }
        ]
    }'
);

SELECT JT.*
FROM qtemp.JSON_DATA,
     JSON_TABLE(
         JSON_DATA.JSON_DOC,
         '$.data[*]'
         COLUMNS (
             FirstName VARCHAR(50) PATH '$.FirstName',
             LastName VARCHAR(50) PATH '$.LastName',
             City VARCHAR(50) PATH '$.City',
             State VARCHAR(2) PATH '$.State',
             ZipCode VARCHAR(10) PATH '$."Zip code"',
             DateOfBirth DATE  PATH '$."Date of birth"',
             FavoriteColor VARCHAR(50) PATH '$."Favorite color"'
         )
     ) AS JT;