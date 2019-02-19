*** Settings ***
Documentation     Simple example using SeleniumLibrary
Test Template     Login To The App
Library           SeleniumLibrary

*** Variables ***
${LOGIN URL}      ${URL}
${BROWSER}        Chrome
${USER}           mani
${PASSWORD}       Vedams123

*** Test Cases ***    USER NAME    PASSWORD     TITLE
Login User Exist      mani         Vedams123    Home Page - Python Django Application

Login User Not Exist
                      swathi       Vedams123    Log in - Python Django Application

*** Keywords ***
Login To The App
    [Arguments]    ${username}    ${password}    ${title}
    Open Browser to Login Page
    Input Text    id=id_username    ${username}
    Input Text    id=id_password    ${password}
    Click Button    xpath=//*[@id="loginForm"]/form/div[3]/div/input[2]
    Welcome Page Should Be Open    ${title}
    User LogOff
    Close Browser

Open Browser to Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Log in - Python Django Application

User Sign Up
    [Arguments]    ${username}    ${password}    ${email}

Welcome Page Should Be Open
    [Arguments]    ${title}
    Title Should Be    ${title}

User LogOff
    Click Element    xpath=//*[@id="logoutForm"]/ul/li[2]/a
