*** Setting ***
Library             Selenium2Library

*** Variable ***
${URL_GOOGLE}     https://www.google.com/
${input_data}       //*[@id="lst-ib"]
${btn_search}        //*[@name="btnK"]

*** Keywords ***
Open Browser To Search Page
    Open Browser    ${URL_GOOGLE}    headlesschrome
    Maximize Browser Window


Search Page Should Be Open
    Input Text      ${input_data}   Test Framework

*** Test Cases ***
Search Google
    Open Browser To Search Page
    Search Page Should Be Open
    Capture Page Screenshot
    [Teardown]    Close All Browsers


