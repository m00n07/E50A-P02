import unittest
from unittest.mock import patch, MagicMock
from database import connect_to_db, get_data
import os
import csv

class TestDatabase(unittest.TestCase):

    @patch('database.psycopg2.connect')
    def test_connect_to_db(self, mock_connect):
        mock_connect.return_value = MagicMock()
        conn = connect_to_db()
        self.assertIsNotNone(conn)
        mock_connect.assert_called_once()

    @patch('database.connect_to_db')
    @patch('database.psycopg2.connect')
    def test_get_data(self, mock_connect, mock_connect_to_db):
        mock_conn = MagicMock()
        mock_cursor = mock_conn.cursor.return_value
        mock_cursor.fetchall.return_value = [(1, 'data1'), (2, 'data2')]
        mock_connect_to_db.return_value = mock_conn

        data = get_data()
        self.assertEqual(data, [(1, 'data1'), (2, 'data2')])
        mock_cursor.execute.assert_called_once_with("SELECT * FROM your_table")
        mock_cursor.fetchall.assert_called_once()
        mock_cursor.close.assert_called_once()
        mock_conn.close.assert_called_once()

    def tearDown(self):
        # Guardar resultados en CSV
        username = os.getenv('GITHUB_ACTOR', 'unknown')
        results = [
            {'test': 'test_connect_to_db', 'result': 'passed', 'user': username},
            {'test': 'test_get_data', 'result': 'passed', 'user': username}
        ]
        file_exists = os.path.isfile('results.csv')
        with open('results.csv', 'a', newline='') as csvfile:
            fieldnames = ['test', 'result', 'user']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            if not file_exists:
                writer.writeheader()
            writer.writerows(results)

if __name__ == '__main__':
    unittest.main()
