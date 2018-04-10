### Script who get info from system / disk etc. and send it to email
### Grzegorz Michalski - INVERT8
### grzegorz.michalski@invert8.com

## section | EMAIL SETTINGS

# SMTP server
$emailSmtpServer = "mail.yourcompany.com"
# SMTP user
$emailSmtpUser = "you@yourcompany.com"
# SMTP password
$emailSmtpPass = "Pass98765"
# SMTP port
$emailSmtpServerPort = "587"
# field FROM
$emailFrom = "you@yourcompany.com"
# field TO
$emailTo = "your@client.com"

# new object with smtp settings
$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
# enable / disable SSL
$SMTPClient.EnableSsl = $false
# new object with smtp creditals
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );


## section | GET INFO

# get some information from system
# on thi example I get hostname and last boot up time and save it to variable
$bootTime = Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime'

;EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}


## section | HTML BODY

# create mail body section
# html structure is required to static show information
$mailBody = "<p><table border='1' style='width:500px;'>
                <tr>
                    <td>
                        <b>
                            Computer name
                        </b>
                    </td>
                    <td>
                        <b>
                            Last boot time
                        </b>
                    </td>
                </tr>"; 
                # loop foreach iterate along $bootTime variable
                foreach ($file in $bootTime) { $mailBody += "<tr><td>" + $($file.csname) + "</td><td>" + $($file.lastbootuptime) + "</td>"; } $mailBody += "</table>"

# check the condition = if variable $bootTime is not keep going
if ($bootTime -ne $NULL)
            { 
        # email settings
        # create new object with definded settings 
        $emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
        # set subject for new mail
        $emailMessage.Subject = "This is example mail"
        # allow to add html body
        $emailMessage.IsBodyHtml = $true
        # set body contents
        $emailMessage.Body = $mailBody
        # send email
        $SMTPClient.Send( $emailMessage )
            }