echo "Backup structure and constant tables from dev database heroku_qp6npbjk"
mongoexport -h ds157539.mlab.com:57539 -d heroku_qp6npbjk -c _SCHEMA -u heroku_qp6npbjk -p cce6ao8d9di6on7j9sqcjgeh3u -o ./cloud_database_backups/backup_structure_dev.json #dev database structure
mongoexport -h ds157539.mlab.com:57539 -d heroku_qp6npbjk -c SchemeStatus -u heroku_qp6npbjk -p cce6ao8d9di6on7j9sqcjgeh3u -o  ./cloud_database_backups/backup_scheme_status_dev.json #dev database scheme status table
mongoexport -h ds157539.mlab.com:57539 -d heroku_qp6npbjk -c PostType -u heroku_qp6npbjk -p cce6ao8d9di6on7j9sqcjgeh3u -o  ./cloud_database_backups/backup_post_type_dev.json #dev database post type table
mongoexport -h ds157539.mlab.com:57539 -d heroku_qp6npbjk -c PostCondition -u heroku_qp6npbjk -p cce6ao8d9di6on7j9sqcjgeh3u -o  ./cloud_database_backups/backup_post_condition_dev.json #dev database post condition table

echo "Backup full test database heroku_hvxz7r0p"
mongodump -h ds127531.mlab.com:27531 -d heroku_hvxz7r0p -u heroku_hvxz7r0p -p l6de7er07g2sceb4arpar2tlk6 -o  ./cloud_database_backups/ #test database backup 
echo "Compressing backup .."
zip -r  ./cloud_database_backups/test_database_full_backup_$(date "+%Y%m%d_%H%M%S")_heroku_hvxz7r0p.zip  ./cloud_database_backups/heroku_hvxz7r0p #compress the backup
rm -rf ./cloud_database_backups/heroku_hvxz7r0p/ #delete the unziped backup folder

echo "Cleaning test database heroku_hvxz7r0p"
mongo ds127531.mlab.com:27531/heroku_hvxz7r0p -u heroku_hvxz7r0p -p l6de7er07g2sceb4arpar2tlk6 --eval "db.dropDatabase()" #drop old db
echo "Importing dev database heroku_qp6npbjk strcuture and constant tables into test database heroku_hvxz7r0p"
mongoimport -h ds127531.mlab.com:27531 -d heroku_hvxz7r0p -c _SCHEMA -u heroku_hvxz7r0p -p l6de7er07g2sceb4arpar2tlk6 --file  ./cloud_database_backups/backup_structure_dev.json #test database
mongoimport -h ds127531.mlab.com:27531 -d heroku_hvxz7r0p -c SchemeStatus -u heroku_hvxz7r0p -p l6de7er07g2sceb4arpar2tlk6 --file  ./cloud_database_backups/backup_scheme_status_dev.json #test database
mongoimport -h ds127531.mlab.com:27531 -d heroku_hvxz7r0p -c PostType -u heroku_hvxz7r0p -p l6de7er07g2sceb4arpar2tlk6 --file  ./cloud_database_backups/backup_post_type_dev.json #test database
mongoimport -h ds127531.mlab.com:27531 -d heroku_hvxz7r0p -c PostCondition -u heroku_hvxz7r0p -p l6de7er07g2sceb4arpar2tlk6 --file  ./cloud_database_backups/backup_post_condition_dev.json #test database
