sudo -u postgres psql -c "ALTER DATABASE template1 REFRESH COLLATION VERSION;"
sudo -u postgres psql -c "ALTER DATABASE postgres REFRESH COLLATION VERSION;"
sudo systemctl restart postgresql-setup
sudo systemctl restart phpfpm-roundcube