# FROM python

# RUN useradd microblog

# WORKDIR /home/microblog

# COPY requirements.txt requirements.txt
# RUN python -m venv venv
# RUN . venv/bin/activate && pip install --no-cache-dir -r requirements.txt
# RUN . venv/bin/activate && pip install dsutils gunicorn pymysql cryptography

# COPY app app
# COPY migrations migrations
# COPY microblog.py config.py boot.sh ./
# RUN chmod a+x boot.sh

# ENV FLASK_APP microblog.py

# RUN chown -R microblog:microblog ./
# USER microblog

# EXPOSE 5000
# ENTRYPOINT ["./boot.sh"]



# Use an official Python runtime as a parent image
FROM python

# Create a new user named 'microblog'
RUN net user microblog /add

# Set the working directory for the new user
WORKDIR C:/Users/microblog

# Copy requirements.txt to the container
COPY requirements.txt requirements.txt

# Create a virtual environment
RUN python -m venv venv

# Activate the virtual environment and install requirements
RUN . venv/Scripts/Activate \
  -r pip install --no-cache-dir -r requirements.txt
RUN . venv/Scripts/Activate \ 
  -r pip install dsutils gunicorn pymysql cryptography

# Copy the application files and scripts to the container
COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./

# Set execute permissions for the boot script
RUN powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; ./boot.sh"

# Set environment variable for Flask application
ENV FLASK_APP=microblog.py

# Change ownership of the application directory to the 'microblog' user
RUN icacls . /grant 'microblog:(OI)(CI)F'

# Switch to the 'microblog' user
USER microblog

# Expose port 5000
EXPOSE 5000

# Set the entry point for the container to run the boot script
ENTRYPOINT ["./boot.sh"]
