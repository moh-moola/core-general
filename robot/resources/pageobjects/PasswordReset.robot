*** Settings ***
Library  SeleniumLibrary
Library  ImapLibrary
Library  String

*** Variables ***
${passwordreset.header}  id:title
${passwordreset.back_btn}  xpath://a[@href="http://${URL.${ENVIRONMENT}}/oidc/callback/"]
${passwordreset.input}  name:email
${passwordreset.submit_btn}  xpath://*//input[@value="Submit"]
${passwordreset.pwd1}  id:id_new_password1
${passwordreset.pwd2}  id:id_new_password2
${passwordreset.change_btn}  xpath://*//input[@value="Change my password"]
${passwordreset.reset_txt}  id:content
${passwordreset.django_txt}  xpath://div[@id="content"]/p[1]

*** Keywords ***
Generate Random User Password
    [Documentation]  Use this keyword to generate a random pwd. Currently used during the pwd reset flow.

    ${rnd_pwd} =  Generate Random String  5
    Set Global Variable  ${rnd_pwd}

Fill In Email
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.email}

Fill In Username
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.username}

Fill In Password
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.pwd1}  ${UserData.pwd}

Fill In Password Confirmation
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.pwd2}  ${UserData.pwd_conf}

Fill In Answer One
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.answer1}  ${UserData.first_answer}

Fill In Answer Two
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.answer2}  ${UserData.second_answer}

Click Submit
    Click Button  Submit

Back To Landing Page
    Click Element  ${passwordreset.back_btn}

Verify Reset Page Header
    Wait Until Page Contains Element  ${passwordreset.header}
    Element Text Should Be  ${passwordreset.header}  FORGOT YOUR PASSWORD?

Verify Reset Sent
    Wait Until Page Contains  We've emailed you instructions for setting your password, if an account exists with the email you entered. You should receive them shortly.

Check Reset Email
    Open Mailbox  server=imap.googlemail.com  user=jasonbarr.qa@gmail.com  password=letstest

    #${LATEST}=  Wait for Email  sender=auth@gehosting.org  timeout=120
    ${LATEST}=  Wait for Email  sender=support@govchat.org.za  subject=Invitation to join GovChat  timeout=120 
    ${body}=  Get Email Body  ${LATEST}
    Log  ${body}
    #Should Contain  ${body}  Please go to the following page and choose a new password:
    Should Contain  ${body}  You have been invited to join GovChat
    Mark All Emails As Read
    Close Mailbox

    # Pass the password reset link to a variable:
    ${link} =  Get Lines Matching Pattern  ${body}  https://authentication-service.qa-hub.ie.gehosting.org*
    Set Global Variable  ${link}

Follow Reset Link
    Go To  ${link}

Verify Password Reset Form
    Element Text Should Be  ${passwordreset.header}  PASSWORD RESET
    #Element Text Should Be  ${passwordreset.reset_txt}  Please enter your new password twice so we can verify you typed it in correctly.

    Element Should Be Visible  ${passwordreset.pwd1}
    Element Should Be Visible  ${passwordreset.pwd2}
    Element Should Be Visible  ${passwordreset.change_btn}

Submit Password Reset
    Click Element  ${passwordreset.change_btn}

Verify Django Page
    Wait Until Page Contains  Password reset complete
    Element Text Should Be  ${passwordreset.django_txt}  Your new password has been set.

Mismatch Error
    Wait Until Page Contains  The two password fields didn't match.
    Element Should Be Visible  ${passwordreset.pwd1}
    Element Should Be Visible  ${passwordreset.pwd2}

Supply Passwords
    [Documentation]  Created this to help with testing the reset lockout feature.
    [Arguments]  ${UserData}

    Fill In Password  ${UserData}
    Fill In Password Confirmation  ${UserData}
    Submit Password Reset

Enter Random Password
    [Documentation]  This keyword is used for the password reset via email flow.

    Input Text  ${passwordreset.pwd1}  ${rnd_pwd}
    Input Text  ${passwordreset.pwd2}  ${rnd_pwd}

Assert Lockout Message For Login
    Wait Until Page Contains  You have exceeded the maximum number of allowed incorrect login attempts

Assert Lockout Message For Password Reset
    Wait Until Page Contains  You have exceeded the maximum number of allowed incorrect reset attempts

Assert Incorrect Answer Message
    Wait Until Page Contains  One or more answers are incorrect

    Element Should Be Visible  ${passwordreset.answer1}
    Element Should Be Visible  ${passwordreset.answer2}

Reset Lockout Error Steps
    [Arguments]  ${UserData}

    Fill In Answer One  ${UserData}
    Fill In Answer Two  ${UserData}
    Click Submit
    Assert Incorrect Answer Message

Submit Answers
    [Arguments]  ${UserData}

    Fill In Answer One  ${UserData}
    Fill In Answer Two  ${UserData}
    Click Submit

Get Answer Field ID

    ${passwordreset.answer1} =  Get Element Attribute  xpath://*[@id="content"]/form/div[1]/div[1]/input  id
    Set Global Variable  ${passwordreset.answer1}

    ${passwordreset.answer2} =  Get Element Attribute  xpath://*[@id="content"]/form/div[2]/div[1]/input  id
    Set Global Variable  ${passwordreset.answer2}

