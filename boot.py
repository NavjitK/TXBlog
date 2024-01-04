import subprocess
import time

def main():
    while True:
        # Activate the virtual environment
        subprocess.run(["venv\\Scripts\\activate"], shell=True, check=True)

        # Upgrade the database and handle failures
        result = subprocess.run(["flask", "db", "upgrade"], shell=True)
        if result.returncode == 0:
            break
        print("Deploy command failed, retrying in 5 secs...")
        time.sleep(5)

    # Compile translations
    subprocess.run(["flask", "translate", "compile"], shell=True)

    # Start the Gunicorn server
    subprocess.run(["gunicorn", "-b", ":5000", "--access-logfile", "-", "--error-logfile", "-", "microblog:app"], shell=True)

if __name__ == "__main__":
    main()
