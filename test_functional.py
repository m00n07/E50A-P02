import unittest
import psycopg2
import os
import csv

class TestFunctional(unittest.TestCase):

    def setUp(self):
        self.conn = psycopg2.connect(
            dbname="your_db",
            user="your_user",
            password="your_password",
            host="localhost",
            port="5432"
        )
        self.cursor = self.conn.cursor()
        insert_data()

    def tearDown(self):
        self.cursor.close()
        self.conn.close()

    def test_estudiante_data(self):
        self.cursor.execute("SELECT * FROM ESTUDIANTE")
        results = self.cursor.fetchall()
        expected = [
            (1, 'Juan', 'Pérez', '2000-05-10'),
            (2, 'María', 'González', '2001-02-20'),
            (3, 'Carlos', 'López', '1999-11-15')
        ]
        self.assertEqual(results, expected)

    def test_curso_data(self):
        self.cursor.execute("SELECT * FROM CURSO")
        results = self.cursor.fetchall()
        expected = [
            (1, 'Introducción a la programación', 4),
            (2, 'Cálculo I', 5),
            (3, 'Física General', 4)
        ]
        self.assertEqual(results, expected)

    def test_profesor_data(self):
        self.cursor.execute("SELECT * FROM PROFESOR")
        results = self.cursor.fetchall()
        expected = [
            (1, 'Ana Rodríguez', 'Ciencias de la Computación'),
            (2, 'Luis Sánchez', 'Matemáticas'),
            (3, 'Sofía Martínez', 'Física')
        ]
        self.assertEqual(results, expected)

    def test_inscripcion_data(self):
        self.cursor.execute("SELECT * FROM INSCRIPCION")
        results = self.cursor.fetchall()
        expected = [
            (1, 1, '2023-08-20'),
            (2, 2, '2023-08-20'),
            (3, 3, '2023-08-20')
        ]
        self.assertEqual(results, expected)

    def test_enseña_data(self):
        self.cursor.execute("SELECT * FROM ENSEÑA")
        results = self.cursor.fetchall()
        expected = [
            (1, 1),
            (2, 2),
            (3, 3)
        ]
        self.assertEqual(results, expected)

    def addSuccess(self, test):
        username = os.getenv('GITHUB_ACTOR', 'unknown')
        branch = os.getenv('GITHUB_REF_NAME', 'unknown')
        results = [
            {'test': test._testMethodName, 'result': 'passed', 'user': username, 'branch': branch}
        ]
        file_exists = os.path.isfile('results.csv')
        with open('results.csv', 'a', newline='') as csvfile:
            fieldnames = ['test', 'result', 'user', 'branch']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            if not file_exists:
                writer.writeheader()
            writer.writerows(results)

    def addFailure(self, test, err):
        username = os.getenv('GITHUB_ACTOR', 'unknown')
        branch = os.getenv('GITHUB_REF_NAME', 'unknown')
        results = [
            {'test': test._testMethodName, 'result': 'failed', 'user': username, 'branch': branch}
        ]
        file_exists = os.path.isfile('results.csv')
        with open('results.csv', 'a', newline='') as csvfile:
            fieldnames = ['test', 'result', 'user', 'branch']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            if not file_exists:
                writer.writeheader()
            writer.writerows(results)

    def addError(self, test, err):
        username = os.getenv('GITHUB_ACTOR', 'unknown')
        branch = os.getenv('GITHUB_REF_NAME', 'unknown')
        results = [
            {'test': test._testMethodName, 'result': 'error', 'user': username, 'branch': branch}
        ]
        file_exists = os.path.isfile('results.csv')
        with open('results.csv', 'a', newline='') as csvfile:
            fieldnames = ['test', 'result', 'user', 'branch']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            if not file_exists:
                writer.writeheader()
            writer.writerows(results)

if __name__ == '__main__':
    unittest.main(testRunner=unittest.TextTestRunner(resultclass=unittest.TextTestResult))
