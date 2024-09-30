import pyodbc
import getpass
from tabulate import tabulate

username = input("Enter username: ")
password = getpass.getpass("Enter password: ")

myIBMi = "myas400"

cnxn = pyodbc.connect(f'DRIVER={{IBM i Access ODBC Driver}};SYSTEM={myIBMi};UID={username};PWD={password}')
cursor = cnxn.cursor() 

cursor.execute("select * from qiws.qcustcdt")
rows = cursor.fetchall()

# Fetch column names
columns = [column[0] for column in cursor.description]

#for row in rows:
#    print(row)

# Print the rows in a text table
print(tabulate(rows, headers=columns, tablefmt="grid"))