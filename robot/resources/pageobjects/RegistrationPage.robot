*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${header_txt} =  xpath://h1[contains(text(), "Registration")]
${registration.form_username} =  name:username
${registration.form_gender} =  name:gender
${registration.form_age} =  name:age
${registration.form_pwd1} =  name:password1
${registration.form_pwd2} =  name:password2
${registration.form_question1} =  name:form-0-question
${registration.form_answer1} =  name:form-0-answer
${registration.form_question2} =  name:form-1-question
${registration.form_answer2} =  name:form-1-answer

${registration.form_first} =  name:first_name
${registration.form_last} =  name:last_name
${registration.form_dob} =  name:dob
${registration.form_nickname} =  name:nickname
${registration.form_avatar} =  name:avatar
${registration.form_email} =  name:email
${registration.form_country} =  name:country
${registration.form_msisdn} =  name:msisdn
${registration_form.qr_code} =  xpath://*[@class="QR-image"]
${registration_form.terms} =  name:terms
${registration_form.tclink} =  xpath://a[@]
${RANDOM_PWD} =  SDF!@er45

*** Keywords ***
Create Random User
    ${RANDOM_USER} =  Generate Random String  8  [LETTERS]
    Set Global Variable  ${RANDOM_USER}
    
    #${RANDOM_PWD} =  Generate Random String  8  [LETTERS]
    #Set Global Variable  ${RANDOM_PWD}

Enter User Fields
    [Arguments]  ${type}  ${RANDOM_USER}  ${RANDOM_PWD}

    Run Keyword If  "${type}" == "end-user"  Enter End User Fields  ${RANDOM_USER}  ${RANDOM_PWD}
    ...  ELSE IF  "${type}" == "system-user"  Enter System User Fields  ${RANDOM_USER}  ${RANDOM_PWD}

Verify User Fields
    [Arguments]  ${type}

    Run Keyword If  "${type}" == "end-user"  Verify End User Fields
    ...  ELSE IF  "${type}" == "system-user"  Verify System User Fields

Enable 2FA
    Verify System User Login

Grab Code
    Set Selenium Implicit Wait  5s
    Wait Until Page Contains Element  ${registration_form.qr_code}
    ${qr_img} =  Get WebElement  ${registration_form.qr_code}
    Log  ${qr_img}

Enter End User Fields
    [Arguments]  ${RANDOM_USER}  ${RANDOM_PWD}

    Input Text  ${registration.form_username}  ${RANDOM_USER}
    Select From List By Value  ${registration.form_gender}  male
    Input Text  ${registration.form_age}  21
    Input Text  ${registration.form_pwd1}  ${RANDOM_PWD}
    Input Text  ${registration.form_pwd2}  ${RANDOM_PWD}
    Select From List By Value  ${registration.form_question1}  1 
    Input Text  ${registration.form_answer1}  xxxxxx
    Select From List By Value  ${registration.form_question2}  2
    Input Text  ${registration.form_answer2}  xxxxxx
    
    Click Element  ${registration_form.terms}

Enter System User Fields
    [Arguments]  ${RANDOM_USER}  ${RANDOM_PWD}

    Input Text  ${registration.form_username}  ${RANDOM_USER}
    Input Text  ${registration.form_first}  Robot
    Input Text  ${registration.form_last}  Framework
    Input Text  ${registration.form_email}  ${RANDOM_USER}@praekelt.com
    #Input Text  ${registration.form_country} =  name:country
    Input Text  ${registration.form_msisdn}  0712345678
    Select From List By Value  ${registration.form_gender}  male
    Input Text  ${registration.form_age}  21
    Input Text  ${registration.form_pwd1}  ${RANDOM_PWD}
    Input Text  ${registration.form_pwd2}  ${RANDOM_PWD}
    Select From List By Value  ${registration.form_question1}  1 
    Input Text  ${registration.form_answer1}  xxxxxx
    Select From List By Value  ${registration.form_question2}  2
    Input Text  ${registration.form_answer2}  xxxxxx
    
    Click Element  ${registration_form.terms}
    #Submit Form
    #Enable 2FA
    #Grab Code

Submit Form
    Click Button  Register  

Verify Registration Form
    #Wait Until Page Contains  Registration
    Wait Until Element Is Visible  ${header_txt}  

Verify System User Login
    Wait Until Page Contains  Enable Two-Factor Authentication
    Click Button  Next

Verify End User Fields
    # TODO - figure out a way to reduce this to a line of code.
    Element Should Be Visible  ${registration.form_username}
    Element Should Be Visible  ${registration.form_gender}
    Element Should Be Visible  ${registration.form_age}
    Element Should Be Visible  ${registration.form_pwd1}
    Element Should Be Visible  ${registration.form_pwd2}
    Element Should Be Visible  ${registration.form_question1}
    Element Should Be Visible  ${registration.form_answer1}
    Element Should Be Visible  ${registration.form_question2}
    Element Should Be Visible  ${registration.form_answer2}
    Element Should Be Visible  ${registration_form.terms}

    Element Should Not Be Visible  ${registration.form_first}
    Element Should Not Be Visible  ${registration.form_last}
    Element Should Not Be Visible  ${registration.form_dob}
    Element Should Not Be Visible  ${registration.form_nickname}
    Element Should Not Be Visible  ${registration.form_avatar}
    Element Should Not Be Visible  ${registration.form_email}
    Element Should Not Be Visible  ${registration.form_country}
    Element Should Not Be Visible  ${registration.form_msisdn}

Verify System User Fields

    Element Should Be Visible  ${registration.form_username}
    Element Should Be Visible  ${registration.form_gender}
    Element Should Be Visible  ${registration.form_age}
    Element Should Be Visible  ${registration.form_pwd1}
    Element Should Be Visible  ${registration.form_pwd2}
    Element Should Be Visible  ${registration.form_question1}
    Element Should Be Visible  ${registration.form_answer1}
    Element Should Be Visible  ${registration.form_question2}
    Element Should Be Visible  ${registration.form_answer2}
    Element Should Be Visible  ${registration_form.terms}
    Element Should Be Visible  ${registration.form_first}
    Element Should Be Visible  ${registration.form_last}
    #Element Should Be Visible  ${registration.form_dob}
    #Element Should Be Visible  ${registration.form_avatar}
    Element Should Be Visible  ${registration.form_email}
    Element Should Be Visible  ${registration.form_country}
    Element Should Be Visible  ${registration.form_msisdn}

    Element Should Not Be Visible  ${registration.form_nickname}

Question Usage
    [Documentation]  Each password reminder question can only be used once on the form.
    
    #TODO - Refactor to use enter end-user function.
    Input Text  ${registration.form_username}  xxxx
    Select From List By Value  ${registration.form_gender}  male
    Input Text  ${registration.form_age}  21
    Input Text  ${registration.form_pwd1}  asdf
    Input Text  ${registration.form_pwd2}  asdf
    Select From List By Value  ${registration.form_question1}  1 
    Input Text  ${registration.form_answer1}  xxxxxx
    Select From List By Value  ${registration.form_question2}  1
    Input Text  ${registration.form_answer2}  xxxxxx

    Click Element  ${registration_form.terms}

    Submit Form

    Page Should Contain  Each question can only be picked once.

    Input Text  ${registration.form_pwd1}  asdf
    Input Text  ${registration.form_pwd2}  asdf

    Select From List By Value  ${registration.form_question1}  2 
    Select From List By Value  ${registration.form_question2}  2

    Submit Form

    Page Should Contain  Each question can only be picked once.

    Input Text  ${registration.form_pwd1}  asdf
    Input Text  ${registration.form_pwd2}  asdf

    Select From List By Value  ${registration.form_question1}  1
    Select From List By Value  ${registration.form_question2}  2

    Submit Form

    Page Should Not Contain  Each question can only be picked once.
    
Password Length Error
    Set Selenium Implicit Wait  5s
    
    Run Keyword If  "${type}" == "end-user"  Wait Until Page Contains  Password not long enough.
    ...  ELSE IF  "${type}" == "system-user"  Wait Until Page Contains  This password is too short. It must contain at least 8 characters.

#The password must contain at least one uppercase letter, one lowercase one, a digit and special character.