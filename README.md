# cdocc-dutylogs
A FiveM Script for Qbox &amp; QBCore for logging duty for jobs.

This script logs when a player goes on or off duty in a FiveM server. 
Each job has its own Discord webhook URL for logging, making it easier to manage and monitor duty status changes. 
The script sends a message to the respective Discord channel with the player's name, job, and the time they toggled their duty status. 
The messages are color-coded: green for going on duty and red for going off duty.


Set Up Discord Webhooks:

- Create a webhook in your Discord server for each job you want to monitor.
- Copy the webhook URLs.

-Add the script in your resources folder.

Configuring the Script:

- Open the config.lua file.
- Update the config.jobWebhooks table with your job names and their respective webhook URLs.
- Set the framework variable to 'qb' if you are using QBCore, or 'qbox' if you are using Qbox.

add the following to your server.cfg and then restart your server.
`ensure cdocc-dutylogs`

![image](https://github.com/user-attachments/assets/c062b2aa-f6a1-49f7-93fc-b2e39ce3c9b6)
