#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1> We are Group 2.  Private IP is $myip this is hosted in private subnet. </h1><br> Group Members:
<ul>
 	<li>Santosh Aryal</li>
	<li>Sirsha Thapa</li>
	<li>Bader Sabbah</li>
	<li>Saurav Chapagain</li>
</ul> <br>
The Images are: <br>
<img src="https://acs730-project-group2-img.s3.amazonaws.com/ilovedogs.jpg" height="50" width="50" alt="dog"> 
<img src="https://acs730-project-group2-img.s3.amazonaws.com/ilovecats.jpg" height="50" width="50" alt="cat">" >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd