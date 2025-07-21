import psycopg2
from datetime import datetime
import configparser
import os


class TransactionDB:
    def __init__(self, config_path='db_config.ini'):
        config = configparser.ConfigParser()
        if not os.path.exists(config_path):
            raise FileNotFoundError(f"Config file '{config_path}' not found.")
        config.read(config_path)

        db = config['database']
        self.conn = psycopg2.connect(
            dbname=db['dbname'],
            user=db['user'],
            password=db['password'],
            host=db.get('host', 'localhost'),
            port=int(db.get('port', 5432))
        )
        self.conn.autocommit = True
        self.cursor = self.conn.cursor()

    def __enter__(self):
        return self  # makes it usable in `with` statements

    def __exit__(self, exc_type, exc_value, traceback):
        self.cursor.close()
        self.conn.close()

    def credit(self, project, amount, jobid):
        return self._insert_transaction(project, amount, jobid)

    def debit(self, project, amount, jobid):
        return self._insert_transaction(project, -abs(amount), jobid)

    def _insert_transaction(self, project, amount, jobid):
        now = datetime.now()
        query = """
            INSERT INTO transactions (project, date, amount, jobid)
            VALUES (%s, %s, %s, %s)
        """
        try:
            self.cursor.execute(query, (project, now, amount, jobid))
            return True
        except psycopg2.Error as e:
            print(f"[Error] {e}")
            return False

    def get_balance(self, project):
        query = "SELECT SUM(amount) FROM transactions WHERE project = %s"
        self.cursor.execute(query, (project,))
        result = self.cursor.fetchone()
        return result[0] if result[0] is not None else 0

    def close(self):
        self.cursor.close()
        self.conn.close()


# Example usage
if __name__ == "__main__":
    with TransactionDB() as db:
        db.credit('my_project', 250, 'job300')
        db.debit('my_project', 100, 'job301')
        balance = db.get_balance('my_project')
        print(f"Balance: {balance}")

