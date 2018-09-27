*** Settings ***
Library    Selenium2Library
*** Test Cases ***
TestBlognone
    Open Browser    https://www.blognone.com    browser=chrome
    Maximize Browser Window
    Capture Page Screenshot
    Close Browser