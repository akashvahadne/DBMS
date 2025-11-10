# **************************************
# PRACTICAL 8: Database Connectivity using Python + MySQL
# **************************************

import mysql.connector
from mysql.connector import Error, IntegrityError

# 1️⃣ Connect to MySQL Database
try:
    con = mysql.connector.connect(
        host="localhost",
        user="root",          # 🔑 Enter your MySQL username
        password="root123",      # 🔑 Enter your MySQL password
        database="collegeDB"  # ✅ Ensure this database exists
    )

    if con.is_connected():
        print("✅ Successfully connected to MySQL Database!\n")

except Error as e:
    print("❌ Connection Failed:", e)
    exit()

cursor = con.cursor()

# 2️⃣ Define CRUD Functions
def add_student():
    try:
        roll = int(input("Enter Roll No: "))
        name = input("Enter Name: ")
        city = input("Enter City: ")

        query = "INSERT INTO student (roll_no, name, city) VALUES (%s, %s, %s)"
        values = (roll, name, city)
        cursor.execute(query, values)
        con.commit()
        print("✅ Student added successfully!")

    except IntegrityError:
        print("⚠️ Error: Roll No already exists! Try a different one.")
    except ValueError:
        print("⚠️ Invalid input. Please enter valid Roll No.")
    except Error as e:
        print("⚠️ Database Error:", e)


def view_students():
    try:
        cursor.execute("SELECT * FROM student")
        result = cursor.fetchall()
        if not result:
            print("⚠️ No records found.")
            return
        print("\nRoll_No\tName\t\tCity")
        print("----------------------------")
        for row in result:
            print(f"{row[0]}\t{row[1]}\t\t{row[2]}")
    except Error as e:
        print("⚠️ Error while fetching records:", e)


def search_student():
    try:
        roll = int(input("Enter Roll No to Search: "))
        query = "SELECT * FROM student WHERE roll_no = %s"
        cursor.execute(query, (roll,))
        result = cursor.fetchone()
        if result:
            print(f"\n📘 Student Found:\nRoll No: {result[0]}\nName: {result[1]}\nCity: {result[2]}")
        else:
            print("❌ No student found with that Roll No.")
    except ValueError:
        print("⚠️ Invalid Roll No entered.")
    except Error as e:
        print("⚠️ Database Error:", e)


def update_student():
    try:
        roll = int(input("Enter Roll No to Update: "))
        new_city = input("Enter New City: ")

        query = "UPDATE student SET city = %s WHERE roll_no = %s"
        values = (new_city, roll)
        cursor.execute(query, values)
        con.commit()

        if cursor.rowcount > 0:
            print("✅ Student record updated successfully!")
        else:
            print("⚠️ Roll No not found!")

    except ValueError:
        print("⚠️ Invalid input! Roll No must be a number.")
    except Error as e:
        print("⚠️ Database Error:", e)


def delete_student():
    try:
        roll = int(input("Enter Roll No to Delete: "))
        query = "DELETE FROM student WHERE roll_no = %s"
        cursor.execute(query, (roll,))
        con.commit()

        if cursor.rowcount > 0:
            print("✅ Student record deleted successfully!")
        else:
            print("⚠️ Roll No not found!")

    except ValueError:
        print("⚠️ Invalid input! Roll No must be a number.")
    except Error as e:
        print("⚠️ Database Error:", e)

# 3️⃣ Menu-driven Program
while True:
    print("\n=== STUDENT DATABASE MENU ===")
    print("1. Add Student")
    print("2. View All Students")
    print("3. Search Student by Roll No")
    print("4. Update Student")
    print("5. Delete Student")
    print("6. Exit")

    choice = input("Enter your choice (1-6): ")

    if choice == '1':
        add_student()
    elif choice == '2':
        view_students()
    elif choice == '3':
        search_student()
    elif choice == '4':
        update_student()
    elif choice == '5':
        delete_student()
    elif choice == '6':
        print("👋 Exiting Program. Goodbye!")
        break
    else:
        print("❌ Invalid choice. Please try again.")

# 4️⃣ Close Cursor and Connection
cursor.close()
con.close()
print("\n🔒 Database connection closed.")
