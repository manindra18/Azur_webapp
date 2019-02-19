*** Settings ***
Documentation     Simple example using SeleniumLibrary.
Suite Setup       Open Browser to Login Page
Suite Teardown    Close Browser
Test Template     Login To The App
Library           SeleniumLibrary

*** Variables ***
${LOGIN URL}      http://localhost:8000/login/
${BROWSER}        Chrome
${USER}           mani
${PASSWORD}       Vedams123

*** Test Cases ***    USER NAME    PASSWORD     TITLE
Login User Exist      mani         Vedams123    Home Page - Python Django Application

Login User Not Exist
                      phani        Vedams123    Log in - Python Django Application

*** Keywords ***
Open Browser to Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Log in - Python Django Application

Login To The App
    [Arguments]    ${username}    ${password}    ${title}
    Input Text    id=id_username    ${username}
    Input Text    id=id_password    ${password}
    Click Button    xpath=//*[@id="loginForm"]/form/div[3]/div/input[2]
    Welcome Page Should Be Open    ${title}

User Sign Up
    [Arguments]    ${username}    ${password}    ${email}

Welcome Page Should Be Open
    [Arguments]    ${title}
    Title Should Be    ${title}
