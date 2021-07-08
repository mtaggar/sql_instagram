USE ig_clone; 

#IDentify incative user for marketing campaign
SELECT username, 
		IFNULL(COUNT(photos.id), 0) AS total_photos, 
        IF(COUNT(photos.id) = 0, 'INACTIVE', 'ACTIVE') AS status, 
        DATE(photos.created_at) as date
FROM users
LEFT JOIN photos ON users.id = photos.user_id
GROUP BY users.id ORDER BY COUNT(photos.id), username LIMIT 10
;
#Most populas photo
SELECT COUNT(photos.id), photos.image_url, username
FROM photos
JOIN likes ON photos.id = likes.photo_id
JOIN users On photos.user_id = users.id
GROUP BY photos.id ORDER BY COUNT(likes.created_at) DESC LIMIT 1;

#Average user activity
SELECT COUNT(photos.id)/ 
		(SELECT COUNT(*) FROM users) AS AVG
FROM photos;

SELECT tag_name, COUNT(tags.id) AS total_tags
FROM tags 
JOIN photo_tags ON tags.id = photo_tags.tag_id 
GROUP BY tag_name ORDER BY COUNT(tags.id) DESC LIMIT 5;

SELECT COUNT(*) FROM photos;

SELECT username, count(likes.user_id), count(likes.photo_id), COUNT(photos.id),
		IF(COUNT(likes.user_id) = 257, 'BOT', 'Verified user') AS status
FROM likes
JOIN users ON users.id = likes.user_id
JOIN photos ON photos.id = likes.photo_id
GROUP BY users.id
HAVING count(likes.user_id) = (SELECT COUNT(*) FROM photos) LIMIT 10;
